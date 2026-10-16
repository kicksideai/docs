# CRM

CRM 0.4.1 provides typed records, relations, imports, search, and schema editing. A fresh CRM has an empty schema: it does not supply a company, contact, or opportunity schema by itself.

The screenshots show a fictional sales schema with companies, people, and deals configured for a demonstration workspace.

## Configure records

Install a business module that declares the objects and collections you need, or configure the schema through CRM's schema editor. The schema defines fields, types, relations, and collection views.

{{ screenshot:crm/schema.png }} Review consuming modules before changing a shared field.

Open a configured collection, create a record with its required fields, and save it. Open the saved record to inspect its fields, related records, and timeline. Available tables or boards follow the declared views.

{{ screenshot:crm/records.png }}

{{ screenshot:crm/board.png }}

{{ screenshot:crm/timeline.png }}

## Import and synchronize

Use the collection's supported import controls or a configured Automation destination. CRM's writable contract also accepts writes from other modules. Check the import or Automation outcome and the resulting record; a source event alone does not prove a destination write.

CRM contributes agent tools and Blocks for record operations, alias resolution, and merge review. A merge review can wait for a human decision through a durable Flow.

See the [CRM module contracts](https://github.com/kicksideai/crm/blob/main/docs/module.md) and [field configuration](https://github.com/kicksideai/crm/blob/main/docs/field-config.md).
