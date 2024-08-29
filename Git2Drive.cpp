#include <iostream>
#include <cstdlib>  
#include <fstream>
#include <filesystem>
#include <thread>   
#include <chrono>   

namespace fs = std::filesystem;

// reads config values
std::string readConfigValue(const std::string& key, const std::string& filePath) {
    std::ifstream configFile(filePath);
    std::string line;
    while (std::getline(configFile, line)) {
        if (line.find(key) == 0) {
            return line.substr(key.length() + 1);
        }
    }
    return "";
}

int main() {
    std::string configFilePath = "config.txt";

    // reads config values from config.txt
    std::string googleDriveDir = readConfigValue("GoogleDriveDir", configFilePath);
    std::string finalBackupDir = readConfigValue("FinalBackupDir", configFilePath);
    std::string githubToken = readConfigValue("GithubToken", configFilePath);
    std::string backupIntervalStr = readConfigValue("BackupInterval", configFilePath);
    std::string githubRepo = "https://" + githubToken + "@github.com/username/repository.git";

    // converts interval to integer (3600 if blank)
    int interval = std::stoi(backupIntervalStr);
    if (interval <= 0) {
        interval = 3600;
    }

    // makes temporary clone directory within program installation
    std::string tempCloneDir = fs::current_path().string() + "\\temp_clone";

    // ensures necessary directories exist
    if (!fs::exists(finalBackupDir)) {
        fs::create_directories(finalBackupDir);
    }

    while (true) {
        std::cout << "Backing up the repository..." << std::endl;

        // removes old temporary clones
        if (fs::exists(tempCloneDir)) {
            std::cout << "Removing old temporary clone directory..." << std::endl;
            fs::remove_all(tempCloneDir);
        }
        fs::create_directories(tempCloneDir); // recreates directory

        // clones repository to temporary directory
        std::cout << "Cloning repository to temporary directory..." << std::endl;
        std::string cloneCommand = "git clone " + githubRepo + " \"" + tempCloneDir + "\"";
        system(cloneCommand.c_str());

        // copies repository to final location
        std::cout << "Copying repository to final backup location..." << std::endl;
        std::string copyCommand = "xcopy \"" + tempCloneDir + "\" \"" + finalBackupDir + "\" /e /y /i";
        system(copyCommand.c_str());

        // removes temporary clone
        std::cout << "Removing temporary clone directory..." << std::endl;
        fs::remove_all(tempCloneDir);

        // waits for next backup
        std::cout << "Waiting for next backup..." << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(interval));
    }

    return 0;
}
