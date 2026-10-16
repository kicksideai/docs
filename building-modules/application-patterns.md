# Application patterns

Choose the smallest resource boundary that needs independent ownership or access.

| Requirement | Pattern |
| --- | --- |
| Stateless utility page | Web component and navigation declaration |
| Saved, shared, or independently deleted resource | Component kind |
| Many records under one access root | Component plus module-owned tables |
| Durable facts or cross-feature triggers | Primary thread and declared events |
| List status and counts | Public component metadata |
| Private configuration | Private component context |
| External account | Provider connection |
| Reusable Flow step | Block |
| Ongoing source/destination behavior | Automation ports |

A saved workbook can be a Component with formulas in private context, run rows in domain tables, and status in public metadata. A business application can keep contacts and line items as rows under an independently shared root. Create a Component for a record only when it needs its own ACL, lifecycle, placement, or workflow ownership.

Use a thread for an aggregate or durable process that needs event semantics. Ordinary row updates need not become events unless audit, projection, waits, or Automation requires them.

Keep a module's SQL behind its contracts. Split packages when their lifecycle, dependencies, or release cadence differ. Splitting files does not require splitting packages.
