# ========= CONFIGURABLE =========
$SourceDir = "source"
$BuildDir = "build"
$InstallDir = "install"

# ========= TOOL DETECTION & INSTALL =========
function Install-Packages {
    Write-Host "Installing required packages..."
    
    $REQUIRED_PACKAGES = @("git", "gcc", "g++", "make", "autotools", "bison", "flex")
    
    if ($env:MSYSTEM -and $env:MSYSTEM -match "MINGW") {
        Write-Host "Detected MSYS2"
        foreach ($pkg in $REQUIRED_PACKAGES) {
            $mingwPkg = "mingw-w64-x86_64-$pkg"
            pacman -Sy --noconfirm $mingwPkg 2>$null
            if ($LASTEXITCODE -ne 0) {
                pacman -Sy --noconfirm $pkg 2>$null
            }
        }
    }
    elseif (Get-Command apt -ErrorAction SilentlyContinue) {
        Write-Host "Detected Debian/Ubuntu"
        sudo apt update
        sudo apt install -y $REQUIRED_PACKAGES
    }
    elseif (Get-Command dnf -ErrorAction SilentlyContinue) {
        Write-Host "Detected Fedora"
        sudo dnf install -y $REQUIRED_PACKAGES
    }
    elseif (Get-Command yum -ErrorAction SilentlyContinue) {
        Write-Host "Detected RHEL/CentOS"
        sudo yum install -y $REQUIRED_PACKAGES
    }
    elseif (Get-Command zypper -ErrorAction SilentlyContinue) {
        Write-Host "Detected openSUSE"
        sudo zypper install -y $REQUIRED_PACKAGES
    }
    elseif (Get-Command a-g -ErrorAction SilentlyContinue) {
        Write-Host "Detected a-g"
        foreach ($pkg in $REQUIRED_PACKAGES) {
            echo y | a-g install "a-g-install-${pkg}-using-source"
            echo y | a-g-install-${pkg}-using-source
        }
    }
    else {
        Write-Host "Could not detect package manager. Please install manually: $($REQUIRED_PACKAGES -join ', ')"
        exit 1
    }
}

function Check-And-Install {
    $tools = @("git", "gcc", "g++", "make", "autoconf", "automake", "bison", "flex")
    $missing = @()
    
    foreach ($tool in $tools) {
        if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
            $missing += $tool
        }
    }
    
    if ($missing.Count -gt 0) {
        Write-Host "Missing tools: $($missing -join ', ')"
        Install-Packages
    }
}

# ========= BUILD FUNCTIONS =========
function Create-BuildDir {
    if (-not (Test-Path -Path $BuildDir)) {
        New-Item -ItemType Directory -Path $BuildDir | Out-Null
    }
}

function Compile-Sources {
    Write-Host "Compiling sources..."
    
    Push-Location $BuildDir
    try {
        # Run configure with LDFLAGS
        & sh -c "../configure LDFLAGS=-lmingw32_extended"
        
        if ($LASTEXITCODE -ne 0) {
            Write-Error "configure script failed"
            exit 2
        }
        
        # Run make
        & "make"
        
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Build failed"
            exit 3
        }
    }
    finally {
        Pop-Location
    }
}

function Run-Tests {
    Write-Host "Running compiled tests..."
    Push-Location $BuildDir
    try {
        & "make" "test"
        if ($LASTEXITCODE -ne 0) {
            Write-Error "Tests failed"
            exit 4
        }
    }
    finally {
        Pop-Location
    }
}

function Print-Info {
    Write-Host "=============================="
    Write-Host "  msg-sdk-cpp PowerShell Build"
    Write-Host "=============================="
    Write-Host "Source Directory:  $SourceDir"
    Write-Host "Build Directory:   $BuildDir"
    Write-Host "Install Directory: $InstallDir"
    Write-Host ""
}

# ========= MAIN =========
Print-Info
Check-And-Install
Create-BuildDir
Compile-Sources
Run-Tests

Write-Host "Build and test complete!"