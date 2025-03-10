# sanitized slan cheat menu

1.1.0: incorporates mapeditor

# X4 7.14 Mod Development Setup

---

## 1. Install

### Install [VSCode](https://code.visualstudio.com/download) and two extensions. It's amazing

#### Install VSCode Extensions

- Extension 1: Install your favorite xml extension
  - **Extension**: xml red hat
  - **Install Method**: In VSCode, click extensions tab, search for xml red hat, click install.

- Extension 2: To enhance your development experience, you can manually install the **X4CodeComplete**:
  - **Extension**: [X4CodeComplete.vsix](https://github.com/Cgettys/X4CodeComplete/releases)
  - **Install Method**: In VSCode, choose install from file. Press Ctrl+, paste this into the box 'x4CodeComplete.unpackedFileLocation' add path to the vanilla extracted files.

### Install Node.js and npm via VSCode terminal

Ensure that Node.js and npm are installed on your system. Use the following commands to check if they are already installed:

```bash
node -v
npm -v
```

If Node.js and npm are not installed, follow these steps:

#### Install Node.js and npm

- Visit the [official Node.js website](https://nodejs.org/) and download the appropriate version for your operating system.
- Follow the installation instructions on the website.

#### Verify Installation

After installation, check the versions of Node.js and npm again to confirm the installation:

```bash
node -v
npm -v
```

---

## 2. Setup Environment

### Install Project Dependencies

In your project folder, run the following command to install all the necessary dependencies specified in your `package.json` file:

```bash
npm install
```

This will ensure that all required libraries and packages are installed for your project to function correctly.

### Setup 'package.json' Script

```json
{
  "scripts": {
    "{scriptname}": "npx ts-node compileMod.ts {mod_folder}"
  }
}
```

This script will allow you to compile your mod with a single command.

---

## 3. Handling Diffs

When creating diffs, use the following file path structure to ensure the correct schema is referenced:

- **MD files**: `../../xsd/mddiff.xsd`.
- **AIScript files**: `../../xsd/aiscriptdiff.xsd`.

This allows for the proper schema to be used during the diffing process.

---

## 4. Required Files for Compilation

To compile your mod, you must include an `allowedextensions` file in the root directory of your mod. This file specifies which file types will be added to the release .zip, helping ensure that only production-ready files are included in the final output.

This approach allows you to have **dev-only files** during development, while keeping the production version clean.

---

## 5. Compile Your Mod

To compile your mod into a `.zip` file, simply run the corresponding npm script:

```bash
npm run {scriptname}
```

---

### 6. Profit
