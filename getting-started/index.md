# Install and sign in

## Install Wippy

Install the Wippy CLI on Linux or macOS:

```sh
curl -fsSL https://hub.wippy.ai/install.sh | bash
wippy version
```

On Windows, download the executable from [Wippy releases](https://hub.wippy.ai/releases) and add its directory to `PATH`. The [Wippy installation guide](https://wippy.ai/en/start/installation/) lists platform requirements.

## Start KickSide

Create a directory for the installation and run the published application:

```sh
mkdir kickside
cd kickside
wippy run kickside/kickside -c --profile quickstart
```

Open `http://localhost:8085`. A fresh quickstart installation creates `admin@kickside.local` with password `kickside-admin`. Sign in and change that password in **System → Users**. Bootstrap credentials apply only to the first boot; restarting with different bootstrap values does not reset an existing account.

Keep the installation directory. It contains the resolved module lock, application database, durable SQLite registry history, uploads, and encryption key. PostgreSQL deployments configure the application connection and registry-history DSN separately; see the [application reference](https://github.com/kicksideai/kickside/blob/main/app/README.md#postgres). Restart from that directory:

```sh
wippy run -c --profile quickstart
```

## Set up the workspace

The first-login wizard has six steps:

1. **Name your workspace** sets the name shown in the header and login screen.
2. **Add your logo** accepts a square image and selects sidebar or top-bar navigation.
3. **Connect your AI model** configures a model provider and assigns model classes.
4. **Pick your instruments** selects capability bundles, shows their combined package list, and installs them together.
5. **Connect an external agent** configures access for an external client.
6. **You're ready to go** completes setup.

The logo, model, and external-agent steps offer **Skip for now**. At the instrument step, review the available bundles or browse packages. Configure models later in **System → Models**, branding in **System → Appearance**, and packages in **System → Modules**. An administrator can reopen setup from Appearance.

Continue with [your first agent](first-agent.md). For external services, see [connect a provider](first-connection.md); for additional features, see [install a module](first-module.md).
