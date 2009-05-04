Ruby Netflix wrapper for three main API calls:

Catalog Resources - Represents all of the available media (that is, titles) in the Netflix catalog. Together, the Catalog and its subordinate resources support searches against the catalog, requests for title details, and searches for titles that have similar characteristics to a specified title.

User Resources - The User resource API provides information about specified subscribers, including rental options and history, personal ratings and recommendations, and queues. Retrieving this information generally requires authorization.  

Security Resources - The security resources are based on the OAuth Core 1.0 protocol for authenticating Netflix subscribers and for obtaining the user's authorization for your application, which consists of request and access tokens to act on the subscriber's protected Netflix resources.