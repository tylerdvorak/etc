# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ 
        #link to other system specific flakes
        #../../wm/   
        # Include the results of the hardware scan.
        ./hardware-configuration.nix
    ];
  #Kernel Parameters
  boot.kernelParams = ["nvidia_drm.modeset=1"]; # To use Nvidia

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set Hostname
  networking.hostName = "tonberry";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.interfaces.eth0.ipv4.addresses = [ {
    address = "192.168.1.15";
    prefixLength = 24;
    } ];
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers =  "192.168.1.1" ;
  boot.kernel.sysctl."net.ipv6.conf.eth0.disable_ipv6" = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Map Network Drives
  fileSystems."/Ark" = {
    device = "192.168.1.200:/mnt/array1/ark";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" "x-systemd.after=network-online.target" "x-systemd.mount-timeout=90" ];
  };

  fileSystems."/Susanoo" = {
    device = "192.168.1.200:/mnt/array1/susanoo";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" "x-systemd.after=network-online.target" "x-systemd.mount-timeout=90" ];
  };

  # Make sure opengl is enabled
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # NVIDIA drivers are unfree.
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
    ];

  # Nvidia GPU
  services.xserver.videoDrivers = ["nvidia"];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    forceFullCompositionPipeline = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.stateVersion = "23.05"; # Did you read the comment?

}
