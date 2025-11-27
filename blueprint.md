# Project Blueprint: BOX BEE

## Overview

This document outlines the architecture, design, and features of the "BOX BEE" Flutter application. Its purpose is to serve as a single source of truth for the project's development.

## Implemented Features

### Version 1.0

*   **Application Shell:**
    *   Setup with `go_router` for declarative navigation.
    *   Basic theme with `primarySwatch` set to blue.
*   **Splash Screen (`/splash` - previously `/`):
    *   Displays a branded splash screen with the title "BOX BEE" and a central gavel icon.
    *   Automatically navigates to the sign-up screen after a 5-second delay.
*   **Sign-Up Screen (`/signup`):
    *   A welcome screen with a "Get Started" button.
    *   A "Log in" text button that navigates to the `LoginScreen`.
*   **Login Screen (`/`):
    *   Set as the initial route of the application.
    *   Features input fields for email and password.
    *   Includes a "Log in" button, "Forgot Password" option, and a "Sign Up" link.
    *   The "Sign Up" link navigates to the `UserRegisterScreen`.
*   **User Register Screen (`/user-register`):
    *   A registration form with fields for name, email, and password.
    *   Includes a "Register" button that navigates to the `OTPScreen`.
    *   An "I have an account! Log in" link that navigates back to the `LoginScreen`.
*   **OTP Screen (`/otp`):
    *   A verification screen with the title "Verification Code."
    *   Displays four OTP input boxes.
    *   Includes a "Complete" button that navigates to the `DashboardScreen`.
*   **Dashboard Screen (`/home`):
    *   A dashboard UI with a top bar for stories, a feed of posts, and a bottom navigation bar.
    *   The stories section displays a horizontal list of user avatars.
    *   The feed displays cards for different content types (post, auction, product).
    *   Post cards are tappable and navigate to the `PostViewScreen`.
    *   Product cards are tappable and navigate to the `ProductScreen`.
    *   The bottom navigation bar includes icons for home, search, add, store, and gavel.
    *   The "store" icon in the bottom navigation bar navigates to the `StoreCategoryScreen`.
    *   The "gavel" icon in the bottom navigation bar navigates to the `AuctionCategoryScreen`.
*   **Post View Screen (`/post-view`):
    *   A screen that displays a detailed view of a post, matching the provided UI.
    *   Features a profile header, a post card with action icons, a description box, and other interactive elements.
*   **Product Screen (`/product`):
    *   A product detail screen with a profile header, product image, description, and action icons.
    *   The header displays user information and an "Edit Profile" button.
    *   The profile header is tappable and navigates to the `ProfileScreen`.
    *   The product card shows the product image, title, price, and like/add-to-cart buttons.
    *   Includes a description box and a row of action icons.
*   **Profile Screen (`/profile`):
    *   A user profile screen with a header and a feed of the user's posts.
    *   The header displays the user's avatar, name, bio, website, and an "Edit Profile" button.
    *   The feed displays a list of the user's posts, auctions, and products.
*   **Store Category Screen (`/stores`):
    *   A screen that displays a list of store categories with a design that matches the provided UI.
    *   The header has been updated to accurately reflect the logo and typography.
    *   The category list now has corrected font colors and styling.
    *   Tapping a category button navigates to the `StoreProductsScreen`, passing the category name as a parameter.
    *   Corrected the invalid `GoogleFonts.serif` to `GoogleFonts.lora`.
*   **Store Products Screen (`/store-products/:categoryName`):
    *   A screen that displays a grid of products for a given category.
    *   The screen includes placeholder product data.
    *   The app bar displays the category name and includes a back button.
    *   Corrected the invalid `GoogleFonts.serif` to `GoogleFonts.lora`.
*   **Auction Category Screen (`/auction`):
    *   A screen that displays a list of auction categories with a design that matches the provided UI.
    *   The header features a unique icon and typography.
    *   The gavel icon in the `DashboardScreen`'s bottom navigation bar now navigates to this screen.
    *   Tapping an auction category now navigates to the `AuctionViewScreen`.
*   **Auction View Screen (`/auction-view`):
    *   A screen that displays a detailed view of an auction, matching the provided UI.
    *   Features a profile header, an auction card with a timer and bidding controls, a list of bidders, and the current bid amount.
*   **Navigation Routes:**
    *   `/`: `LoginScreen`
    *   `/home`: `DashboardScreen`
    *   `/signup`: `SignUpScreen`
    *   `/register`: `RegisterScreen` (Note: This was the previous registration screen, now replaced by `/user-register` in the flow).
    *   `/user-register`: `UserRegisterScreen`
    *   `/otp`: `OTPScreen`
    *   `/post-view`: `PostViewScreen`
    *   `/product`: `ProductScreen`
    *   `/profile`: `ProfileScreen`
    *   `/stores`: `StoreCategoryScreen`
    *   `/store-products/:categoryName`: `StoreProductsScreen`
    *   `/auction`: `AuctionCategoryScreen`
    *   `/auction-view`: `AuctionViewScreen`

## Current Plan

A new `PostViewScreen` has been created to display a detailed view of a post. The UI matches the provided image. Navigation has been set up from the `DashboardScreen` to the new `PostViewScreen`.

### Next Steps:

Waiting for the next user request.
