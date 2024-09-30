
# Project Overview

This project utilizes **SwiftData** as the database solution for managing and persisting data. Below is a breakdown of the key components and functionality:

## Database Structure

- **Database Used**: SwiftData
- **Data Models**: All data models used within this project are defined in the `SwiftData_Models.swift` file.
  - The models are structured according to the requirements of SwiftData, enabling the creation of tables and relationships in the database.

## CRUD Functionality

- All **CRUD (Create, Read, Update, Delete)** operations are implemented within the `SwiftData_functions.swift` file.
  - These functions handle interactions with the database

## Data Handling

- **Retrieving and Saving Data**: SwiftData is used for both retrieving data from and saving data to the database.
  - The CRUD functions efficiently perform these operations, ensuring that the data is always in sync with the application's state.

## UI Display

- The data retrieved from the database is displayed using **simple Swift structs** for better separation of concerns and a more streamlined UI logic.
  - These structs serve as lightweight data containers, providing a clean and efficient way to manage the data for display purposes.

## File Structure

- `SwiftData_Models.swift`: Contains all the SwiftData models representing the database tables.
- `SwiftData_functions.swift`: Implements all CRUD operations to interact with the SwiftData database.
