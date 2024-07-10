@rem
@rem Copyright 2024 seung.
@rem
@rem ################################################################
@rem
@rem  Gradle project management script with Docker for Windows
@rem
@rem ################################################################

@echo off

setlocal enabledelayedexpansion

@rem Version
set "SDOCKER_VERSION=1.0.0"
set "SDOCKER_RELEASE_DATE=2024-07-09"
set "SDOCKER_DIR=%~dp0"
for %%a in (%0) do (
    set "SDOCKER_FILE=%%~na"
)

@rem Fields
set "EXIT_CODE="
set "OPTION="

:init
    call :colors
    call :import_ini
    if not ""=="%DEFAULT_CHARSET%" (
        call chcp %DEFAULT_CHARSET% >nul 2>&1
        if errorlevel 1 (
            echo sdocker: Invalid code page
            goto try
        )
    )

@rem Parse Options
:parse_option
    set "ARG1=%~1"
    if ""=="!ARG1!" (
        goto usage
    )
    if "help"=="!ARG1!" (
        goto usage
    )
    for %%a in (image wincred nkscred ncrcred ncp) do (
        if "%%a"=="!ARG1!" (
            set "OPTION=!ARG1!"
            shift
            goto parse_commands
        )
    )
    echo sdocker: "!ARG1!" is not a option
    goto try

@rem Parse Commands
:parse_commands
    set "ARG1=%~1"
    if ""=="!ARG1!" (
        echo sdocker: command is requried
        goto try
    )
    if not "-"=="!ARG1:~0,1!" (
        echo sdocker: "!ARG1!" is not a command
        goto try
    )
    set "COMMANDS=!ARG1:~1!"
    :split
        if ""=="!COMMANDS!" (
            shift
            goto parse_fields
        )
        set "COMMAND=!COMMANDS:~0,1!"
        if "image"=="!OPTION!" (
            for %%a in (A I R P L) do (
                if "%%a"=="!COMMAND!" (
                    set "COMMAND_!COMMAND!=1"
                    echo set "COMMAND_!COMMAND!=1"
                    set "COMMANDS=!COMMANDS:~1!"
                    goto split
                )
            )
        )
        if "wincred"=="!OPTION!" (
            for %%a in (L W R D) do (
                if "%%a"=="!COMMAND!" (
                    set "COMMAND_!COMMAND!=1"
                    echo set "COMMAND_!COMMAND!=1"
                    set "COMMANDS=!COMMANDS:~1!"
                    goto split
                )
            )
        )
        if "nkscred"=="!OPTION!" (
            for %%a in (W) do (
                if "%%a"=="!COMMAND!" (
                    set "COMMAND_!COMMAND!=1"
                    echo set "COMMAND_!COMMAND!=1"
                    set "COMMANDS=!COMMANDS:~1!"
                    goto split
                )
            )
        )
        if "ncrcred"=="!OPTION!" (
            for %%a in (L W R D) do (
                if "%%a"=="!COMMAND!" (
                    set "COMMAND_!COMMAND!=1"
                    echo set "COMMAND_!COMMAND!=1"
                    set "COMMANDS=!COMMANDS:~1!"
                    goto split
                )
            )
        )
        if "ncp"=="!OPTION!" (
            for %%a in (M A) do (
                if "%%a"=="!COMMAND!" (
                    set "COMMAND_!COMMAND!=1"
                    echo set "COMMAND_!COMMAND!=1"
                    set "COMMANDS=!COMMANDS:~1!"
                    goto split
                )
            )
        )
        echo sdocker: "!COMMAND!" is not a command
        goto try

@rem Parse Fields
:parse_fields
    set "ARG1=%~1"
    if ""=="!ARG1!" (
        goto inputs
    )
    if not "-"=="!ARG1:~0,1!" (
        echo sdocker: "!ARG1!" is not a field
        goto try
    )
    set "ARG2=%~2"
    set "FIELD=!ARG1:~1!"
    for %%a in (N V B D T F O C K X R U) do (
        if /i "%%a"=="!FIELD!" (
            if not "-"=="!ARG2:~0,1!" (
                set "FIELD_%%a=!ARG2!"
                echo set "FIELD_%%a=!ARG2!"
                shift
            )
            shift
            goto parse_fields
        )
    )
    echo sdocker: "!FIELD!" is not a field
    goto try

@rem Input Fields
:inputs
    if "wincred"=="!OPTION!" goto cred_inputs
    if "nkscred"=="!OPTION!" goto cred_inputs
    if "ncrcred"=="!OPTION!" goto cred_inputs
    :image_inputs
        echo Application:
        @rem Application Name
        if not ""=="!FIELD_N!" (
            set "APP_NAME=!FIELD_N!"
            echo - Name []: !APP_NAME!
        ) else (
            set /p APP_NAME="- Name []: "
        )
        if ""=="!APP_NAME!" goto required
        @rem Application Version
        if not ""=="!FIELD_V!" (
            set "APP_VERSION=!FIELD_V!"
            echo - Version []: !APP_VERSION!
        ) else (
            set /p APP_VERSION="- Version []: "
        )
        if ""=="!APP_VERSION!" goto required
    :cred_inputs
        if not "1"=="!COMMAND_W!" goto begin
        echo Credential:
        @rem Username
        set /p CRED_USERNAME="- Userame []: "
        if ""=="!CRED_USERNAME!" goto required
        @rem Password
        set /p CRED_PASSWORD="- Password []: "
        if ""=="!CRED_PASSWORD!" goto required
        @rem Email
        if "ncrcred"=="!OPTION!" (
            set /p CRED_EMAIL="- Email []: "
            if ""=="!CRED_EMAIL!" goto required
        )
        goto begin

:required
    echo.
    echo sdocker: Field is required
    goto try

:begin
    call :begin_at
    if "image"=="!OPTION!" goto image_job
    if "wincred"=="!OPTION!" goto wincred_job
    if "nkscred"=="!OPTION!" goto nkscred_job
    if "ncrcred"=="!OPTION!" goto ncrcred_job
    if "ncp"=="!OPTION!" goto ncp_job

:image_job

:image_fields
    set "APP_NAME=!FIELD_N!"
    set "APP_VERSION=!FIELD_V!"
    if ""=="!FIELD_D!" (
        set "WORK_DIR=%DEFAULT_ROOT_DIR%\!APP_NAME!"
    ) else (
        set "WORK_DIR=!FIELD_D!"
    )
    if "gradle"=="!FIELD_B!" (
        set "BUILD_TOOL=gradle"
    )
    if "npm"=="!FIELD_B!" (
        set "BUILD_TOOL=npm"
    )
    if ""=="!FIELD_T!" (
        set "TARGET_REGISTRY_ENDPOINT=%DEFAULT_TARGET_REGISTRY_ENDPOINT%"
    ) else (
        set "TARGET_REGISTRY_ENDPOINT=!FIELD_T!"
    )
    if ""=="!TARGET_REGISTRY_ENDPOINT!" (
        set "TARGET_IMAGE=!APP_NAME!:!APP_VERSION!"
    ) else (
        set "TARGET_IMAGE=!TARGET_REGISTRY_ENDPOINT!/!APP_NAME!:!APP_VERSION!"
    )
    if ""=="!FIELD_O!" (
        set "ORIGIN_REGISTRY_ENDPOINT=%DEFAULT_ORIGIN_REGISTRY_ENDPOINT%"
    ) else (
        set "ORIGIN_REGISTRY_ENDPOINT=!FIELD_O!"
    )
    if ""=="!ORIGIN_REGISTRY_ENDPOINT!" (
        set "ORIGIN_IMAGE=!APP_NAME!:!APP_VERSION!"
    ) else (
        set "ORIGIN_IMAGE=!ORIGIN_REGISTRY_ENDPOINT!/!APP_NAME!:!APP_VERSION!"
    )
    if ""=="!FIELD_F!" (
        set "DOCKER_COMPOSE_FILE=%DEFAULT_ROOT_DIR%\!APP_NAME!\%DEFAULT_DOCKER_COMPOSE_FILE%"
    ) else (
        set "DOCKER_COMPOSE_FILE=!FIELD_F!"
    )
    call :info "Option: !OPTION!"
    call :info "Fields:"
    call :info "  Application:"
    call :info "    Name: !APP_NAME!"
    call :info "    Version: !APP_VERSION!"
    call :info "    Directory: !WORK_DIR!"
    call :info "  Build:"
    call :info "    Tool: !BUILD_TOOL!"
    call :info "  Registry:"
    call :info "    Origin:"
    call :info "      Endpoint: !ORIGIN_REGISTRY_ENDPOINT!"
    call :info "      Image: !ORIGIN_IMAGE!"
    call :info "    Target:"
    call :info "      Endpoint: !TARGET_REGISTRY_ENDPOINT!"
    call :info "      Image: !TARGET_IMAGE!"
    call :info "  Docker:"
    call :info "    Compose:"
    call :info "      File: !DOCKER_COMPOSE_FILE!"

:image_tasks
    if "1"=="!COMMAND_A!" (
        if ""=="!BUILD_TOOL!" (
            call :error "Build tool is required"
            goto fail
        )
        cd /d "!WORK_DIR!" >nul 2>&1
        if errorlevel 1 (
            call :error "'!WORK_DIR!' does not exist"
            goto done
        )
        if "gradle"=="!BUILD_TOOL!" (
            call :info "Build with Gradle:"
            call gradlew.bat clean build --refresh-dependencies -Pver=!APP_VERSION!
        )
        if "npm"=="!BUILD_TOOL!" (
            call :info "Build with NPM:"
            call npm run build
        )
        if errorlevel 1 (
            call :error "Failed to build with !BUILD_TOOL!"
            goto done
        )
    )
    if "1"=="!COMMAND_I!" (
        cd /d "!WORK_DIR!" >nul 2>&1
        if errorlevel 1 (
            call :error "'!WORK_DIR!' does not exist"
            goto done
        )
        call :info "Build Docker Image:"
        call docker compose -f !DOCKER_COMPOSE_FILE! build --no-cache
        if errorlevel 1 (
            call :error "Failed to build '!TARGET_IMAGE!'"
            goto done
        )
        call docker image prune -f
        if errorlevel 1 (
            call :error "Failed to prune images"
            goto done
        )
    )
    :image_skip_directory
    if "1"=="!COMMAND_R!" (
        call :info "Run Docker Image:"
        call docker compose -f !DOCKER_COMPOSE_FILE! up -d
        if errorlevel 1 (
            call :error "Failed to run '!TARGET_IMAGE!'"
            goto done
        )
        call docker image prune -f
        if errorlevel 1 (
            call :error "Failed to prune images"
            goto done
        )
    )
    if "1"=="!COMMAND_P!" (
        call :info "Push Docker Image:"
        call docker image push !TARGET_IMAGE!
        if errorlevel 1 (
            call :error "Failed to push '!TARGET_IMAGE!'"
            goto done
        )
    )
    if "1"=="!COMMAND_L!" (
        call :info "Pull Docker Image:"
        call docker image pull !ORIGIN_IMAGE!
        if errorlevel 1 (
            call :error "Failed to pull '!ORIGIN_IMAGE!'"
            goto done
        )
    )
    goto done

:wincred_job

:wincred_fields
    if ""=="!FIELD_X!" (
        set "EXE_FILE=%DEFAULT_DOCKER_WINCRED_EXE%"
    ) else (
        set "EXE_FILE=!FIELD_X!"
    )
    if ""=="!FIELD_T!" (
        set "TARGET_REGISTRY_ENDPOINT=%DEFAULT_TARGET_REGISTRY_ENDPOINT%"
    ) else (
        set "TARGET_REGISTRY_ENDPOINT=!FIELD_T!"
    )
    call :info "  File: !EXE_FILE!"
    call :info "  Registry:"
    call :info "    Target:"
    call :info "      Endpoint: !TARGET_REGISTRY_ENDPOINT!"

:wincred_tasks
    if "1"=="!COMMAND_L!" goto wincred_list
    if "1"=="!COMMAND_R!" goto wincred_show
    if "1"=="!COMMAND_W!" goto wincred_update
    if "1"=="!COMMAND_D!" goto wincred_delete
    :wincred_list
        call :info "List Docker Registry Credentials:"
        call !EXE_FILE! list
        goto done
    :wincred_show
        call :info "Show Docker Registry Credential:"
        call echo !TARGET_REGISTRY_ENDPOINT! | !EXE_FILE! get
        goto done
    :wincred_update
        call :info "Update Docker Registry Credential:"
        call echo {"ServerURL":"!TARGET_REGISTRY_ENDPOINT!","Username":"!CRED_USERNAME!","Secret":"!CRED_PASSWORD!"} | !EXE_FILE! store
        goto wincred_list
    :wincred_delete
        call :info "Delete Docker Registry Credential:"
        call echo !TARGET_REGISTRY_ENDPOINT! | !EXE_FILE! erase
        goto wincred_list
    goto fail

:nkscred_job

:nkscred_fields
    if ""=="!FIELD_X!" (
        set "EXE_FILE=%DEFAULT_NCP_IAM_EXE%"
    ) else (
        set "EXE_FILE=!FIELD_X!"
    )
    if ""=="!FIELD_C!" (
        set "CLUSTER_NAME=%DEFAULT_CLUSTER_NAME%"
    ) else (
        set "CLUSTER_NAME=!FIELD_C!"
    )
    if ""=="!FIELD_D!" (
        set "WORK_DIR=%DEFAULT_ROOT_DIR%\!CLUSTER_NAME!"
    ) else (
        set "WORK_DIR=!FIELD_D!"
    )
    if ""=="!FIELD_F!" (
        set "KUBE_CONFIG_FILE=!WORK_DIR!\%DEFAULT_KUBE_CONFIG_FILE%"
    ) else (
        set "KUBE_CONFIG_FILE=!FIELD_F!"
    )
    if ""=="!FIELD_R!" (
        set "NKS_REGION=%DEFAULT_NKS_REGION%"
    ) else (
        set "NKS_REGION=!FIELD_R!"
    )
    if ""=="!FIELD_U!" (
        set "NKS_UUID=%DEFAULT_NKS_UUID%"
    ) else (
        set "NKS_UUID=!FIELD_U!"
    )
    call :info "  File: !EXE_FILE!"
    call :info "  Kubernetes:"
    call :info "    Cluster:"
    call :info "      Name: !CLUSTER_NAME!"
    call :info "      File: !KUBE_CONFIG_FILE!"
    call :info "      Region: !NKS_REGION!"
    call :info "      UUID: !NKS_UUID!"

:nkscred_tasks
    if ""=="!CLUSTER_NAME!" (
        call :error "Cluster name is required"
        goto fail
    )
    if ""=="!NKS_UUID!" (
        call :error "Cluster UUID is required"
        goto fail
    )
    call :info "Update NCR Credential:"
    set "NCP_CONFIGURE=%UserProfile%\.ncloud\configure"
    if exist !NCP_CONFIGURE! (
        call del !NCP_CONFIGURE!
        if errorlevel 1 (
            call :error "Failed to delete '!NCP_CONFIGURE!'"
            goto done
        )
    )
    call echo ncloud_access_key_id     = !CRED_USERNAME!> !NCP_CONFIGURE!
    call echo ncloud_secret_access_key = !CRED_PASSWORD!>> !NCP_CONFIGURE!
    call echo ncloud_api_url           = https://ncloud.apigw.ntruss.com>> !NCP_CONFIGURE!
    call !EXE_FILE! create-kubeconfig --output !KUBE_CONFIG_FILE! --region !NKS_REGION! --clusterName !CLUSTER_NAME! --clusterUuid !NKS_UUID!
    if errorlevel 1 (
        call :error "Failed to update '!KUBE_CONFIG_FILE!'"
        goto done
    )
    goto done

:ncrcred_job

:ncrcred_fields
    if ""=="!FIELD_C!" (
        set "CLUSTER_NAME=%DEFAULT_CLUSTER_NAME%"
    ) else (
        set "CLUSTER_NAME=!FIELD_C!"
    )
    if ""=="!FIELD_D!" (
        set "WORK_DIR=%DEFAULT_ROOT_DIR%\!CLUSTER_NAME!"
    ) else (
        set "WORK_DIR=!FIELD_D!"
    )
    if ""=="!FIELD_F!" (
        set "KUBE_CONFIG_FILE=!WORK_DIR!\%DEFAULT_KUBE_CONFIG_FILE%"
    ) else (
        set "KUBE_CONFIG_FILE=!FIELD_F!"
    )
    if ""=="!FIELD_T!" (
        set "TARGET_REGISTRY_ENDPOINT=%DEFAULT_TARGET_REGISTRY_ENDPOINT%"
    ) else (
        set "TARGET_REGISTRY_ENDPOINT=!FIELD_T!"
    )
    if ""=="!FIELD_N!" (
        set "CRED_NAME=!FIELD_N!"
    )
    call :info "  Registry:"
    call :info "    Target:"
    call :info "      Endpoint: !TARGET_REGISTRY_ENDPOINT!"
    call :info "  Kubernetes:"
    call :info "    Cluster:"
    call :info "      Name: !CLUSTER_NAME!"
    call :info "      File: !KUBE_CONFIG_FILE!"
    call :info "    Credential:"
    call :info "      Name: !CRED_NAME!"

:ncrcred_tasks
    if ""=="!CRED_NAME!" (
        call :error "Credential name is required"
        goto try
    )
    if "1"=="!COMMAND_L!" goto ncrcred_list
    if "1"=="!COMMAND_R!" goto ncrcred_show
    if "1"=="!COMMAND_W!" goto ncrcred_update
    if "1"=="!COMMAND_D!" goto ncrcred_delete
    :ncrcred_list
        call :info "List NCR Credentials:"
        call kubectl --kubeconfig !KUBE_CONFIG_FILE! get secrets
        goto done
    :ncrcred_show
        call :info "Show NCR Credential:"
        call kubectl --kubeconfig !KUBE_CONFIG_FILE! get secret !CRED_NAME!
        goto done
    :ncrcred_update
        call :info "Update NCR Credential:"
        call kubectl --kubeconfig !KUBE_CONFIG_FILE! create secret docker-registry !CRED_NAME! --docker-server=!TARGET_REGISTRY_ENDPOINT! --docker-username=!CRED_USERNAME! --docker-password=!CRED_PASSWORD! --docker-email=!CRED_EMAIL!
        goto ncrcred_list
    :ncrcred_delete
        call :info "Delete NCR Credential:"
        call kubectl --kubeconfig !KUBE_CONFIG_FILE! delete secret !CRED_NAME!
        goto ncrcred_list
    goto fail

:ncp_job

:ncp_fields
    if ""=="!FIELD_O!" (
        set "ORIGIN_REGISTRY_ENDPOINT=%DEFAULT_ORIGIN_REGISTRY_ENDPOINT%"
    ) else (
        set "ORIGIN_REGISTRY_ENDPOINT=!FIELD_T!"
    )
    if ""=="!FIELD_T!" (
        set "TARGET_REGISTRY_ENDPOINT=%DEFAULT_TARGET_REGISTRY_ENDPOINT%"
    ) else (
        set "TARGET_REGISTRY_ENDPOINT=!FIELD_T!"
    )
    if ""=="!FIELD_C!" (
        set "CLUSTER_NAME=%DEFAULT_CLUSTER_NAME%"
    ) else (
        set "CLUSTER_NAME=!FIELD_C!"
    )
    if ""=="!FIELD_D!" (
        set "WORK_DIR=%DEFAULT_ROOT_DIR%\!CLUSTER_NAME!"
    ) else (
        set "WORK_DIR=!FIELD_D!"
    )
    if ""=="!FIELD_F!" (
        set "KUBE_CONFIG_FILE=!WORK_DIR!\%DEFAULT_KUBE_CONFIG_FILE%"
    ) else (
        set "KUBE_CONFIG_FILE=!FIELD_F!"
    )
    if ""=="!FIELD_K!" (
        set "KUBE_KUSTOMIZATION_FILE=!WORK_DIR!\!APP_NAME!\%DEFAULT_KUBE_KUSTOMIZATION_FILE%"
    ) else (
        set "KUBE_KUSTOMIZATION_FILE=!FIELD_K!"
    )
    call :info "  Registry:"
    call :info "    Origin:"
    call :info "      Endpoint: !ORIGIN_REGISTRY_ENDPOINT!"
    call :info "      Image: !ORIGIN_IMAGE!"
    call :info "    Target:"
    call :info "      Endpoint: !TARGET_REGISTRY_ENDPOINT!"
    call :info "      Image: !TARGET_IMAGE!"
    call :info "  Kubernetes:"
    call :info "    Cluster:"
    call :info "      Name: !CLUSTER_NAME!"
    call :info "      File: !KUBE_CONFIG_FILE!"
    call :info "    Kustomize:"
    call :info "      File: !KUBE_KUSTOMIZATION_FILE!"

:ncp_tasks
    if ""=="!CLUSTER_NAME!" (
        call :error "Cluster name is required"
        goto fail
    )
    if "1"=="!COMMAND_M!" (
        call :info "Pull Origin Image:"
        call docker image pull !ORIGIN_IMAGE!
        if errorlevel 1 (
            call :error "Failed to pull '!ORIGIN_IMAGE!'"
            goto done
        )
        call :info "Rename Origin Image:"
        call docker image tag !ORIGIN_IMAGE! !TARGET_IMAGE!
        if errorlevel 1 (
            call :error "Failed to rename '!ORIGIN_IMAGE!' to '!TARGET_IMAGE!'"
            goto done
        )
        call :info "Delete Origin Image:"
        call docker image rm !ORIGIN_IMAGE!
        if errorlevel 1 (
            call :error "Failed to delete '!ORIGIN_IMAGE!'"
            goto done
        )
        call :info "Push Target Image:"
        call docker image push !TARGET_IMAGE!
        if errorlevel 1 (
            call :error "Failed to push '!TARGET_IMAGE!'"
            goto done
        )
        call :info "Delete Target Image:"
        call docker image rm !TARGET_IMAGE!
        if errorlevel 1 (
            call :error "Failed to delete '!TARGET_IMAGE!'"
            goto done
        )
    )
    if "1"=="!COMMAND_A!" (
        cd /d "!WORK_DIR!" >nul 2>&1
        if errorlevel 1 (
            call :error "'!WORK_DIR!' does not exist"
            goto done
        )
        call :info "Apply Docker Image:"
        call kustomize edit set image !APP_NAME!=!TARGET_IMAGE!
        if errorlevel 1 (
            call :error "Failed to edit '!TARGET_IMAGE!'"
            goto done
        )
        call kubectl kustomize ./ | kubectl --kubeconfig !KUBE_CONFIG_FILE! apply -f -
        if errorlevel 1 (
            call :error "Failed to apply '!TARGET_IMAGE!'"
            goto done
        )
    )
    goto done

:done
    call :end_at
    call :elapsed
    if ""=="!EXIT_CODE!" set "EXIT_CODE=!ERRORLEVEL!"
    if 0==!EXIT_CODE! (
        call :info "%GREEN%Success%NOCOLOR% in %YELLOW%!DIFF_HH!:!DIFF_MM!:!DIFF_SS!.!DIFF_MS:~0,3!%NOCOLOR%"
    ) else (
        call :error "%RED%Fail%NOCOLOR% in %YELLOW%!DIFF_HH!:!DIFF_MM!:!DIFF_SS!.!DIFF_MS:~0,3!%NOCOLOR%"
    )

goto end

:usage
    echo Usage: sdocker [option] [commands...] [fields...]
    echo   Options:
    echo     help     Get help for for more information
    echo     image    Image Tasks
    echo              Commands:
    echo                -A  Build Application
    echo                    Required Fields:
    echo                      -n [name]       Application Name
    echo                      -v [version]    Application Version
    echo                      -d [directory]  Working directory (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Application Name]%NOCOLOR%)
    echo                      -b [tool]       Build Tool
    echo                                      Tools: %SKY%gradle, npm%NOCOLOR%
    echo                    Compatible Commands:
    echo                      -BI
    echo                      -BIP
    echo                -I  Build Docker Image (Compose Build)
    echo                    Required Fields:
    echo                      -n [name]       Application Name
    echo                      -v [version]    Application Version
    echo                      -d [directory]  Working directory (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Application Name]%NOCOLOR%)
    echo                      -t [endpoint]   Target Registry Endpoint (DEFAULT: %SKY%%DEFAULT_TARGET_REGISTRY_ENDPOINT%%NOCOLOR%)
    echo                      -f [file]       Docker Compose File (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Application Name]%NOCOLOR%%SKY%\%DEFAULT_DOCKER_COMPOSE_FILE%%NOCOLOR%)
    echo                    Compatible Commands:
    echo                      -BI
    echo                      -BIP
    echo                -R  Run Docker Image (Compose Up)
    echo                    Required Fields:
    echo                      -n [name]       Application Name
    echo                      -v [version]    Application Version
    echo                      -d [directory]  Working directory (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Application Name]%NOCOLOR%)
    echo                      -t [endpoint]   Target Registry Endpoint (DEFAULT: %SKY%%DEFAULT_TARGET_REGISTRY_ENDPOINT%%NOCOLOR%)
    echo                      -f [file]       Docker Compose File (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Application Name]%NOCOLOR%%SKY%\%DEFAULT_DOCKER_COMPOSE_FILE%%NOCOLOR%)
    echo                    Compatible Commands:
    echo                      -BR
    echo                -P  Push Docker Image
    echo                    Required Fields:
    echo                      -n [name]       Application Name
    echo                      -v [version]    Application Version
    echo                      -t [endpoint]   Target Registry Endpoint (DEFAULT: %SKY%%DEFAULT_TARGET_REGISTRY_ENDPOINT%%NOCOLOR%)
    echo                    Compatible Commands:
    echo                      -BIP
    echo                -L  Pull Docker Image
    echo                    Required Fields:
    echo                      -n [name]       Application Name
    echo                      -v [version]    Application Version
    echo                      -o [endpoint]   Origin Registry Endpoint (DEFAULT: %SKY%%DEFAULT_ORIGIN_REGISTRY_ENDPOINT%%NOCOLOR%)
    echo                      -t [endpoint]   Target Registry Endpoint (DEFAULT: %SKY%%DEFAULT_TARGET_REGISTRY_ENDPOINT%%NOCOLOR%)
    echo     wincred  Windows Docker Credential Tasks
    echo              Commands:
    echo                -L  List Credentials
    echo                    Required Fields:
    echo                      -x [file]       Docker Wincred File (DEFAULT: %SKY%%DEFAULT_DOCKER_WINCRED_EXE%%NOCOLOR%)
    echo                -W  Update Credential
    echo                    Required Fields:
    echo                      -x [file]       Docker Wincred File (DEFAULT: %SKY%%DEFAULT_DOCKER_WINCRED_EXE%%NOCOLOR%)
    echo                      -t [endpoint]   Target Registry Endpoint (DEFAULT: %SKY%%DEFAULT_TARGET_REGISTRY_ENDPOINT%%NOCOLOR%)
    echo                -R  Show Credential
    echo                    Required Fields:
    echo                      -x [file]       Docker Wincred File (DEFAULT: %SKY%%DEFAULT_DOCKER_WINCRED_EXE%%NOCOLOR%)
    echo                      -t [endpoint]   Target Registry Endpoint (DEFAULT: %SKY%%DEFAULT_TARGET_REGISTRY_ENDPOINT%%NOCOLOR%)
    echo                -D  Delete Credential
    echo                    Required Fields:
    echo                      -x [file]       Docker Wincred File (DEFAULT: %SKY%%DEFAULT_DOCKER_WINCRED_EXE%%NOCOLOR%)
    echo                      -t [endpoint]   Target Registry Endpoint (DEFAULT: %SKY%%DEFAULT_TARGET_REGISTRY_ENDPOINT%%NOCOLOR%)
    echo     nkscred  NKS Credential Tasks
    echo              Commands:
    echo                -W  Update Credential
    echo                    Required Fields:
    echo                      -x [file]       NCP IAM Authenticator File (DEFAULT: %SKY%%DEFAULT_NCP_IAM_EXE%%NOCOLOR%)
    echo                                      Input Fields:
    echo                                        Ncloud Access Key Id []:
    echo                                        Ncloud Secret Access Key []:
    echo                                        Ncloud API URL []: https://ncloud.apigw.ntruss.com
    echo                      -c [name]       Cluster Name
    echo                      -d [directory]  Working directory (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Cluster Name]%NOCOLOR%)
    echo                      -f [file]       Cluster kubeconfig File (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Cluster Name]%NOCOLOR%%SKY%\%DEFAULT_KUBE_CONFIG_FILE%%NOCOLOR%)
    echo                      -r [region]     Region (DEFAULT: %SKY%%DEFAULT_NKS_REGION%%NOCOLOR%)
    echo                                      Regions: %SKY%KR, SGN, JPN%NOCOLOR%
    echo                      -u [uuid]       Cluster Uuid
    echo     ncrcred  NCR Credential Tasks
    echo              Commands:
    echo                -L  List Credentials
    echo                    Required Fields:
    echo                      -c [name]       Cluster Name
    echo                      -d [directory]  Working directory (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Cluster Name]%NOCOLOR%%SKY%\%NOCOLOR%%YELLOW%[Application Name]%NOCOLOR%)
    echo                      -f [file]       Cluster kubeconfig File (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Cluster Name]%NOCOLOR%%SKY%\%DEFAULT_KUBE_CONFIG_FILE%%NOCOLOR%)
    echo                      -t [endpoint]   Target Registry Endpoint (DEFAULT: %SKY%%DEFAULT_TARGET_REGISTRY_ENDPOINT%%NOCOLOR%)
    echo                -W  Update Credential
    echo                    Required Fields:
    echo                      -c [name]       Cluster Name
    echo                      -d [directory]  Working directory (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Cluster Name]%NOCOLOR%%SKY%\%NOCOLOR%%YELLOW%[Application Name]%NOCOLOR%)
    echo                      -f [file]       Cluster kubeconfig File (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Cluster Name]%NOCOLOR%%SKY%\%DEFAULT_KUBE_CONFIG_FILE%%NOCOLOR%)
    echo                      -t [endpoint]   Target Registry Endpoint (DEFAULT: %SKY%%DEFAULT_TARGET_REGISTRY_ENDPOINT%%NOCOLOR%)
    echo                      -n [name]       Credential Name
    echo                -R  Show Credential
    echo                    Required Fields:
    echo                      -c [name]       Cluster Name
    echo                      -d [directory]  Working directory (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Cluster Name]%NOCOLOR%%SKY%\%NOCOLOR%%YELLOW%[Application Name]%NOCOLOR%)
    echo                      -f [file]       Cluster kubeconfig File (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Cluster Name]%NOCOLOR%%SKY%\%DEFAULT_KUBE_CONFIG_FILE%%NOCOLOR%)
    echo                      -t [endpoint]   Target Registry Endpoint (DEFAULT: %SKY%%DEFAULT_TARGET_REGISTRY_ENDPOINT%%NOCOLOR%)
    echo                      -n [name]       Credential Name
    echo                -D  Delete Credential
    echo                    Required Fields:
    echo                      -c [name]       Cluster Name
    echo                      -d [directory]  Working directory (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Cluster Name]%NOCOLOR%%SKY%\%NOCOLOR%%YELLOW%[Application Name]%NOCOLOR%)
    echo                      -f [file]       Cluster kubeconfig File (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Cluster Name]%NOCOLOR%%SKY%\%DEFAULT_KUBE_CONFIG_FILE%%NOCOLOR%)
    echo                      -t [endpoint]   Target Registry Endpoint (DEFAULT: %SKY%%DEFAULT_TARGET_REGISTRY_ENDPOINT%%NOCOLOR%)
    echo                      -n [name]       Credential Name
    echo     ncp      Naver Cloud Platform Tasks
    echo                -M  Move Docker Image to NCR
    echo                    Required Fields:
    echo                      -n [name]       Application Name
    echo                      -v [version]    Application Version
    echo                      -o [endpoint]   Origin Registry Endpoint (DEFAULT: %SKY%%DEFAULT_ORIGIN_REGISTRY_ENDPOINT%%NOCOLOR%)
    echo                      -t [endpoint]   Target Registry Endpoint (DEFAULT: %SKY%%DEFAULT_TARGET_REGISTRY_ENDPOINT%%NOCOLOR%)
    echo                    Compatible Commands:
    echo                      -MA
    echo                -L  List Kubernetes Resources
    echo                -A  Apply Docker Image to NKS
    echo                    Required Fields:
    echo                      -n [name]       Application Name
    echo                      -v [version]    Application Version
    echo                      -c [name]       Cluster Name
    echo                      -d [directory]  Working directory (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Cluster Name]%NOCOLOR%%SKY%\%NOCOLOR%%YELLOW%[Application Name]%NOCOLOR%)
    echo                      -f [file]       Cluster kubeconfig File (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Cluster Name]%NOCOLOR%%SKY%\%DEFAULT_KUBE_CONFIG_FILE%%NOCOLOR%)
    echo                      -t [endpoint]   Target Registry Endpoint (DEFAULT: %SKY%%DEFAULT_TARGET_REGISTRY_ENDPOINT%%NOCOLOR%)
    echo                      -k [file]       Kustomization File (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Cluster Name]%NOCOLOR%%SKY%\%NOCOLOR%%YELLOW%[Application Name]%NOCOLOR%%SKY%\%DEFAULT_KUBE_KUSTOMIZATION_FILE%%NOCOLOR%)
    echo                    Compatible Commands:
    echo                      -MA
    echo                -D  Delete Deployment and Service
    echo                    Required Fields:
    echo                      -n [name]       Application Name
    echo                      -v [version]    Application Version
    echo                      -c [name]       Cluster Name
    echo                      -d [directory]  Working directory (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Cluster Name]%NOCOLOR%%SKY%\%NOCOLOR%%YELLOW%[Application Name]%NOCOLOR%)
    echo                      -f [file]       Cluster kubeconfig File (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Cluster Name]%NOCOLOR%%SKY%\%DEFAULT_KUBE_CONFIG_FILE%%NOCOLOR%)
    echo                      -t [endpoint]   Target Registry Endpoint (DEFAULT: %SKY%%DEFAULT_TARGET_REGISTRY_ENDPOINT%%NOCOLOR%)
    echo                      -k [file]       Kustomization File (DEFAULT: %SKY%%DEFAULT_ROOT_DIR%\%NOCOLOR%%YELLOW%[Cluster Name]%NOCOLOR%%SKY%\%NOCOLOR%%YELLOW%[Application Name]%NOCOLOR%%SKY%\%DEFAULT_KUBE_KUSTOMIZATION_FILE%%NOCOLOR%)
    echo                    Compatible Commands:
    echo                      -MA
    echo.
    goto end

:begin_at
    for /f "tokens=1,2 delims=.," %%a in ('powershell Get-Date -UFormat %%s') do (set "BEGIN_AT_SS=%%a" & set "BEGIN_AT_MS=1%%b")
    if !BEGIN_AT_MS! lss 100000 set "BEGIN_AT_MS=!BEGIN_AT_MS!0"
    exit /b

:end_at
    for /f "tokens=1,2 delims=.," %%a in ('powershell Get-Date -UFormat %%s') do set "END_AT_SS=%%a" & set "END_AT_MS=1%%b"
    if !END_AT_MS! lss 100000 set "END_AT_MS=!END_AT_MS!0"
    exit /b

:elapsed
    if !BEGIN_AT_MS! gtr !END_AT_MS! set /a "END_AT_MS=!END_AT_MS!+100000" & set /a "END_AT_SS=!END_AT_SS!-1"
    set /a "ELAPSED_SS=!END_AT_SS!-!BEGIN_AT_SS!"
    set /a "DIFF_HH=!ELAPSED_SS!/3600"
    if !DIFF_HH! lss 10 set "DIFF_HH=0!DIFF_HH!"
    set /a "DIFF_MM=(!ELAPSED_SS!%%3600)/60"
    if !DIFF_MM! lss 10 set "DIFF_MM=0!DIFF_MM!"
    set /a "DIFF_SS=!ELAPSED_SS!%%60"
    if !DIFF_SS! lss 10 set "DIFF_SS=0!DIFF_SS!"
    set /a "DIFF_MS=!END_AT_MS!-!BEGIN_AT_MS!"
    exit /b

:info
    echo [%date% %time%] [%GREEN% INFO%NOCOLOR%] %~1
    exit /b

:warn
    echo [%date% %time%] [%YELLOW% WARN%NOCOLOR%] %~1
    exit /b

:error
    echo [%date% %time%] [%RED%ERROR%NOCOLOR%] %~1
    exit /b

:colors
    set "ESC="
    for /f %%a in ('echo prompt $E ^| cmd') do (set "ESC=%%a")
    set "NOCOLOR=%ESC%[0m"
    set "RED=%ESC%[31m"
    set "GREEN=%ESC%[32m"
    set "YELLOW=%ESC%[33m"
    set "BLUE=%ESC%[34m"
    set "PURPLE=%ESC%[35m"
    set "SKY=%ESC%[36m"
    set "WHITE=%ESC%[37m"
    exit /b

:import_ini
    set "SDOCKER_INI=%SDOCKER_DIR%\%SDOCKER_FILE%.ini"
    if not exist !SDOCKER_INI! (
        exit /b
    )
    for /f "tokens=1,2 delims==" %%a in (!SDOCKER_INI!) do (
        set "KEY=%%a"
        set "VAL=%%b"
        if not ""=="!KEY!" if not ""=="!VAL!" if not "#"=="!KEY:~0,1!" set "DEFAULT_!KEY!=!VAL!"
    )
    exit /b

:try
    echo.
    echo Use 'sdocker help' for more information
    echo.
    goto fail

:success
    set "EXIT_CODE=0"
    goto end

:fail
    set "EXIT_CODE=1"
    goto end

:end
    endlocal
    if not "!OPTION!"=="!OPTION:cred=!" (
        call cmd /k
    )
    exit /b !EXIT_CODE!
