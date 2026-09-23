# Java Development Setup for Neovim

## What's Configured

### LSP Support
- **nvim-jdtls**: Eclipse JDT Language Server integration
- **Mason**: Automatic installation of `jdtls` (mason-lspconfig) and `google-java-format` (mason-tool-installer)
- **Project Detection**: Automatically detects Maven/Gradle projects
- **Workspace Management**: Creates separate workspaces per project

### Code Formatting
- **conform.nvim**: Modern formatter plugin
- **google-java-format**: Google Java Style formatting with AOSP style (4-space indentation)
- **Integration**: Works with your existing `<leader>cf` keybinding
- **Fallback**: Uses LSP formatting if google-java-format unavailable

### Features Available

#### Standard LSP Features
- Auto-completion with nvim-cmp integration
- Go to definition (`gd`)
- Hover documentation (`K`)
- Code actions (`<leader>ca`)
- Diagnostics navigation (`<leader>dn`, `<leader>dp`)
- Code formatting (`<leader>cf`)

#### Java-Specific Features (ftplugin/java.lua)
- `<leader>co`: Organize imports
- `<leader>crv`: Extract variable (normal/visual mode)
- `<leader>crc`: Extract constant (normal/visual mode)  
- `<leader>crm`: Extract method (visual mode)

## Usage

1. **First Time Setup**: 
   - Start Neovim and run `:Lazy sync` to install plugins
   - Open any Java file in a Maven/Gradle project
   - Mason will automatically install jdtls and google-java-format

2. **Project Structure**: Works best with:
   - Maven projects (with `pom.xml`)
   - Gradle projects (with `build.gradle` or `gradlew`)
   - Any project with `.git` directory

3. **Formatting**: 
   - Use `<leader>cf` to format current buffer
   - Format-on-save is enabled by default

## Requirements
- Java 17+ runtime environment
- Maven or Gradle project structure for full functionality

## Test File
Open any `.java` file in a Maven/Gradle project to test the configuration.