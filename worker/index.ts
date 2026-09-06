// Cloudflare Worker entry. Static asset requests fall through to the ASSETS
// binding (Workers-with-Static-Assets). Only the Go vanity import paths are
// handled here.
//
// Note that the Worker only sees a request if wrangler.jsonc says so: an asset
// miss is answered with the 404 page rather than falling through, so every path
// below has to be listed in `run_worker_first`.

import { vanity } from "./vanity";

interface Env {
	ASSETS: { fetch: (request: Request) => Promise<Response> };
}

export default {
	async fetch(request: Request, env: Env): Promise<Response> {
		const url = new URL(request.url);

		// `go get moq.dev/moq` and friends, served from a mirror repo rather than
		// by this site.
		const module = vanity(url);
		if (module) return module;

		return env.ASSETS.fetch(request);
	},
};
