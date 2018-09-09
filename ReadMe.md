Dive Logging App
Thomas Simko
Winter 2018

Minor Changes to the Project:
1. No longer using the Weather Underground API. A different API that I am using already provides the data I wished to utilize from Weather Underground.
2. The edit button has been removed from the Dive Log view because the edit view and detailed view are the same.  In addition to this, the back button is not displayed from the detailed view because instead it displays a cancel and save button for editting purposes.

Notes:
1. The dive explorer information attempts to display all of the information that I denoted in milestone 2; however, the API does not always successfully give me back all of the fields. During this failure, an error message displays giving them the option to reload the page.  However, upon multiple reloads it sometimes does not work.  This is a limitation of the free API divesites.com.
2. There is basic conflict resolution with regards to syncing local and iCloud data.  It attempts to use the one that was most recently updated.  This could be an issue however if the person logs two dives on two different devices while being offline.  However, in most reasonable cases this is the best option.
3. Currently Facebook Sharing shares a photo from the internet, but it would be useful to link to a website that shows the dive log information.
4. The app syncs to iCloud when it is opened.
