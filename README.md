# Test Consulting Academy - Automated Tests

Automated UI testing suite for the Test Consulting Academy website using Robot Framework and Playwright.

## Project Overview

This project contains end-to-end tests for the Test Consulting Academy platform, covering critical user workflows including:
- Booking training courses
- Searching for trainings by type (Atlassian, KI, etc.)
- Contact form validation
- Header search functionality

## Technology Stack

- **Robot Framework** (6.1.1) - Test automation framework
- **Playwright/Browser Library** - Browser automation
- **Python** (3.12+)
- **YAML** - Locator management
- **PyYAML** - YAML file handling

## Project Structure

```
RobotFramework/
├── tests/
│   └── test_openpage.robot          # Main test cases
├── keywords/
│   ├── keywords.robot               # Test keywords (Open Homepage, booking, form filling, etc.)
│   ├── resources.robot              # Browser Library wrapper keywords
│   └── resources_shared.robot       # Library imports and shared resources
├── locators/
│   ├── home_page.yaml              # Home page element locators
│   └── header_footer.yaml          # Header/footer element locators
├── browser/                         # Browser trace recordings
├── video/                           # Test execution videos
├── requirements.txt                 # Python dependencies
└── README.md                        # This file
```

## Setup Instructions

### Prerequisites
- Python 3.12 or higher
- pip package manager

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/SonerCeremesiz/RobotFramework.git
   cd RobotFramework
   ```

2. Create a virtual environment (optional but recommended):
   ```bash
   python -m venv .venv
   .venv\Scripts\activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Running Tests

Run all tests:
```bash
robot tests/test_openpage.robot
```

Run specific test case:
```bash
robot --test "Book a Training" tests/test_openpage.robot
```

Run with specific browser (headless mode):
```bash
robot tests/test_openpage.robot
```

## Test Cases

### 1. Book a Training
- Opens company training page
- Selects a consulting appointment
- Fills out contact form with test data
- Verifies booking success message

### 2. Verify Different Types of Training
- Navigates to all trainings section
- Searches for "Atlassian" training
- Searches for "KI" training

### 3. Validate Contact Form
- Opens company training page
- Selects consulting appointment
- Verifies form validation errors when submitting empty form

### 4. Test Header Search
- Uses header search to find trainings
- Verifies search results display
- Opens training page from results

## Locator Management

Locators are organized in YAML files for easy maintenance:

- **locators/home_page.yaml** - Homepage elements (buttons, links, forms)
- **locators/header_footer.yaml** - Header and footer navigation elements

Locators are imported as Robot Framework variables and used throughout test keywords.

## Test Output

After test execution, the following reports are generated:

- `report.html` - High-level test report
- `log.html` - Detailed execution log
- `output.xml` - Machine-readable test results
- `video/` - Screen recordings of test execution
- `browser/traces/` - Playwright browser traces (for debugging)

Open `report.html` in a browser to view results.

## Libraries Used

- **Browser** - Playwright-based browser automation
- **RequestsLibrary** - HTTP requests handling
- **JSONLibrary** - JSON data handling
- **DependencyLibrary** - Test dependency management
- **ScreenCapLibrary** - Screenshot capture
- **FakerLibrary** - Test data generation
- **SSHLibrary** - SSH operations
- **Collections** - List/dictionary operations
- **DateTime** - Date and time operations

## Keywords

### Setup & Teardown (keywords.robot)

- `Setup Test Environment` - Initialize browser, navigate to site, and accept cookies
- `Teardown Test Environment` - Close browser after test
- `Set Video Path` - Configure video recording path with timestamp
- `Accept Cookie Policy` - Handle cookie consent banner

### Navigation Keywords (keywords.robot)

- `Navigate To Company Training` - Navigate to company training section
- `Navigate To All Trainings` - Navigate to all trainings page
- `Open Training Details Page` - Open training details page with appointment verification

### Form Operations (keywords.robot)

- `Select Consulting Appointment` - Select consulting appointment
- `Fill Contact Form` - Complete contact form with test data
- `Verify Contact Form Validation Errors` - Validate form error messages when submitting empty form
- `Verify Booking Confirmation Message` - Verify successful booking message

### Search Operations (keywords.robot)

- `Search Training By Keyword` - Search trainings using footer search field
- `Search Using Header Search Field` - Search using header search functionality
- `Verify Search Results` - Validate search results by URL

### Browser Library Wrappers (resources.robot)

Custom wrapper keywords for Browser Library functions:

- `Wait Until Location Contains` - Wait for URL to contain specific text
- `Wait Until Location Does Not Contain` - Wait for URL to not contain specific text
- `Wait Until Element Is Visible` - Wait for element to be visible
- `Wait Until Element Is Not Visible` - Wait for element to be hidden

## Environment Variables

The test suite uses the following environment settings:

- **URL**: `https://www.testconsulting-academy.de`
- **Browser**: Chromium
- **Headless Mode**: False (visible browser window)
- **Viewport**: 1440x900

## Troubleshooting

### Test Fails to Start
- Ensure all dependencies are installed: `pip install -r requirements.txt`
- Verify Python version: `python --version`

### Browser Won't Open
- Check that Chromium is available (Browser library handles this)
- Ensure no other processes are blocking port usage

### Locator Errors
- Verify locator files exist in `locators/` directory
- Check YAML syntax is valid

## Contributing

1. Update tests in `tests/test_openpage.robot`
2. Add new keywords to `keywords/keywords.robot`
3. Update locators in respective YAML files in `locators/`

## License

Proprietary - Test Consulting