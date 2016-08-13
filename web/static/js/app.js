import {Socket, LongPoller} from "phoenix";

let socket = new Socket("/socket", {
    logger: (kind, msg, data) => {
	console.log(`${kind}: ${msg}`, data);
    },
    params: {token: window.userToken}
});

socket.connect();
socket.onOpen( () => console.log('socket connected ') );

export var App = {
    run: function(){

	let editor = new Quill("#editor");
	
	let docForm = $("#doc-form");

	docForm.on("submit", e => {
	    //alert("dat submit");
	    $("#body-input").val(editor.getHTML() );
	    
	    // e.preventDefault();
	    //save(docChan, editor);
	    //true;
	});

	let save =  function(docChan, editor) {
	    let body  = editor.getHTML();
	    let title = $('#document_title').val();
	    docChan.push("save", {body: body, title: title})
		.receive("ok",    resp   => console.log("saved", resp) );
	};

	let appendMessage = function(docChan, msg, msgContainer) {
	    if(docChan.params["last_message_id"] < msg.id) {
		docChan.params["last_message_id"] = msg.id;
	    }
	    msgContainer.append(`<br/> ${msg.body}`);
	    msgContainer.scrollTop(msgContainer.prop("scrollHeight"));
	};

	
	let docId  = $('#doc-form').data('id');
	if(!docId) {
	    console.log("can't find docId - bailing");
	    return;
	}
	
	let docChan = socket.channel("documents:" + docId);
	docChan.params["last_message_id"] = 0;

	let msgContainer = $('#messages');
	let msgInput     = $('#message-input');
	
	let saveTimer = null;
	
	msgInput.on('keypress', e => {
            if(e.which !== 13) { return; };
	    
            docChan.push("new_message", {body: msgInput.val()});
            msgInput.val("");
	});
	
	editor.on('keydown', e => {
            if(!(e.which === 13 && e.metaKey)) { return; };

            let {start, end} = editor.getSelection();
            let expr         = editor.getText(start, end);
	    
            docChan.push("compute_img", {expr, start, end});
	});

	docChan.on("insert_img", ({url, start, end}) => {
	    console.log(arguments);
	    editor.deleteText(start, end);
	    editor.insertEmbed(start, 'image', url);
	});

	docChan.on("new_message", msg => {
	    appendMessage(docChan, msg, msgContainer);
	});

	editor.on("text-change", (ops, source) => {
	    if(source !== "user"){ return; };
	    clearTimeout(saveTimer);
	    saveTimer = setTimeout(() => {
		save(docChan, editor);
	    }, 2500);

	    //snake case event names are idiomatic
	    docChan.push("text_change", {ops: ops});
	});

	docChan.on("text_change", ({ops}) => {
	    editor.updateContents(ops);
	});

	docChan.join() //{last_message_id: Xxx} to help ids
	    .receive("ok",    resp    => console.log("Joined.") )
	    .receive("error", reason  => console.log("join error", reason) );
	
	docChan.on("messages", ({messages}) => {
	    //fired on every join
	    messages.forEach( m => {
		appendMessage(docChan, m, msgContainer);
	    });
	});
    }
};
