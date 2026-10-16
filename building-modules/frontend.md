# Frontend and web components

Use the current official Wippy documentation for frontend implementation:

- [Compliance checklist](https://wippy.ai/llm/path/en/frontend/micro-frontends/compliance-checklist)
- [Theming](https://wippy.ai/llm/path/en/frontend/micro-frontends/theming)
- [Web-component theming](https://wippy.ai/llm/path/en/frontend/micro-frontends/web-component-theming)
- [Web components](https://wippy.ai/llm/path/en/frontend/micro-frontends/web-component)
- [Proxy API](https://wippy.ai/llm/path/en/frontend/micro-frontends/proxy-api)

## Declare and serve a page

The module owns editable `ui/src` and the emitted `static/` bundle. Build through its Makefile and commit the served artifact.

Declare `fs.directory`, `http.static` with the host-supplied server, and `view.component` metadata: tag name, base path, entrypoint, announcement, and registration. A `ui.nav_item` with `render: component` and `component_tag` mounts the page. Inspect the declarations and verify the emitted entrypoint exists.

Use the host import map for Vue, PrimeVue, and `@wippy-fe/proxy`. Use semantic `--p-*` theme tokens. A full page host needs `display: block; height: 100%; min-height: 0`; its page root scrolls within the definite-height surface.

## State and navigation

Use named proxy getters for authenticated HTTP and host events. Read committed state from the owning endpoint. Subscribe to `component.<id>` as a wakeup and refetch; dispose the subscription on unmount. Check the selected resource before applying asynchronous results.

Navigation inside a shadow root emits a composed, bubbling event:

```ts
root.dispatchEvent(new CustomEvent('navigate', {
  detail: { path: '/deals/' + dealId },
  bubbles: true,
  composed: true,
}))
```

Use registered routes and host interfaces. Verify dialogs and overlays inside iframe documents and nested shadow roots.

## Verify the served result

Open the application shell, navigate through the feature, and inspect console and network failures after material interactions. Confirm the rendered data matches committed backend state. An entrypoint 404 requires checking the registry declaration, mount, build owner, and emitted file; a 5xx requires checking the backend service and route.
