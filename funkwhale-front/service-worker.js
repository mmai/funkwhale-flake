importScripts("/front/precache-manifest.41fec106e5ecf31f106c0329d13c7cf3.js", "/front/workbox-v4.3.1/workbox-sw.js");
workbox.setConfig({modulePathPrefix: "/front/workbox-v4.3.1"});
// This is the code piece that GenerateSW mode can't provide for us.
// This code listens for the user's confirmation to update the app.
workbox.loadModule('workbox-routing');
workbox.loadModule('workbox-strategies');
workbox.loadModule('workbox-expiration');

self.addEventListener('message', (e) => {
  if (!e.data) {
    return;
  }
  console.log('[sw] received message', e.data)
  switch (e.data.command) {
    case 'skipWaiting':
      self.skipWaiting();
      break;
    case 'serverChosen':
      self.registerServerRoutes(e.data.serverUrl)
    default:
      // NOOP
      break;
  }
});
workbox.core.clientsClaim();

const router = new workbox.routing.Router();
router.addCacheListener()
router.addFetchListener()

var registeredServerRoutes = []
self.registerServerRoutes = (serverUrl) => {
  console.log('[sw] Setting up API caching for', serverUrl)
  registeredServerRoutes.forEach((r) => {
    console.log('[sw] Unregistering previous API route...', r)
    router.unregisterRoute(r)
  })
  if (!serverUrl) {
    return
  }
  var regexReadyServerUrl = serverUrl.replace('.', '\\.')
  registeredServerRoutes = []
  var networkFirstPaths = [
    'api/v1/',
    'media/',
  ]
  var networkFirstExcludedPaths = [
    'api/v1/listen'
  ]
  var strategy = new workbox.strategies.NetworkFirst({
    cacheName: "api-cache:" + serverUrl,
    plugins: [
      new workbox.expiration.Plugin({
        maxAgeSeconds: 24 * 60 * 60 * 7,
      }),
    ]
  })
  var networkFirstRoutes = networkFirstPaths.map((path) => {
    var regex = new RegExp(regexReadyServerUrl + path)
    return new workbox.routing.RegExpRoute(regex, () => {})
  })
  var matcher = ({url, event}) => {
    for (let index = 0; index < networkFirstExcludedPaths.length; index++) {
      const blacklistedPath = networkFirstExcludedPaths[index];
      if (url.pathname.startsWith('/' + blacklistedPath)) {
        // the path is blacklisted, we don't cache it at all
        console.log('[sw] Path is blacklisted, not caching', url.pathname)
        return false
      }
    }
    // we call other regex matchers
    for (let index = 0; index < networkFirstRoutes.length; index++) {
      const route = networkFirstRoutes[index];
      let result = route.match({url, event})
      if (result) {
        return result
      }
    }
    return false
  }

  var route = new workbox.routing.Route(matcher, strategy)
  console.log('[sw] registering new API route...', route)
  router.registerRoute(route)
  registeredServerRoutes.push(route)
}

// The precaching code provided by Workbox.
self.__precacheManifest = [].concat(self.__precacheManifest || []);

// workbox.precaching.suppressWarnings(); // Only used with Vue CLI 3 and Workbox v3.
workbox.precaching.precacheAndRoute(self.__precacheManifest, {});

