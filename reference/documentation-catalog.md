# Registry documentation catalog

A published page is a `registry.entry` with `meta.type: wippy.documentation.page`. Its data carries Markdown `content`, path, title, document kind, and status.

A `wippy.documentation.navigation` entry declares the Hub sidebar tree. It references stable page registry IDs and owns grouping, order, labels, and visibility without duplicating page bodies.

Discover pages through the registry:

```lua
local pages, err = registry.find({
    [".kind"] = "registry.entry",
    ["meta.type"] = "wippy.documentation.page",
})
if err then return nil, err end
```

`app:documentation` supplies list/read convenience methods over those records. Hub renders the same records. RFC records use `document_kind: rfc` and explicit lifecycle status. Registry metadata discovery does not imply full-text content search.
