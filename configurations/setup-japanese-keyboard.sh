sudo pacman -Sy --needed fcitx5-im fcitx5-configtool fcitx5-gtk fcitx5-qt fcitx5-mozc

ENV_FILE="/etc/environment"

echo "Setting environment variables in $ENV_FILE"
{
  echo "GTK_IM_MODULE=fcitx"
  echo "QT_IM_MODULE=fcitx"
  echo "XMODIFIERS=@im=fcitx"
  echo "SDL_IM_MODULE=fcitx"
  echo "GLFW_IM_MODULE=ibus"
} | sudo tee -a $ENV_FILE

echo "Installation complete. It's recommended to reboot your system to apply the changes."
echo "Would you like to reboot now? (y/n)"
read -r REBOOT

if [[ $REBOOT =~ ^[Yy]$ ]]; then
  sudo reboot
else
  echo "Please remember to reboot your system later to apply the changes."
fi

echo "After rebooting, follow these steps to add the Mozc input method in System Settings:"
echo "1. Open System Settings."
echo "2. Navigate to Regional Settings > Input Method."
echo "3. Click on Add Input Method."
echo "4. Select Mozc from the list and add it."
echo "Ensure fcitx5 is running. If not, you can start it manually by running 'fcitx5 &'"
