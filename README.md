# CarMeetMVP

A SwiftUI MVP for a map-first car enthusiast platform. The app is designed to feel closer to a live Forza Horizon-style world map than a normal social feed.

## What is included

- Live map as the first screen
- Nearby enthusiast builds shown as tappable car pins
- Meetup and promoted business event pins on the map
- User garage/profile screens
- Car builds with photo placeholders, specs, modifications, status, and upvotes
- Build upvoting with local mock state
- Meetup list, detail screens, create form, and join/leave action
- Business profiles for workshops, detailers, tuners, tire shops, parts stores, and track organizers
- Business profile fields for contact info, website/social links, location, premium status, and promotion tier
- Business-hosted promoted events with images, attendee lists, location, and time
- Data models shaped for future Firebase and monetization work

## Current tabs

- Map: the main live experience with car, meetup, and business pins
- Builds: ranked build discovery without making the app feel like a traditional feed
- Meets: promoted and community meetups
- Garage: the current user's profile and builds

## Xcode setup

1. Open `CarMeetMVP.xcodeproj` in Xcode.
2. Set a development team if Xcode asks for signing.
3. Run the `CarMeetMVP` scheme on an iOS 17 or newer simulator.

## Firebase-ready structure

The current `MockCarSocialStore` owns all mock data and mutations. When adding Firebase later, keep the models and views mostly intact, then replace the store methods with a repository or service that reads and writes Firestore documents.

Suggested future Firebase collections:

- `users`
- `businesses`
- `builds`
- `liveBuildLocations`
- `events`
- `eventAttendees`
- `buildUpvotes`

## Monetization-ready structure

Payments are not implemented. The models already include `PromotionTier`, `isPromoted`, and `isPremium` so promoted events and premium business profiles can be connected to a paid flow later.

Not included yet: payments, chat, live GPS, or OBD integrations.
