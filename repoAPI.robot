*** Settings ***
Resource                        ../resources/settings.robot
Resource                        ../resources/GitOperation.robot
Suite Setup                     Start Suite
Suite Teardown                  End project                 ${BuildId}

*** Variables ***
${FILES_DIR}                    ${CURDIR}/../files
${GIT_REPO_NAME}                crt-test-repo
${GIT_CLONE_URL}                github.com/crt-test-user/crt-test-repo.git
${EXISTING_BRANCH_NAME}         main

*** Test Cases ***
Login to CRT as a Demo User
    [Documentation]             Login using dynamic browser setup.
    [Tags]                      Login
    Perform Login

Create project
    [Documentation]             Go to CRT projects page with ${BROWSER} and try to create a new project
    [Tags]                      Projects
    Create New Project          Temp test project ${build_id}

Create robot
    [Documentation]             Go to CRT robots page with ${BROWSER} and try to create a new robot
    [Tags]                      Robots
    Create New Robot            ${BuildId}

Add GitHttps token for CVC
    [Documentation]             Go to Profile with ${BROWSER} and add a Git (HTTPS) access token for the CVC instance.
    [Tags]                      CVC
    Appstate                    HomePage
    ClickElement                ${MENU_BUTTON}
    ClickText                   Profile
    ClickText                   Add token
    DropDown                    Service provider            Git (HTTPS)                 timeout=60
    TypeText                    Git http url                https://${CVC_INSTANCE}.cvc.copado.com/sramesh/AutomationRepo.git
    TypeText                    Username                    anonymous
    TypeText                    Credentials                 ${CVC_TOKEN}
    ClickText                   Verify & Save
    VerifyText                  GitHttps added              timeout=60
    VerifyText                  gitHttps_crt-int.cvc.copado.com

Create Test Job with CVC Repo
    [Documentation]             Go to CRT test job page with ${BROWSER} and create a new test suite from CVC Repo
    [Tags]                      CVC
    Appstate                    HomePage
    ClickText                   Test Jobs
    ClickText                   New Test Job
    ClickText                   Use an Existing Repository
    ClickText                   Custom Git
    TypeText                    Job Name                    CRT-CVC-repo
    ClickElement                ${ROBOT_SELECT}
    ClickText                   Temp test robot ${BuildId}                              anchor=Advanced Options
    ClickText                   Next Step
    TypeText                    Git URL                     https://${CVC_INSTANCE}.cvc.copado.com/sramesh/AutomationRepo.git
    VerifyText                  Git Branch
    TypeText                    Git Branch                  master\n                    timeout=10
    ClickText                   Use My Credentials
    ClickText                   Create New
    Verify Toast                Job added
    ClickText                   Cancel
    ClickText                   QEditor
    VerifyText                  Let the bug hunting begin!

Create test job with Azure Repo
    [Documentation]             Go to CRT Test jobs page with ${BROWSER} and create a new test job.
    [Tags]                      Jobs                        AzureRepo
    Appstate                    Homepage
    ClickText                   Test Jobs                   timeout=20
    VerifyText                  New Test Job
    Sleep                       ${CRT_ANIMATION_DELAY_LONG}
    Create Job Step             ${BuildId}                  CRT-Azure-pipeline-test     Azure Repos
    CreateJobFromAzureRepo      ${TOKEN}                    CRT-Azure-pipeline-test     test-data
    VerifyText                  CRT-Azure-pipeline-test     timeout=120

Create starter job
    [Documentation]             Go to CRT robots page with ${BROWSER} and create a new starter job.
    [Tags]                      StarterJob
    Create Starter Job          ${BuildId}

Create Folder for non-git job
    [Documentation]             Create Folder in the Non-git Test Job
    [Tags]                      FileManagement
    Appstate                    Homepage
    Search Job                  starter job
    ClickText                   QEditor
    VerifyText                  All Files
    VerifyNoText                Loading                     timeout=30s
    Create Folder in QEditor    TestFolder
    HoverText                   TestFolder
    ClickText                   TestFolder
    VerifyText                  .gitkeep

Create File for non-git job
    [Documentation]             Create File in the Non-git Test Job
    [Tags]                      FileManagement
    Appstate                    Homepage
    Search Job                  starter job
    Sleep                       2s
    ClickText                   QEditor
    VerifyNoText                Loading                     timeout=30s
    VerifyText                  All Files
    VerifyNoText                Loading
    Create File in QEditor      File.robot                  1
    VerifyText                  /File.robot
    Create File in QEditor      FileUnderFolder.robot       2
    VerifyText                  /TestFolder/FileUnderFolder.robot

Edit File for non-git job
    [Documentation]             Edit File in the Non-git Test Job
    [Tags]                      FileManagement
    Appstate                    Homepage
    Search Job                  starter job
    Sleep                       2s
    ClickText                   QEditor
    VerifyNoText                Loading                     timeout=30s
    VerifyText                  All Files
    ClickText                   TestFolder
    ClickText                   FileUnderFolder.robot
    Type Content In Editor      Hello World!
    ClickText                   Save file
    VerifyText                  Changes to TestFolder/FileUnderFolder.robot saved.
    #verify File Editing
    Appstate                    Homepage
    Search Job                  starter job
    Sleep                       2s
    ClickText                   QEditor
    VerifyText                  All Files
    ClickText                   TestFolder
    ClickText                   FileUnderFolder.robot
    VerifyText                  Hello World!

Rename File for non-git job
    [Documentation]             Rename File in the Non-git Test Job
    [Tags]                      FileManagement
    Appstate                    Homepage
    Search Job                  starter job
    Sleep                       2s
    ClickText                   QEditor
    VerifyNoText                Loading                     timeout=30s
    VerifyText                  All Files
    HoverText                   TestFolder
    ClickText                   TestFolder
    Rename File in QEditor      File.robot                  NewFile.robot               3
    VerifyText                  /NewFile.robot
    Rename File in QEditor      FileUnderFolder.robot       NewFileUnderFolder.robot    2
    VerifyText                  /TestFolder/NewFileUnderFolder.robot

Create Block for non-git job
    [Documentation]             Create block in the robotfile
    [Tags]                      FileManagement
    Appstate                    Homepage
    Search Job                  starter job
    Sleep                       2s
    ClickText                   QEditor
    VerifyNoText                Loading                     timeout=30s
    VerifyText                  All Files
    ClickText                   TestFolder
    ClickText                   NewFile.robot
    ClickItem                   btn-link mx-1 text-muted ms-auto                        5
    @{mandatory_arguments}=     Create List
    ${optional_arguments}=      Create Dictionary
    Create Block in QEditor     Block1                      Test Description            TestTag                ${mandatory_arguments}    ${optional_arguments}

Upload File for non-git job
    [Documentation]             Upload a file in the Non-git Test Job using QEditor
    [Tags]                      FileManagement
    Appstate                    Homepage
    Search Job                  starter job
    Sleep                       2s
    ClickText                   QEditor
    VerifyNoText                Loading                     timeout=30s
    VerifyText                  All Files
    #Upload File in Root directory
    Upload File in QEditor      sample.robot                ${FILES_DIR}
    VerifyText                  sample.robot

Move File for non-git job
    [Documentation]             Move a file in the Non-git Test Job using QEditor
    [Tags]                      FileManagement
    Appstate                    Homepage
    Search Job                  starter job
    Sleep                       2s
    ClickText                   QEditor
    VerifyNoText                Loading                     timeout=30s
    VerifyText                  All Files
    Move File in QEditor        sample.robot                TestFolder                      2
    VerifyText                  /TestFolder/sample.robot

Move Folder for non-git job
    [Documentation]             Move a folder in the Non-git Test Job using QEditor
    [Tags]                      FileManagement
    Appstate                    Homepage
    Search Job                  starter job
    Sleep                       2s
    ClickText                   QEditor
    VerifyNoText                Loading                     timeout=30s
    VerifyText                  All Files
    Create Folder in QEditor    NewParentFolder
    Move Folder in QEditor      TestFolder                      NewParentFolder             2
    #verify File Editing
    Appstate                    Homepage
    Search Job                  starter job
    Sleep                       2s
    ClickText                   QEditor
    ClickText                   NewParentFolder
    VerifyText                  TestFolder

Delete File for non-git job
    [Documentation]             Delete File in the Non-git Test Job
    [Tags]                      FileManagement
    Appstate                    Homepage
    Search Job                  starter job
    Sleep                       2s
    ClickText                   QEditor
    VerifyNoText                Loading                     timeout=30s
    VerifyText                  All Files
    #delete file in root folder
    Delete File in QEditor      NewFile.robot               2
    Sleep                       6s
    VerifyNoText                NewFile.robot
    #delete file under folder
    HoverText                   NewParentFolder
    ClickText                   NewParentFolder
    HoverText                   TestFolder
    ClickText                   TestFolder
    VerifyText                  NewFileUnderFolder.robot    partial_match=True
    Delete File in QEditor      NewFileUnderFolder.robot    4
    Sleep                       6s
    VerifyNoText                NewFileUnderFolder.robot
    #delete Last file under folder to check if folder also get deleted
    Create Folder in QEditor    Temp Folder
    HoverText                   Temp Folder
    ClickText                   Temp Folder
    Delete File in QEditor      .gitkeep                    3                           True
    VerifyNoText                .gitkeep
    VerifyNoText                Temp Folder

Delete Folder for non-git job
    [Documentation]             Delete a folder in the Non-git Test Job using QEditor
    [Tags]                      FileManagement
    Appstate                    Homepage
    Search Job                  starter job
    Sleep                       2s
    ClickText                   QEditor
    VerifyNoText                Loading                     timeout=30s
    VerifyText                  All Files
    Delete Folder in QEditor    NewParentFolder
    Sleep                       6s
    VerifyNoText                NewParentFolder

Create test job with custom settings
    [Documentation]             Go to CRT robots page with ${BROWSER}, try to open one existing robot and create a new test job with correct info and video recording on.
    [Tags]                      Jobs
    ClickText                   Test Jobs
    Create Job Step             ${BuildId}                  Robot_Job                   Custom Git
    TypeText                    Git URL                     ${CUSTOM_GIT_URL}
    ClickText                   Branch                      partial_match=False
    VerifyText                  Git Branch
    TypeText                    Git Branch                  main\n                      timeout=10
    Sleep                       ${CRT_ANIMATION_DELAY_LONG}
    ${button_disabled}=         IsElement                   ${CREDENTIALS_BUTTON}       timeout=1
    IF                          ${button_disabled}
        ClickText               Add/Change Credentials
        TypeText                Username                    ${CUSTOM_GIT_USERNAME}
        TypeText                Password                    ${CUSTOM_GIT_TOKEN}
    ELSE
        ClickText               Use My Credentials
    END
    ClickText                   Create New
    Verify Toast                Job added.

Create test job with public github
    [Documentation]             Go to CRT robots page with ${BROWSER}, try to open one existing robot and create a new test job.
    [Tags]                      Jobs
    Create Duplicate Branch In Remote Repository            Folder_${BuildId}           ${GIT_REPO_NAME}       ${GIT_CLONE_URL}          ${GIT_USERNAME}          ${GIT_PASSWORD}       feature/${BuildId}         ${EXISTING_BRANCH_NAME}
    ClickText                   Test Jobs
    Create Job Step             ${BuildId}                  crt-test-repo               GitHub (github.com)
    CreateJobFromGitRepo        ${GITHUB_GIT_TOKEN}         crt-test-repo               feature/${BuildId}
    VerifyText                  crt-test-repo

Create test job with Gitlab (Hosted on gitlab.com)
    [Documentation]             Go to CRT robots page with ${BROWSER}, try to open one existing robot and create a new test job.
    [Tags]                      Jobs
    ClickText                   Test Jobs
    Create Job Step             ${BuildId}                  crt-starter-gitlab          GitLab (gitlab.com)
    CreateJobFromGitRepo        ${GITLAB_GIT_TOKEN}         testprojectforcrtengineering         main
    VerifyText                  crt-starter-gitlab

Create Folder for git job
    [Documentation]             Create a remote branch for the git job using buildId, clone it, create a folder, pull latest code, and validate the folder exists.
    [Tags]                      FileManagementGit
    Appstate                    Homepage
    Search Job                  crt-test-repo
    Sleep                       2s
    ClickText                   QEditor
    VerifyNoText                Loading                     timeout=30s
    VerifyText                  All Files
    VerifyNoText                Loading                     timeout=120s
    Create Folder in QEditor    TestFolder
    HoverText                   TestFolder
    ClickText                   TestFolder
    VerifyText                  .gitkeep
    Pull Latest Code From Remote Repository                 ${TEMPDIR}/Folder_${BuildId}/crt-test-repo/        feature/${BuildId}
    Directory Should Exist      ${TEMPDIR}/Folder_${BuildId}/crt-test-repo/TestFolder

Create File for git job
    [Documentation]             Go to CRT robots page with ${BROWSER} and create file in git job.
    [Tags]                      FileManagementGit
    Appstate                    Homepage
    Search Job                  crt-test-repo
    Sleep                       2s
    ClickText                   QEditor
    VerifyNoText                Loading                     timeout=120s
    VerifyText                  All Files
    VerifyNoText                Loading
    Create File in QEditor      File.robot                  1
    VerifyText                  /File.robot
    VerifyNoText                Loading                     timeout=120s
    Create File in QEditor      FileUnderFolder.robot       9
    VerifyText                  /TestFolder/FileUnderFolder.robot                           timeout=120s
    Pull Latest Code From Remote Repository                 ${TEMPDIR}/Folder_${BuildId}/crt-test-repo/        feature/${BuildId}
    File Should Exist           ${TEMPDIR}/Folder_${BuildId}/crt-test-repo/File.robot
    File Should Exist           ${TEMPDIR}/Folder_${BuildId}/crt-test-repo/TestFolder/FileUnderFolder.robot

Rename File for git job
    [Documentation]             Go to CRT robots page with ${BROWSER}, rename file in git job, pull latest code, and verify the renamed file exists.
    [Tags]                      FileManagementGit
    Rename File in QEditor      File.robot                  NewFile.robot               9
    VerifyNoText                Loading                     timeout=120s
    RefreshPage
    VerifyNoText                Loading                     timeout=120s
    VerifyText                  NewFile.robot
    # Pull latest code and verify the renamed file exists in the repo
    Pull Latest Code From Remote Repository                 ${TEMPDIR}/Folder_${BuildId}/crt-test-repo/        feature/${BuildId}
    File Should Not Exist       ${TEMPDIR}/Folder_${BuildId}/crt-test-repo/File.robot
    File Should Exist           ${TEMPDIR}/Folder_${BuildId}/crt-test-repo/NewFile.robot

Edit File for git job
    [Documentation]             Go to CRT robots page with ${BROWSER}, edit file in git job, pull latest code, and verify the file content.
    [Tags]                      FileManagementGit
    ClickText                   NewFile.robot
    Type Content In Editor      Hello World!
    ClickText                   Commit and push file
    VerifyText                  Commit and push changes
    VerifyText                  Commit and push changes to NewFile.robot?
    TypeText                    Please describe the changes you've made.                changes
    ClickText                   Commit and push changes
    VerifyNoText                Changes to NewFile.robot saved.                         timeout=120s
    # Pull latest code and verify the file content
    File Should Be Empty        ${TEMPDIR}/Folder_${BuildId}/crt-test-repo/NewFile.robot
    Sleep                       30s
    Pull Latest Code From Remote Repository                 ${TEMPDIR}/Folder_${BuildId}/crt-test-repo         feature/${BuildId}
    ${File_Content}             get file                    ${TEMPDIR}/Folder_${BuildId}/crt-test-repo/NewFile.robot
    should contain              ${File_Content}             Hello World!

Upload File for git job
    [Documentation]             Upload a file in the git Test Job using QEditor, pull latest code, and verify the file exists.
    [Tags]                      FileManagementGit
    Appstate                    Homepage
    Search Job                  crt-test-repo
    Sleep                       2s
    ClickText                   QEditor
    VerifyNoText                Loading                     timeout=30s
    VerifyText                  All Files
    # Upload File in Root directory
    Upload File in QEditor      sample.robot                ${CURDIR}/../files
    VerifyText                  sample.robot
    # Pull latest code and verify the uploaded file exists in the repo
    Pull Latest Code From Remote Repository                 ${TEMPDIR}/Folder_${BuildId}/crt-test-repo         feature/${BuildId}
    File Should Exist           ${TEMPDIR}/Folder_${BuildId}/crt-test-repo/sample.robot

Move File for git job
    [Documentation]             Move a file in the git Test Job using QEditor, pull latest code, and verify the file is moved and removed from the old location.
    [Tags]                      FileManagementGit
    Appstate                    Homepage
    Search Job                  crt-test-repo
    Sleep                       2s
    ClickText                   QEditor
    VerifyNoText                Loading                     timeout=30s
    VerifyText                  All Files
    Move File in QEditor        NewFile.robot               TestFolder                      1
    VerifyText                  /TestFolder/NewFile.robot
    # Pull latest code and verify the file is at the new location and not at the old location
    Pull Latest Code From Remote Repository                 ${TEMPDIR}/Folder_${BuildId}/crt-test-repo         feature/${BuildId}
    File Should Exist           ${TEMPDIR}/Folder_${BuildId}/crt-test-repo/TestFolder/NewFile.robot
    File Should Not Exist       ${TEMPDIR}/Folder_${BuildId}/crt-test-repo/NewFile.robot

Move Folder for git job
    [Documentation]             Move a folder in the git Test Job using QEditor, pull latest code, and verify the folder is moved and removed from the old location.
    [Tags]                      FileManagementGit
    Appstate                    Homepage
    Search Job                  crt-test-repo
    Sleep                       2s
    ClickText                   QEditor
    VerifyNoText                Loading                     timeout=30s
    VerifyText                  All Files
    Create Folder in QEditor    NewParentFolder
    Move Folder in QEditor      TestFolder                      NewParentFolder             9
    # Pull latest code and verify the folder is at the new location and not at the old location
    Pull Latest Code From Remote Repository                 ${TEMPDIR}/Folder_${BuildId}/crt-test-repo         feature/${BuildId}
    Directory Should Exist      ${TEMPDIR}/Folder_${BuildId}/crt-test-repo/NewParentFolder/TestFolder
    Directory Should Not Exist                              ${TEMPDIR}/Folder_${BuildId}/crt-test-repo/TestFolder
    #verify File Editing
    Appstate                    Homepage
    Search Job                  crt-test-repo
    Sleep                       2s
    ClickText                   QEditor
    VerifyNoText                Loading                     timeout=30s
    ClickText                   NewParentFolder
    VerifyText                  TestFolder

Delete File for git job
    [Documentation]             Go to CRT robots page with ${BROWSER}, delete file in git job, pull latest code, and verify the file is deleted.
    [Tags]                      FileManagementGit
    RefreshPage
    VerifyNoText                Loading                     timeout=120s
    VerifyText                  files                       timeout=60s
    VerifyText                  sample.robot                anchor=react
    # delete file in root folder
    Delete File in QEditor      sample.robot                10
    # delete Last file under folder to check if folder also get deleted
    Create Folder in QEditor    Temp Folder
    HoverText                   Temp Folder
    ClickText                   Temp Folder
    Delete File in QEditor      .gitkeep                    8                           True
    VerifyNoText                .gitkeep
    VerifyNoText                Temp Folder
    # Pull latest code and verify the file and folder are deleted in the repo
    Pull Latest Code From Remote Repository                 ${TEMPDIR}/Folder_${BuildId}/crt-test-repo         feature/${BuildId}
    Directory Should Not Exist                              ${TEMPDIR}/Folder_${BuildId}/crt-test-repo/Temp Folder

Delete Folder for git job
    [Documentation]             Delete a folder in the git Test Job using QEditor, pull latest code, and verify the folder is deleted.
    [Tags]                      FileManagementGit
    Appstate                    Homepage
    Search Job                  crt-test-repo
    Sleep                       2s
    ClickText                   QEditor
    VerifyNoText                Loading                     timeout=30s
    VerifyText                  All Files
    Run Keyword And Ignore Error    Delete Folder in QEditor    NewParentFolder             4
    Sleep                       6s
    VerifyNoText                NewParentFolder
    # Pull latest code and verify the folder is deleted in the repo
    Pull Latest Code From Remote Repository                 ${TEMPDIR}/Folder_${BuildId}/crt-test-repo         feature/${BuildId}
    Directory Should Not Exist                              ${TEMPDIR}/Folder_${BuildId}/crt-test-repo/NewParentFolder

Create test job with bitbucket
    [Documentation]             Go to CRT robots page with ${BROWSER}, try to open one existing robot and create a new test job.
    [Tags]                      Jobs
    ClickText                   Test Jobs
    Create Job Step             ${BuildId}                  crt-starter-bitbucket       Bitbucket
    CreateJobFromGitRepo        ${BITBUCKET_CREDENTIALS}    pace-starter-bitbucket      master
    VerifyText                  crt-starter-bitbucket

Create automated test job with custom settings
    [Documentation]             Go to CRT robots page with ${BROWSER}, try to open one existing robot and create a new test job with correct info and video recording on.
    [Tags]                      Jobs
    ClickText                   Test Jobs
    Create Job Step             ${BuildId}                  Automated_Test_Job          Custom Git
    TypeText                    Git URL                     ${AUTOMATED_TEST_GIT_URL}
    ClickText                   Branch                      partial_match=False
    VerifyText                  Git Branch
    TypeText                    Git Branch                  main\n
    ${button_disabled}=         IsElement                   ${CREDENTIALS_BUTTON}       timeout=1
    IF                          ${button_disabled}
        ClickText               Add/Change Credentials
        TypeText                Username                    ${CUSTOM_GIT_USERNAME}
        TypeText                Password                    ${CUSTOM_GIT_TOKEN}
    ELSE
        ClickText               Use My Credentials
    END
    ClickText                   Create New
    Verify Toast                Job added.
    VerifyText                  Automated_Test_Job

Job Creation from Public Repo
    [Documentation]             Go to CRT robots page with ${BROWSER}, try to open one existing robot and create a new test job with correct info and video recording on.
    [Tags]                      Jobs
    ClickText                   Test Jobs
    Create Job Step             ${BuildId}                  Public_Job                  Custom Git
    TypeText                    Git URL                     ${PUBLIC_CUSTOM_GIT_URL}
    # ClickCheckbox             Public repository           value=on
    ClickText                   Branch                      partial_match=False
    VerifyText                  Git Branch
    TypeText                    Git Branch                  main\n
    ClickText                   Public Repository
    ClickText                   Create New
    Verify Toast                Job added.
    VerifyText                  Public_Job                  timeout=20

Run automated test job
    [Documentation]             Go to CRT robots page with ${BROWSER}, run the automated test job.
    [Tags]                      Jobs
    ClickText                   Test Jobs
    Sleep                       1s
    TypeText                    Search                      CRT-Azure-pipeline-test
    Sleep                       ${CRT_ANIMATION_DELAY_LONG}
    ClickText                   Run Test Job
    ClickText                   Run Now                     anchor=Add Execution Parameter
    VerifyText                  Run initiated               timeout=30
    VerifyText                  Executing                   anchor=Abort                timeout=120
    ClickText                   Executing                   anchor=Abort
    VerifyNoText                These tests are currently executing.                    timeout=180

Editor with access token
    [Documentation]             Go to CRT robots page with ${BROWSER}, run a editor with access token
    [Tags]                      Jobs
    ClickText                   Test Jobs
    ClickText                   QEditor                     anchor=crt-test-repo
    VerifyText                  Let the bug hunting begin!                              timeout=30

Delete Jobs
    [Documentation]             Go to CRT robots page with ${BROWSER}, try to open one existing robot and remove a new test job
    [Tags]                      Jobs
    Delete Branch In Remote Repository                      ${TEMPDIR}/Folder_${BuildId}/crt-test-repo/        feature/${BuildId}
    Appstate                    Homepage
    VerifyText                  Welcome back                timeout=180
    ClickText                   Test Jobs
    VerifyText                  Temp test project ${BuildId}  timeout=60
    VerifyText                  records found                  timeout=60
    ${job_names}=               Get All Test Job Names
    FOR                         ${job_name}    IN    @{job_names}
        Delete Job              ${job_name}
    END

Delete robot
    [Documentation]             Go to CRT robots page with ${BROWSER} and try to delete the robot
    [Tags]                      Robots
    Delete Robot                Temp test robot ${BuildId}
