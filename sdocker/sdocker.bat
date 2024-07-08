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
set "SDOCKER_RELEASE=2024-07-08"

@rem Options
set "OPTION_H=0"
set "OPTION_V=0"
set "OPTION_B=0"
set "OPTION_D=0"
set "OPTION_U=0"
set "OPTION_P=0"
set "OPTION_L=0"
set "OPTION_S=0"
set "OPTION_A=0"
set "OPTION_C=0"

@rem Process
set "EXIT_CODE="

if "%~1"=="" (
    goto try
)

:parse
    set "ARG1=%~1"
    set "ARG2=%~2"
    if "!ARG1!"=="" goto valid
    if "-h"=="!ARG1!" (
        set "OPTION_H=1"
        goto init
    )
    if "-v"=="!ARG1!" (
        set "OPTION_V=1"
        goto init
    )
    if "-i"=="!ARG1!" (
        set "OPTION_INPUT=1"
        shift
        goto parse
    )
    if "-an"=="!ARG1!" (
        if not "-"=="!ARG2:~0,1!" (
            set "APP_NAME=!ARG2!"
            shift
        )
        shift
        goto parse
    )
    if "-av"=="!ARG1!" (
        if not "-"=="!ARG2:~0,1!" (
            set "APP_VERSION=!ARG2!"
            shift
        )
        shift
        goto parse
    )
    if "-ab"=="!ARG1!" (
        if not "-"=="!ARG2:~0,1!" (
            set "APP_BUILD=!ARG2!"
            shift
        )
        shift
        goto parse
    )
    if "-ap"=="!ARG1!" (
        if not "-"=="!ARG2:~0,1!" (
            set "WORK_DIR=!ARG2!"
            shift
        )
        shift
        goto parse
    )
    if "-dc"=="!ARG1!" (
        if not "-"=="!ARG2:~0,1!" (
            set "DOCKER_COMPOSE_FILE=!ARG2!"
            shift
        )
        shift
        goto parse
    )
    if "-do"=="!ARG1!" (
        if not "-"=="!ARG2:~0,1!" (
            set "ORIGIN_REGISTRY_ENDPOINT=!ARG2!"
            shift
        )
        shift
        goto parse
    )
    if "-dt"=="!ARG1!" (
        if not "-"=="!ARG2:~0,1!" (
            set "TARGET_REGISTRY_ENDPOINT=!ARG2!"
            shift
        )
        shift
        goto parse
    )
    if "-np"=="!ARG1!" (
        if not "-"=="!ARG2:~0,1!" (
            set "NCR_PUBLIC_ENDPOINT=!ARG2!"
            shift
        )
        shift
        goto parse
    )
    if "-ns"=="!ARG1!" (
        if not "-"=="!ARG2:~0,1!" (
            set "NCR_PRIVATE_ENDPOINT=!ARG2!"
            shift
        )
        shift
        goto parse
    )
    if "-kn"=="!ARG1!" (
        if not "-"=="!ARG2:~0,1!" (
            set "CLUSTER_NAME=!ARG2!"
            shift
        )
        shift
        goto parse
    )
    if "-kp"=="!ARG1!" (
        if not "-"=="!ARG2:~0,1!" (
            set "WORK_DIR=!ARG2!"
            shift
        )
        shift
        goto parse
    )
    if "-kc"=="!ARG1!" (
        if not "-"=="!ARG2:~0,1!" (
            set "KUBE_CONFIG_FILE=!ARG2!"
            shift
        )
        shift
        goto parse
    )
    if "-ka"=="!ARG1!" (
        if not "-"=="!ARG2:~0,1!" (
            set "KUBE_APPLY_FILE=!ARG2!"
            shift
        )
        shift
        goto parse
    )
    if "-wc"=="!ARG1!" (
        if not "-"=="!ARG2:~0,1!" (
            set "CHARSET=!ARG2!"
            shift
        )
        shift
        goto parse
    )
    if not "-"=="!ARG1:~0,1!" (
        echo sdocker%COLON% option !ARG1! is not supported
        goto try
    )
    set "OPTIONS=!ARG1:~1!"
    :split
        if ""=="!OPTIONS!" (
            shift
            goto parse
        )
        set "OPTION=!OPTIONS:~0,1!"
        if "B"=="!OPTION!" (
            set "OPTION_B=1"
            set "OPTIONS=!OPTIONS:~1!"
            goto split
        )
        if "D"=="!OPTION!" (
            set "OPTION_D=1"
            set "OPTIONS=!OPTIONS:~1!"
            goto split
        )
        if "U"=="!OPTION!" (
            set "OPTION_U=1"
            set "OPTIONS=!OPTIONS:~1!"
            goto split
        )
        if "P"=="!OPTION!" (
            set "OPTION_P=1"
            set "OPTIONS=!OPTIONS:~1!"
            goto split
        )
        if "L"=="!OPTION!" (
            set "OPTION_L=1"
            set "OPTIONS=!OPTIONS:~1!"
            goto split
        )
        if "S"=="!OPTION!" (
            set "OPTION_S=1"
            set "OPTIONS=!OPTIONS:~1!"
            goto split
        )
        if "A"=="!OPTION!" (
            set "OPTION_A=1"
            set "OPTIONS=!OPTIONS:~1!"
            goto split
        )
        if "C"=="!OPTION!" (
            set "OPTION_C=1"
            set "OPTIONS=!OPTIONS:~1!"
            goto split
        )
        echo sdocker%COLON% option -!OPTION! is not supported
        goto try

:valid
    set /a "SUMM=!OPTION_U!+!OPTION_P!"
    if !SUMM! gtr 1 goto invalid
    set /a "SUMM=!OPTION_B!+!OPTION_D!+!OPTION_U!+!OPTION_P!"
    if !SUMM! gtr 0 (
        set /a "SUMM=!OPTION_S!+!OPTION_A!"
        if !SUMM! gtr 0 goto invalid
    )
    goto init

:invalid
    echo sdocker%COLON% options are invalid
    goto try

:init
    call :colors
    call :symbols
    if ""=="!CHARSET!" (
        set "CHARSET=%DEFAULT_CHARSET%"
    )
    call chcp !CHARSET! >nul 2>&1
    if errorlevel 1 (
        echo sdocker%COLON% Invalid code page
        goto try
    )
    call :import_ini
    if "1"=="!OPTION_H!" goto usage
    if "1"=="!OPTION_V!" goto sdocker

@rem Application
:input_app
    echo Application
    @rem Name
    :input_app_name
        if not ""=="!APP_NAME!" (
            echo - Name []%COLON% !APP_NAME!
            goto input_app_version
        )
        set /p APP_NAME="- Name []%COLON% "
        if ""=="!APP_NAME!" goto required
    @rem Version
    :input_app_version
        if not ""=="!APP_VERSION!" (
            echo - Version []%COLON% !APP_VERSION!
            goto input_app_build
        )
        set /p APP_VERSION="- Version []%COLON% "
        if ""=="!APP_VERSION!" goto required
    @rem Build
    :input_app_build
        if not "1"=="!OPTION_B!" goto input_app_path
        if not ""=="!APP_BUILD!" (
            echo - Build []%COLON% !APP_BUILD!
            goto input_app_path
        )
        set /p APP_BUILD="- Build [gradle|npm]%COLON% "
        if ""=="!APP_BUILD!" goto required
    @rem Path
    :input_app_path
        if not "1"=="!OPTION_B!" if not "1"=="!OPTION_D!" if not "1"=="!OPTION_U!" goto input_registry
        if not ""=="!WORK_DIR!" (
            echo - Path [%DEFAULT_ROOT_DIR%\!APP_NAME!]%COLON% !WORK_DIR!
            goto move_app_path
        )
        if not "1"=="!OPTION_INPUT!" (
            set "WORK_DIR=%DEFAULT_ROOT_DIR%\!APP_NAME!"
            echo - Path [%DEFAULT_ROOT_DIR%\!APP_NAME!]%COLON% !WORK_DIR!
            goto move_app_path
        )
        set /p WORK_DIR="- Path [%DEFAULT_ROOT_DIR%\!APP_NAME!]%COLON% "
        if ""=="!WORK_DIR!" (
            set /p CONTINUE="Continue using the default value [y/n]%COLON% "
            if /i not "y"=="!CONTINUE!" goto end
            set "WORK_DIR=%DEFAULT_ROOT_DIR%\!APP_NAME!"
        )
    :move_app_path
        cd /d "!WORK_DIR!" >nul 2>&1
        if errorlevel 1 (
            echo.
            echo sdocker%COLON% Failed to move to !WORK_DIR!
            goto fail
        )
    @rem Docker Compose
    :input_docker_compose
        if not "1"=="!OPTION_D!" if not "1"=="!OPTION_U!" goto input_registry
        if not ""=="!DOCKER_COMPOSE_FILE!" (
            echo - Compose File [%DEFAULT_DOCKER_COMPOSE_FILE%]%COLON% !DOCKER_COMPOSE_FILE!
            goto input_registry
        )
        if not "1"=="!OPTION_INPUT!" (
            set "DOCKER_COMPOSE_FILE=%DEFAULT_DOCKER_COMPOSE_FILE%"
            echo - Compose File [%DEFAULT_DOCKER_COMPOSE_FILE%]%COLON% !DOCKER_COMPOSE_FILE!
            goto input_registry
        )
        set /p DOCKER_COMPOSE_FILE="- Compose File [%DEFAULT_DOCKER_COMPOSE_FILE%]%COLON% "
        if ""=="!DOCKER_COMPOSE_FILE!" (
            set /p CONTINUE="Continue using the default value [y/n]%COLON% "
            if /i not "y"=="!CONTINUE!" goto end
            set "DOCKER_COMPOSE_FILE=%DEFAULT_DOCKER_COMPOSE_FILE%"
        )

@rem Registry
:input_registry
    if not "1"=="!OPTION_D!" if not "1"=="!OPTION_U!" if not "1"=="!OPTION_P!" if not "1"=="!OPTION_L!" if not "1"=="!OPTION_S!" if not "1"=="!OPTION_A!" goto input_kubernetes
    echo Registry
    @rem Origin Registry
    :input_origin
        if not "1"=="!OPTION_L!" if not "1"=="!OPTION_S!" goto input_target
        if not ""=="!ORIGIN_REGISTRY_ENDPOINT!" (
            echo - Origin Registry Endpoint [%DEFAULT_ORIGIN_REGISTRY_ENDPOINT%]%COLON% !ORIGIN_REGISTRY_ENDPOINT!
            goto input_target
        )
        if not "1"=="!OPTION_INPUT!" (
            set "ORIGIN_REGISTRY_ENDPOINT=%DEFAULT_ORIGIN_REGISTRY_ENDPOINT%"
            echo - Origin Registry Endpoint [%DEFAULT_ORIGIN_REGISTRY_ENDPOINT%]%COLON% !ORIGIN_REGISTRY_ENDPOINT!
            goto input_target
        )
        set /p ORIGIN_REGISTRY_ENDPOINT="- Origin Registry Endpoint [%DEFAULT_ORIGIN_REGISTRY_ENDPOINT%]%COLON% "
        if ""=="!ORIGIN_REGISTRY_ENDPOINT!" (
            set /p CONTINUE="Continue using the default value [y/n]%COLON% "
            if /i not "y"=="!CONTINUE!" goto end
            set "ORIGIN_REGISTRY_ENDPOINT=%DEFAULT_ORIGIN_REGISTRY_ENDPOINT%"
        )
    @rem Target Registry
    :input_target
        if not "1"=="!OPTION_D!" if not "1"=="!OPTION_U!" if not "1"=="!OPTION_P!" goto input_ncr_public
        if not ""=="!TARGET_REGISTRY_ENDPOINT!" (
            echo - Target Registry Endpoint [%DEFAULT_TARGET_REGISTRY_ENDPOINT%]%COLON% !TARGET_REGISTRY_ENDPOINT!
            goto input_ncr_public
        )
        if not "1"=="!OPTION_INPUT!" (
            set "TARGET_REGISTRY_ENDPOINT=%DEFAULT_TARGET_REGISTRY_ENDPOINT%"
            echo - Target Registry Endpoint [%DEFAULT_TARGET_REGISTRY_ENDPOINT%]%COLON% !TARGET_REGISTRY_ENDPOINT!
            goto input_ncr_public
        )
        set /p TARGET_REGISTRY_ENDPOINT="- Target Registry Endpoint [%DEFAULT_TARGET_REGISTRY_ENDPOINT%]%COLON% "
        if ""=="!TARGET_REGISTRY_ENDPOINT!" (
            set /p CONTINUE="Continue using the default value [y/n]%COLON% "
            if /i not "y"=="!CONTINUE!" goto end
            set "TARGET_REGISTRY_ENDPOINT=%DEFAULT_TARGET_REGISTRY_ENDPOINT%"
        )
    @rem NCR Public
    :input_ncr_public
        if not "1"=="!OPTION_S!" goto input_ncr_private
        if not ""=="!NCR_PUBLIC_ENDPOINT!" (
            echo - NCR Public Name [%DEFAULT_NCR_PUBLIC_ENDPOINT%]%COLON% !NCR_PUBLIC_ENDPOINT!
            goto input_ncr_private
        )
        if not "1"=="!OPTION_INPUT!" (
            set "NCR_PUBLIC_ENDPOINT=%DEFAULT_NCR_PUBLIC_ENDPOINT%"
            echo - NCR Public Name [%DEFAULT_NCR_PUBLIC_ENDPOINT%]%COLON% !NCR_PUBLIC_ENDPOINT!
            goto input_ncr_private
        )
        set /p NCR_PUBLIC_ENDPOINT="- NCR Public Name [%DEFAULT_NCR_PUBLIC_ENDPOINT%]%COLON% "
        if ""=="!NCR_PUBLIC_ENDPOINT!" (
            set /p CONTINUE="Continue using the default value [y/n]%COLON% "
            if /i not "y"=="!CONTINUE!" goto end
            set "NCR_PUBLIC_ENDPOINT=%DEFAULT_NCR_PUBLIC_ENDPOINT%"
        )
    @rem NCR Private
    :input_ncr_private
        if not "1"=="!OPTION_A!" goto input_kubernetes
        if not ""=="!NCR_PRIVATE_ENDPOINT!" (
            echo - NCR Private Name [%DEFAULT_NCR_PRIVATE_ENDPOINT%]%COLON% !NCR_PRIVATE_ENDPOINT!
            goto input_kubernetes
        )
        if not "1"=="!OPTION_INPUT!" (
            set "NCR_PRIVATE_ENDPOINT=%DEFAULT_NCR_PRIVATE_ENDPOINT%"
            echo - NCR Public Name [%DEFAULT_NCR_PRIVATE_ENDPOINT%]%COLON% !NCR_PRIVATE_ENDPOINT!
            goto input_kubernetes
        )
        set /p NCR_PRIVATE_ENDPOINT="- NCR Private Name []%COLON% "
        if ""=="!NCR_PRIVATE_ENDPOINT!" (
            set /p CONTINUE="Continue using the default value [y/n]%COLON% "
            if /i not "y"=="!CONTINUE!" goto end
            set "NCR_PRIVATE_ENDPOINT=%DEFAULT_NCR_PRIVATE_ENDPOINT%"
        )

@rem Kubernetes
:input_kubernetes
    if not "1"=="!OPTION_S!" if not "1"=="!OPTION_A!" goto begin
    echo Kubernetes
    @rem Cluster
    :input_cluster_name
        if not ""=="!CLUSTER_NAME!" (
            echo - Cluster Name []%COLON% !CLUSTER_NAME!
            goto input_cluster_path
        )
        set /p CLUSTER_NAME="- Cluster Name []%COLON% "
        if ""=="!CLUSTER_NAME!" goto required
    :input_cluster_path
        if not ""=="!WORK_DIR!" (
            echo - Cluster Path [%DEFAULT_ROOT_DIR%\!CLUSTER_NAME!]%COLON% !WORK_DIR!
            goto move_cluster_path
        )
        if not "1"=="!OPTION_INPUT!" (
            set "WORK_DIR=%DEFAULT_ROOT_DIR%\!CLUSTER_NAME!"
            echo - Cluster Path [%DEFAULT_ROOT_DIR%\!CLUSTER_NAME!]%COLON% !WORK_DIR!
            goto move_cluster_path
        )
        set /p WORK_DIR="- Cluster Path [%DEFAULT_ROOT_DIR%\!CLUSTER_NAME!]%COLON% "
        if ""=="!WORK_DIR!" (
            set /p CONTINUE="Continue using the default value [y/n]%COLON% "
            if /i not "y"=="!CONTINUE!" goto end
            set "WORK_DIR=%DEFAULT_ROOT_DIR%\!CLUSTER_NAME!"
        )
    :move_cluster_path
        cd /d "!WORK_DIR!" >nul 2>&1
        if errorlevel 1 (
            echo.
            echo sdocker%COLON% Failed to move to !WORK_DIR!
            goto fail
        )
    @rem Config
    :input_kube_config
        if not ""=="!KUBE_CONFIG_FILE!" (
            echo - Cluster Config File [%DEFAULT_KUBE_CONFIG_FILE%]%COLON% !KUBE_CONFIG_FILE!
            goto input_kube_apply
        )
        if not "1"=="!OPTION_INPUT!" (
            set "KUBE_CONFIG_FILE=%DEFAULT_KUBE_CONFIG_FILE%"
            echo - Cluster Config File [%DEFAULT_KUBE_CONFIG_FILE%]%COLON% !KUBE_CONFIG_FILE!
            goto input_kube_apply
        )
        set /p KUBE_CONFIG_FILE="- Cluster Config File [%DEFAULT_KUBE_CONFIG_FILE%]%COLON% "
        if ""=="!KUBE_CONFIG_FILE!" (
            set /p CONTINUE="Continue using the default value [y/n]%COLON% "
            if /i not "y"=="!CONTINUE!" goto end
            set "KUBE_CONFIG_FILE=%DEFAULT_KUBE_CONFIG_FILE%"
        )
    @rem Apply
    :input_kube_apply
        if not ""=="!KUBE_APPLY_FILE!" (
            echo - Cluster Apply File [!APP_NAME!\%DEFAULT_KUBE_APPLY_FILE%]%COLON% !KUBE_APPLY_FILE!
            goto begin
        )
        if not "1"=="!OPTION_INPUT!" (
            set "KUBE_APPLY_FILE=!APP_NAME!\%DEFAULT_KUBE_APPLY_FILE%"
            echo - Cluster Apply File [!APP_NAME!\%DEFAULT_KUBE_APPLY_FILE%]%COLON% !KUBE_APPLY_FILE!
            goto begin
        )
        set /p KUBE_APPLY_FILE="- Cluster Apply File [!APP_NAME!\%DEFAULT_KUBE_APPLY_FILE%]%COLON% "
        if ""=="!KUBE_APPLY_FILE!" (
            set /p CONTINUE="Continue using the default value [y/n]%COLON% "
            if /i not "y"=="!CONTINUE!" goto end
            set "KUBE_APPLY_FILE=!APP_NAME!\%DEFAULT_KUBE_APPY%"
        )

:required
    echo.
    echo sdocker%COLON% This field is required
    goto try

:begin
    call :begin_at
    call :env

:build_gradle
    if not "1"=="!OPTION_B!" (
        call :warn "Build Gradle%COLON% skip"
        goto build_npm
    )
    if not "gradle"=="!APP_BUILD!" (
        call :warn "Build Gradle%COLON% skip"
        goto build_npm
    )
    call :info "Build Gradle%COLON%"
    call gradlew.bat clean build --refresh-dependencies -Pver=!APP_VERSION!
    if errorlevel 1 (
        call :error "Failed to build with gradle"
        goto done
    )

:build_npm
    if not "1"=="!OPTION_B!" (
        call :warn "Build NPM%COLON% skip"
        goto docker_build
    )
    if not "npm"=="!APP_BUILD!" (
        call :warn "Build NPM%COLON% skip"
        goto docker_build
    )
    call :info "Build NPM%COLON%"
    call npm run build
    if errorlevel 1 (
        call :error "Failed to build with npm"
        goto done
    )

:docker_build
    if not "1"=="!OPTION_D!" (
        call :warn "Compose Build Docker Image%COLON% skip"
        goto docker_run
    )
    call :info "Compose Build Docker Image%COLON%"
    call docker compose -f !DOCKER_COMPOSE_FILE! build --no-cache
    if errorlevel 1 (
        call :error "Failed to build the image"
        goto done
    )

:docker_run
    if not "1"=="!OPTION_U!" (
        call :warn "Compose Up Docker Image%COLON% skip"
        goto docker_clean
    )
    call :info "Compose Up Docker Image%COLON%"
    call docker compose -f !DOCKER_COMPOSE_FILE! up -d
    if errorlevel 1 (
        call :error "Failed to run the image"
        goto done
    )
    call docker compose ps -a

:docker_clean
    if not "1"=="!OPTION_D!" if not "1"=="!OPTION_U!" (
        call :warn "Prune Docker Image%COLON% skip"
        goto docker_wincred_list
    )
    call :info "Prune Docker Images%COLON%"
    call docker image prune -f

:docker_wincred_list
    if not "1"=="!DOCK_WINCRED_LIST!" (
        call :warn "List Docker Credentials%COLON% skip"
        goto docker_wincred_add
    )
    call :info "List Docker Credentials%COLON%"
    call !DOCKER_WINCRED_EXE! list

:docker_wincred_add
    if not "1"=="!DOCK_WINCRED_ADD!" (
        call :warn "Add Docker Credential%COLON% skip"
        goto docker_wincred_view
    )
    call :info "Add Docker Credential%COLON%"
    call echo !TARGET_REGISTRY_ENDPOINT! | !DOCKER_WINCRED_EXE! store

:docker_wincred_view
    if not "1"=="!DOCK_WINCRED_VIEW!" (
        call :warn "View Docker Credential%COLON% skip"
        goto docker_wincred_delete
    )
    call :info "View Docker Credential%COLON%"
    call echo !TARGET_REGISTRY_ENDPOINT! | !DOCKER_WINCRED_EXE! get

:docker_wincred_delete
    if not "1"=="!DOCK_WINCRED_DEL!" (
        call :warn "Delete Docker Credential%COLON% skip"
        goto docker_push
    )
    call :info "Delete Docker Credential%COLON%"
    call echo !TARGET_REGISTRY_ENDPOINT! | !DOCKER_WINCRED_EXE! erase

:docker_push
    if not "1"=="!OPTION_P!" (
        call :warn "Push Docker Image%COLON% skip"
        goto docker_pull
    )
    call :info "Push Docker Image%COLON%"
    call docker image push !TARGET_IMAGE!
    if errorlevel 1 (
        call :error "Failed to push the image"
        goto done
    )

:docker_pull
    if not "1"=="!OPTION_L!" (
        call :warn "Pull Docker Image%COLON% skip"
        goto docker_sync
    )
    call :info "Pull Docker Image%COLON%"
    call docker image pull !ORIGIN_IMAGE!
    if errorlevel 1 (
        call :error "Failed to pull the image"
        goto done
    )

:docker_sync
    if not "1"=="!OPTION_S!" (
        call :warn "Synchronize Docker Image%COLON% skip"
        goto kube_credential_list
    )
    call :info "Pull Docker Image%COLON% !ORIGIN_IMAGE!"
    call docker image pull !ORIGIN_IMAGE!
    if errorlevel 1 (
        call :error "Failed to pull the image"
        goto done
    )
    call :info "Rename Docker Image%COLON%"
    call docker image tag !ORIGIN_IMAGE! !NCR_PUBLIC_IMAGE!
    if errorlevel 1 (
        call :error "Failed to rename the image"
        goto done
    )
    call :info "Delete Docker Image%COLON% !ORIGIN_IMAGE!"
    call docker image rm !ORIGIN_IMAGE!
    if errorlevel 1 (
        call :error "Failed to delete the image"
        goto done
    )
    call :info "Push Docker Image%COLON% !NCR_PUBLIC_IMAGE!"
    call docker image push !NCR_PUBLIC_IMAGE!
    if errorlevel 1 (
        call :error "Failed to push the image"
        goto done
    )
    call :info "Delete Docker Image%COLON% !NCR_PUBLIC_IMAGE!"
    call docker image rm !NCR_PUBLIC_IMAGE!
    if errorlevel 1 (
        call :error "Failed to delete the image"
        goto done
    )

:kube_credential_list
    if not "1"=="!KUBE_CRED_LIST!" (
        call :warn "List Kubernetes Registry Credentials%COLON% skip"
        goto kube_credential_add
    )
    call :info "List Kubernetes Registry Credentials%COLON%"
    call kubectl --kubeconfig !KUBE_CONFIG_FILE! get secrets

:kube_credential_add
    if not "1"=="!KUBE_CRED_ADD!" (
        call :warn "Add Kubernetes Registry Credential%COLON% skip"
        goto kube_credential_view
    )
    call :info "Add Kubernetes Registry Credential%COLON%"
    call kubectl --kubeconfig !KUBE_CONFIG_FILE! create secret docker-registry [Name] --docker-server=[Registry Endpoint] --docker-username=[Username] --docker-password=[Password] --docker-email=[Email]

:kube_credential_view
    if not "1"=="!KUBE_CRED_VIEW!" (
        call :warn "View Kubernetes Registry Credential%COLON% skip"
        goto kube_credential_delete
    )
    call :info "View Kubernetes Registry Credential%COLON%"
    call kubectl --kubeconfig !KUBE_CONFIG_FILE! get secret !KUBE_CRED! -o jsonpath={.data}

:kube_credential_delete
    if not "1"=="!KUBE_CRED_DEL!" (
        call :warn "Delete Kubernetes Registry Credential%COLON% skip"
        goto kube_apply
    )
    call :info "Delete Kubernetes Registry Credential%COLON%"
    call kubectl --kubeconfig !KUBE_CONFIG_FILE! delete secret !KUBE_CRED!

:kube_apply
    if not "1"=="!OPTION_A!" (
        call :warn "Apply Docker Image%COLON% skip"
        goto kube_delete
    )
    call :info "Apply Docker Image%COLON% !NCR_PRIVATE_IMAGE!"
    call kubectl --kubeconfig !KUBE_CONFIG_FILE! apply -f !KUBE_APPLY_FILE!
    if errorlevel 1 (
        call :error "Failed to apply the image"
        goto done
    )

:kube_delete
    if not "1"=="!OPTION_C!" (
        call :warn "Delete Docker Image%COLON% skip"
        goto done
    )
    call :info "Delete Docker Image%COLON% !NCR_PRIVATE_IMAGE!"
    call kubectl --kubeconfig !KUBE_CONFIG_FILE! delete -f !KUBE_APPLY_FILE!
    if errorlevel 1 (
        call :error "Failed to apply the image"
        goto done
    )

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

:env
    if ""=="!ORIGIN_REGISTRY_ENDPOINT!" (
        set "ORIGIN_IMAGE=!APP_NAME!:!APP_VERSION!"
    ) else (
        set "ORIGIN_IMAGE=!ORIGIN_REGISTRY_ENDPOINT!/!APP_NAME!:!APP_VERSION!"
    )
    if ""=="!TARGET_REGISTRY_ENDPOINT!" (
        set "TARGET_IMAGE=!APP_NAME!:!APP_VERSION!"
    ) else (
        set "TARGET_IMAGE=!TARGET_REGISTRY_ENDPOINT!/!APP_NAME!:!APP_VERSION!"
    )
    if not ""=="!NCR_PUBLIC_ENDPOINT!" (
        set "NCR_PUBLIC_IMAGE=!NCR_PUBLIC_ENDPOINT!/!APP_NAME!:!APP_VERSION!"
    )
    if not ""=="!NCR_PRIVATE_ENDPOINT!" (
        set "NCR_PRIVATE_IMAGE=!NCR_PRIVATE_ENDPOINT!/!APP_NAME!:!APP_VERSION!"
    )
    call :info "Input%COLON%"
    call :info "  Application%COLON%"
    call :info "    Name%COLON% !APP_NAME!"
    call :info "    Version%COLON% !APP_VERSION!"
    call :info "    Build%COLON% !APP_Build!"
    call :info "    Path%COLON% !WORK_DIR!"
    call :info "    Compose%COLON% !DOCKER_COMPOSE_FILE!"
    call :info "  Registry%COLON%"
    call :info "    Origin%COLON%"
    call :info "      Endpoint%COLON% !ORIGIN_REGISTRY_ENDPOINT!"
    call :info "      Image%COLON% !ORIGIN_IMAGE!"
    call :info "    Target%COLON%"
    call :info "      Endpoint%COLON% !TARGET_REGISTRY_ENDPOINT!"
    call :info "      Image%COLON% !TARGET_IMAGE!"
    call :info "    NCR%COLON%"
    call :info "      Public%COLON%"
    call :info "        Endpoint%COLON% !NCR_PUBLIC_ENDPOINT!"
    call :info "        Image%COLON% !NCR_PUBLIC_IMAGE!"
    call :info "      Private%COLON%"
    call :info "        Endpoint%COLON% !NCR_PRIVATE_ENDPOINT!"
    call :info "        Image%COLON% !NCR_PRIVATE_IMAGE!"
    call :info "  Kubernetes%COLON%"
    call :info "    Cluster%COLON%"
    call :info "      Name%COLON% !CLUSTER_NAME!"
    call :info "      Path%COLON% !WORK_DIR!"
    call :info "      Config%COLON% !KUBE_CONFIG_FILE!"
    call :info "      Apply%COLON% !KUBE_APPLY_FILE!"
    call :info "  Active code page%COLON% !CHARSET!"

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

:log
    if "INFO"=="%~1" echo [%date% %time%] [%GREEN% INFO%NOCOLOR%] %~2
    if "ERROR"=="%~1" echo [%date% %time%] [%RED%ERROR%NOCOLOR%] %~2
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

:symbols
    set "COLON=:"
    set "AMPERSAND=^&"
    set "LT=^<"
    set "GT=^>"
    set "CARET=^^"
    exit /b

:import_ini
    set "SDOCKER_DIR=%~dp0"
    set "SDOCKER_INI=!SDOCKER_DIR!\sdocker.ini"
    if not exist !SDOCKER_INI! (
        exit /b
    )
    for /f "tokens=1,2 delims==" %%a in (!SDOCKER_INI!) do (
        set "KEY=%%a"
        set "VAL=%%b"
        if not ""=="!KEY!" if not ""=="!VAL!" if not "#"=="!KEY:~0,1!" set "DEFAULT_!KEY!=!VAL!"
    )
    exit /b

:sdocker
    echo number: !SDOCKER_VERSION!
    echo date: !SDOCKER_RELEASE!
    goto success

:usage
    echo Usage%COLON% sdocker [options...]
    echo   -h              Get help for commands
    echo   -v              Show version
    echo   -i              Choose or Input Field Values
    echo   -an [name]      Application Name
    echo   -av [version]   Application Version
    echo   -ab [tool]      Application Build
    echo                   Tools%COLON%
    echo                     gradle
    echo                     npm
    echo   -ap [path]      Application Path (DEFAULT%COLON% %SKY%%DEFAULT_ROOT_DIR%%NOCOLOR%\[Application Name])
    echo   -do [endpoint]  Origin Registry Endpoint (DEFAULT%COLON% %SKY%%DEFAULT_ORIGIN_REGISTRY_ENDPOINT%%NOCOLOR%)
    echo   -dt [endpoint]  Target Registry Endpoint (DEFAULT%COLON% %SKY%%DEFAULT_TARGET_REGISTRY_ENDPOINT%%NOCOLOR%)
    echo   -dc [file]      Docker Compose File (DEFAULT%COLON% %SKY%%DEFAULT_DOCKER_COMPOSE_FILE%%NOCOLOR%)
    echo   -np [name]      NCloud Public Container Registry Name
    echo                   End Point Suffix%COLON% [Public Registry Name].%SKY%.kr.ncr.ntruss.com%NOCOLOR%
    echo   -ns [name]      NCloud Private Container Registry Name
    echo                   End Point Suffix%COLON% [Private Registry Name].%SKY%.kr.private-ncr.ntruss.com%NOCOLOR%
    echo   -kn [name]      Kubernetes Cluster Name
    echo   -kp [path]      Kubernetes Cluster Path
    echo   -kc [file]      Kubernetes Cluster Config File
    echo   -ka [file]      Kubernetes Apply File
    echo   -wc [code]      Windows Active code page (DEFAULT%COLON% %SKY%!CHARSET!%NOCOLOR%)
    echo                   Codes%COLON%
    echo                     65001 utf-8
    echo                     51949 euc-kr
    echo                     28591 iso-8859-1
    echo                     For more code, head to https://learn.microsoft.com/en-us/windows/win32/intl/code-page-identifiers
    echo   -B              Build
    echo                   Compatible Options%COLON%
    echo                      -BD
    echo                      -BDU
    echo                      -BDP
    echo                   Required Fields%COLON%
    echo                     -an [Application Name]
    echo                     -av [Application Version]
    echo                     -ab [Application Build]
    echo                     -ap [Application Path]
    echo   -D              Compose Build Docker Image
    echo                   Compatible Options%COLON%
    echo                      -BD
    echo                      -BDU
    echo                      -BDP
    echo                   Required Fields%COLON%
    echo                     -an [Application Name]
    echo                     -av [Application Version]
    echo                     -ap [Application Path]
    echo                     -dt [Target Registry Endpoint]
    echo                     -dc [Docker Compose File]
    echo   -U              Compose Up Docker Image
    echo                   Compatible Options%COLON%
    echo                      -BDU
    echo                   Required Fields%COLON%
    echo                     -an [Application Name]
    echo                     -av [Application Version]
    echo                     -ap [Application Path]
    echo                     -dt [Target Registry Endpoint]
    echo                     -dc [Docker Compose File]
    echo   -P              Push Docker Image
    echo                   Compatible Options%COLON%
    echo                      -BDP
    echo                   Required Fields%COLON%
    echo                     -an [Application Name]
    echo                     -av [Application Version]
    echo                     -dt [Target Registry Endpoint]
    echo   -L              Pull Docker Image
    echo                   Compatible Options%COLON%
    echo                      -LU
    echo                   Required Fields%COLON%
    echo                     -an [Application Name]
    echo                     -av [Application Version]
    echo                     -do [Origin Registry Endpoint]
    echo                     -dt [Target Registry Endpoint]
    echo   -S              Synchronize Docker Image
    echo                   Compatible Options%COLON%
    echo                      -SA
    echo                   Required Fields%COLON%
    echo                     -an [Application Name]
    echo                     -av [Application Version]
    echo                     -do [Origin Registry Endpoint]
    echo                     -np [NCR Public Endpoint]
    echo   -A              Apply Container
    echo                   Compatible Options%COLON%
    echo                      -SA
    echo                   Required Fields%COLON%
    echo                     -an [Application Name]
    echo                     -av [Application Version]
    echo                     -ns [NCR Private Endpoint]
    echo                     -kn [Kubernetes Cluster Name]
    echo                     -kc [Kubernetes Cluster Config File]
    echo                     -ka [Kubernetes Apply File]
    echo   -C              Clear Container
    echo                   Compatible Options%COLON%
    echo                   Required Fields%COLON%
    echo                     -an [Application Name]
    echo                     -av [Application Version]
    echo                     -ns [NCloud Private Container Registry Name]
    echo                     -kn [Kubernetes Cluster Name]
    echo                     -kc [Kubernetes Cluster Config File]
    echo                     -ka [Kubernetes Apply File]
    echo.
    echo Examples%COLON%
    echo   -GBU%COLON% sdocker -BDU %CARET%
    echo         -an app-name %CARET%
    echo         -av 1.0.0 %CARET%
    echo         -ab gradle %CARET%
    echo         -ap %DEFAULT_ROOT_DIR%\app-name %CARET%
    echo         -dt %DEFAULT_TARGET_REGISTRY_ENDPOINT% %CARET%
    echo         -dc %DEFAULT_DOCKER_COMPOSE_FILE%
    echo   -GBP%COLON% sdocker -GBP %CARET%
    echo         -an app-name %CARET%
    echo         -av 1.0.0 %CARET%
    echo         -ab gradle %CARET%
    echo         -ap %DEFAULT_ROOT_DIR%\app-name %CARET%
    echo         -dt %DEFAULT_TARGET_REGISTRY_ENDPOINT% %CARET%
    echo         -dc %DEFAULT_DOCKER_COMPOSE_FILE%
    echo   -SA%COLON% sdocker -SA %CARET%
    echo         -an app-name %CARET%
    echo         -av 1.0.0 %CARET%
    echo         -do %DEFAULT_ORIGIN_REGISTRY_ENDPOINT% %CARET%
    echo         -np [NCR Public Name].kr.ncr.ntruss.com %CARET%
    echo         -ns [NCR Private Name].kr.private-ncr.ntruss.com %CARET%
    echo         -kn cluster-name %CARET%
    echo         -kc %DEFAULT_ROOT_DIR%\cluster-name\%DEFAULT_KUBE_CONFIG_FILE% %CARET%
    echo         -ka %DEFAULT_ROOT_DIR%\cluster-name\app-name\%DEFAULT_KUBE_APPLY_FILE%
    goto success

:try
    echo sdocker%COLON% try 'sdocker -h' for more information
    goto fail

:success
    set "EXIT_CODE=0"
    goto end

:fail
    set "EXIT_CODE=1"
    goto end

:end
    endlocal
    exit /b !EXIT_CODE!
