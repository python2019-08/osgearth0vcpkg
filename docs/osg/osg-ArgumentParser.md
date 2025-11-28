# 1.如何使用 osg::ArgumentParser

好的，我们来详细介绍一下如何使用 `osg::ArgumentParser`。

`osg::ArgumentParser` 是 OpenSceneGraph (OSG) 中一个非常实用的工具类，用于解析命令行参数。它封装了复杂的命令行处理逻辑，让你能够轻松地为你的 OSG 应用程序添加丰富的命令行选项。

### 核心功能

*   **解析标准 OSG 选项**：自动处理 OSG 内置的大量标准命令行参数，例如 `--window`、`--screen`、`--camera`、`--image`、`--help`、`--version` 等。
*   **解析自定义选项**：允许你方便地添加和解析自己的应用程序特定的命令行参数。
*   **类型安全**：支持解析多种数据类型（整数、浮点数、字符串、布尔值等）。
*   **参数校验**：可以检查参数是否存在、是否具有正确的格式。
*   **生成帮助信息**：可以自动生成清晰的命令行帮助和用法说明。

### 基本使用步骤

1.  **创建 `osg::ArgumentParser` 对象**，并将 `main` 函数的 `argc` 和 `argv` 传递给它。
2.  **（可选）添加自定义命令行选项**。
3.  **解析命令行**。
4.  **提取和使用解析后的参数**。
5.  **（可选）处理标准 OSG 选项**，例如加载模型、设置窗口大小等。

### 代码示例

下面是一个完整的示例，展示了如何使用 `osg::ArgumentParser` 来解析标准 OSG 选项和自定义选项。

```cpp
#include <osg/ArgumentParser>
#include <osgDB/ReadFile>
#include <osgViewer/Viewer>
#include <iostream>

int main(int argc, char** argv)
{
    // 1. 创建 ArgumentParser 对象
    osg::ArgumentParser arguments(&argc, argv);

    // 2. 添加自定义选项的描述信息（用于生成帮助）
    arguments.getApplicationUsage()->setApplicationName(arguments.getApplicationName());
    arguments.getApplicationUsage()->setDescription(arguments.getApplicationName() + " is a simple OSG viewer with custom command line options.");
    arguments.getApplicationUsage()->setCommandLineUsage(arguments.getApplicationName() + " [options] filename ...");

    // 添加一个自定义的布尔选项
    arguments.getApplicationUsage()->addCommandLineOption("--my-boolean", "A boolean flag.");
    
    // 添加一个带参数的自定义选项
    arguments.getApplicationUsage()->addCommandLineOption("--my-string <string>", "A string parameter.");
    
    // 添加一个带整数参数的自定义选项
    arguments.getApplicationUsage()->addCommandLineOption("--my-int <int>", "An integer parameter.");

    // 3. 解析标准的 OSG 帮助和版本选项
    // 如果用户输入了 --help 或 --version，ArgumentParser 会自动处理并退出程序
    if (arguments.read("--help") || arguments.read("--version"))
    {
        arguments.getApplicationUsage()->write(std::cout);
        return 0;
    }

    // 4. 提取和使用自定义选项

    // 检查并提取 --my-boolean 选项
    bool myBoolean = false;
    if (arguments.read("--my-boolean"))
    {
        myBoolean = true;
        std::cout << "Custom option '--my-boolean' is set." << std::endl;
    }

    // 检查并提取 --my-string 选项及其参数
    std::string myString;
    if (arguments.read("--my-string", myString))
    {
        std::cout << "Custom option '--my-string' is set to: " << myString << std::endl;
    }

    // 检查并提取 --my-int 选项及其参数
    int myInt = 0;
    if (arguments.read("--my-int", myInt))
    {
        std::cout << "Custom option '--my-int' is set to: " << myInt << std::endl;
    }
    
    // 5. 处理剩余的标准参数（通常是模型文件名）
    osg::ref_ptr<osg::Node> root = osgDB::readNodeFiles(arguments);
    if (!root)
    {
        std::cout << "No model file specified or file not found." << std::endl;
        arguments.getApplicationUsage()->write(std::cout);
        return 1;
    }

    // 6. 创建 Viewer 并运行
    osgViewer::Viewer viewer(arguments);
    viewer.setSceneData(root.get());
    
    // 如果没有通过命令行设置窗口大小，可以在这里代码设置
    // viewer.setUpViewInWindow(100, 100, 800, 600);

    return viewer.run();
}
```

### 关键方法解析

*   **`osg::ArgumentParser(int* argc, char** argv)`**：构造函数。注意 `argc` 是按指针传递的，因为 `ArgumentParser` 会在解析过程中移除已识别的参数，修改 `argc` 和 `argv`。
*   **`bool read(const std::string& option)`**：检查并提取一个布尔类型的选项（开关）。如果命令行中存在该选项，则返回 `true`，并将该选项从参数列表中移除。
*   **`bool read(const std::string& option, T& value)`**：检查并提取一个带有参数的选项。`T` 可以是 `int`, `float`, `double`, `std::string` 等。如果成功读取，则返回 `true`，并将值存入 `value`，同时移除选项和其参数。
*   **`osg::ApplicationUsage* getApplicationUsage()`**：返回一个用于设置应用程序描述和命令行选项帮助信息的对象。
*   **`void ApplicationUsage::addCommandLineOption(const std::string& option, const std::string& description)`**：为你的自定义选项添加描述，当用户使用 `--help` 时会显示这些信息。
*   **`osgDB::readNodeFiles(arguments)`**：一个便捷函数，使用 `ArgumentParser` 来读取命令行中指定的所有模型文件，并将它们组合成一个 `osg::Group` 节点返回。
*   **`osgViewer::Viewer viewer(arguments)`**：`osgViewer::Viewer` 的构造函数可以直接接受一个 `osg::ArgumentParser` 对象，从而自动处理所有与视图相关的标准命令行选项（如窗口大小、全屏、相机参数等）。

### 常用标准 OSG 命令行选项

你可以在你的程序中直接使用这些选项，无需自己解析：

*   **`--help`**：显示帮助信息。
*   **`--version`**：显示 OSG 版本。
*   **`model.osg`** 或 **`model.3ds`** 等：指定要加载的模型文件。
*   **`--window <x> <y> <width> <height>`**：设置窗口位置和大小。
*   **`--screen <screen_number>`**：指定在哪个屏幕上显示。
*   **`--fullscreen`**：全屏模式。
*   **`--image <filename>`**：将场景渲染到图片文件。
*   **`--camera <camera_name>`**：使用场景中特定名称的相机。
*   **`--stats`**：显示渲染统计信息。

### 总结

`osg::ArgumentParser` 是 OSG 提供的一个强大且易于使用的命令行解析工具。它不仅能帮你处理自定义参数，还能无缝集成 OSG 自身的大量标准选项，让你的应用程序更专业、更灵活。通过结合 `osg::ApplicationUsage`，你还能轻松为用户提供清晰的帮助信息。在开发任何 OSG 应用程序时，都应该优先考虑使用它来处理命令行输入。