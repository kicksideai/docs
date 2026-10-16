# Uploads

Open **Uploads**, add a supported file, and open its entry to inspect processing state and preview. Installed upload types and converters determine supported formats and derived content.

Processing uses background jobs. A queued file can remain pending while a worker is busy. Inspect a failure before retrying; model-assisted conversion also requires model configuration.

Other features use the file through Uploads' content interfaces or signed tokens. Uploads stores original bytes, derived artifacts, and metadata. Keep all of these with the installation's database and encryption key when preserving an installation.

**System → Settings → Files & Uploads** supplies the installed processing and storage controls. See [knowledge](knowledge.md) for searchable ingestion and [chat](chat-and-artifacts.md) for attachments and artifacts.
