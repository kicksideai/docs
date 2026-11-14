# Frontend and web components

Use the current official Wippy documentation for frontend implementation:

- [Compliance checklist](https://wippy.ai/en/frontend/micro-frontends/compliance-checklist)
- [Theming](https://wippy.ai/en/frontend/micro-frontends/theming)
- [Web-component theming](https://wippy.ai/en/frontend/micro-frontends/web-component-theming)
- [Web components](https://wippy.ai/en/frontend/micro-frontends/web-component)
- [Proxy API](https://wippy.ai/en/frontend/micro-frontends/proxy-api)

## Declare and serve a page

The module owns editable `ui/src` and the emitted `static/` bundle. Build through its Makefile and commit the served artifact.

Declare `fs.directory`, `http.static` with the host-supplied server, and `view.component` metadata: tag name, base path, entrypoint, announcement, and registration. A `ui.nav_item` with `render: component` and `component_tag` mounts the page. Inspect the declarations and verify the emitted entrypoint exists.

Externalize only the packages in the module’s established host contract; keep other dependencies bundled. Use semantic `--p-*` theme tokens. A full page host needs `display: block; height: 100%; min-height: 0`; its page root scrolls within the definite-height surface.

## Load the implementation on first use

Keep the entry small, so a registered tag costs little at startup. The entry holds the element class, its schema, `webComponent()` and `define(import.meta.url, Element)`. The root component and its imports sit behind a dynamic `import()`. An entry imports only types from any module the lazy code also uses.

Choose the loader for the surface:

- A page or large panel returns its mount configuration from `vueConfig.lazyConfig`, with the root component and its plugins in a module beside the entry. The wrapper shows `wippy-loading` during the import. That loader takes the viewport height as an only child, so set `wippy-loading, wippy-error { height: 100%; }` in the component's stylesheet.
- A compact control uses `defineAsyncComponent` as its `rootComponent`, with a small loading root and a failure root. Mark both with `data-lazy-state`, as KickSide's `lazy.ts` does, and reserve the control's loaded height while it loads or fails, with `:host > div:empty, :host > div:has(> [data-lazy-state])`. Measure that height at the width where the tag is placed. Reserve height only, because the parent sets the width. A permanent minimum on `:host` leaves blank space on a loaded tag that renders shorter or empty. A tag that can render nothing after it loads cannot use `:empty`, because Vue's comment placeholder still matches it, so show its loader without a delay. Keep the component's layout while its own data loads, and reserve a child tag's height in the parent until the child is registered.
- A headless coordinator or a small component can stay eager. Record the measured reason.

Keep the declared error contract. A `lazyConfig` rejection emits `error` with `{ message }` only, so a component that declares more fields catches the rejection and returns a mount configuration whose root emits the declared detail. Preserve the existing lifecycle contract: `ready` and `load` follow the real implementation mount. Lazy roots require a wrapper release that awaits that mount and removes pending loaders on disconnect; a wrapper that reports readiness on connection does not satisfy this contract.

Build settings:

- `external` retains the module’s previous published dependency list. A newer Host import-map snapshot does not widen that list. Newly externalized dependencies require an explicit Host contract and a lower-bound Host dependency; otherwise bundle them. Browser import maps have no `primevue/*` wildcard, and PrimeVue CSS still comes from `hostCssKeys`.
- `preserveEntrySignatures: 'strict'` keeps `webComponent()`, which the Host factory path requires.
- Eager builds keep their runtime in the entry. For lazy builds, `output.manualChunks` shares `@wippy-fe/webcomponent-*` and eager theme dependencies. Without it, a lazy chunk can import the entry back without the Host's `?declare-tag=` query, and a second copy of the entry runs.

Measure cold-cache requests per entry. Lazy roots must add one deferred implementation request without extra eager dependencies; a shared runtime that adds an eager request remains a release blocker.

Inspect the emitted entry after building. It must contain its own `import.meta.url` and the `webComponent` export, and no chunk may import an entry file.

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
