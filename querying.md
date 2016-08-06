
List all docs

```
alias Docs.{Document, Message,Repo}
import Ecto.Query
query = from d in Document
Repo.all query
```


```
Repo.all(from d in Document,  where: d.author == "dave" )
```
