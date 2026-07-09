# API Data Explorer - Flutter Assignment 🚀

A complete Flutter application demonstrating REST API integration, Local Offline Caching, State Management, and Full CRUD operations with a modern and clean User Interface.

## 🎯 Objective
The purpose of this project is to build a real-world Flutter application by consuming a public REST API, managing state efficiently, and ensuring data availability in offline mode using local storage.

## 🔗 API Used
- **Source:** [JSONPlaceholder](https://jsonplaceholder.typicode.com/)
- **Endpoint:** `/posts`
- **Reason for selection:** Excellent for demonstrating read operations along with full dummy CRUD functionality.

## ✨ Features Implemented
- **Full CRUD Operations:** Add, Edit, Delete, and Read posts seamlessly.
- **Local Offline Caching:** Data is automatically saved locally. The app works perfectly without an internet connection using cached data.
- **State Management:** Efficient and reactive state management using `Provider`.
- **Pagination & Load More:** Fetches data in chunks (10 items per page) to optimize performance.
- **Advanced Search:** Real-time filtering of data by title or body.
- **Bonus Features Included:**
  - 🌙 **Dark Mode / Light Mode** toggle.
  - ❤️ **Favorites System** (persisted locally).
  - 🔄 **Pull-to-Refresh** functionality.
  - 📊 **Sorting Options** (by ID or Alphabetically).

## 📦 Packages Used
| Package Name | Version | Purpose |
| :--- | :--- | :--- |
| `http` | ^1.2.0 | To handle network requests and API integration. |
| `provider` | ^6.1.2 | For global state management and dependency injection. |
| `hive` | ^2.2.3 | NoSQL lightweight database for local offline caching. |
| `hive_flutter`| ^1.1.0 | Hive extension specifically for Flutter applications. |

## 📸 Screenshots
*(Note to student: Add your screenshot images in a `screenshots` folder and replace the links below)*

| Home Screen (Light) | Home Screen (Dark) | Detail Screen |
| :---: | :---: | :---: |
| <img src="screenshots/home_light.png" width="200"/> | <img src="screenshots/home_dark.png" width="200"/> | <img src="screenshots/detail.png" width="200"/> |

## 🚀 How to Run the Project

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/your-username/your-repo-name.git](https://github.com/your-username/your-repo-name.git)