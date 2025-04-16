# LFS Travel System

## Overview
LFS Travel System is a powerful Garry's Mod addon designed for servers utilizing the Lunar Flight Simulator (LFS) vehicles. This system enables seamless travel between defined locations on your map, enhancing roleplay experiences by allowing players to navigate efficiently between different areas in LFS vehicles.

## ⚠️ Attention: The system is under development!
Please note that the LFS Travel System is under development with an updated DanLib library. Some functions may not be available or may not work correctly.

**Version:** 3.0.0

**Authors:**
- denchik ([Discord](https://discord.gg/CND6B5sH3j), [Steam](https://steamcommunity.com/profiles/76561198405398290/), [GitHub](https://github.com/denchik5133))
- Kotyarishka ([Discord](https://discord.gg/kotyarishka), [Steam](https://steamcommunity.com/id/kotyarishka/), [GitHub](https://github.com/Kotyarishka))

## Features
- **Hyperspace Travel System**: Allow players to travel between defined locations in LFS vehicles
- **Admin Configuration Tool**: Easy-to-use tool for creating and managing teleport locations
- **Location Management**: Create, edit, and delete teleport locations with custom names, models and boundaries
- **Permission System**: Control who can use which teleport locations with faction and rank restrictions
- **Cost & Cooldown System**: Set costs (using DarkRP money) and cooldowns for teleport usage
- **Visual Effects**: Customize teleport effects for an immersive experience
- **Debug Mode**: Visualize teleport locations and debug information for administrators

## Installation

### Requirements
- Garry's Mod Server
- [DanLib](https://github.com/denchik5133/DanLib-Base-Library) (dependency)
- [LFS - Lunar Flight Simulator](https://github.com/realpack/LunasFlightSchool) (dependency)

### Setup
1. Download the LFS Travel System from [GitHub](https://github.com/denchik5133/DDI-LFS-Travel)
2. Extract the addon to your server's `addons` folder
3. Make sure DanLib is installed and properly configured
4. Restart your server

## Admin Commands

| Command | Description |
|---------|-------------|
| `!tl_admin` | Open the admin configuration menu in-game |
| `tl_admin_list` (console) | Shows the admin location management interface |
| `tl_list_locations` (console) | Lists all available locations in the console |

## Location Tool Usage

The LFS Travel System includes a special tool for creating teleport locations:

1. Access the tool by typing `!tl_admin` in chat or `tl_admin` in console (requires proper permissions)
2. Equip the "TL Tool" from the weapons menu (admin only)
3. Set location boundaries:
   - Left-click to set the first point
   - Left-click again to set the second point
   - Left-click a third time to open the location creation window
   - Right-click to clear your selection
   - Hold ALT to increase the selection range
4. Configure the location properties:
   - ID: Unique identifier for the location
   - Name: Display name for the location
   - Model: Path to the 3D model representing the location
5. Save the location

## Player Usage

Players with appropriate permissions can use the teleport system:

1. Pilot an LFS vehicle to a teleport location
2. Enter the teleport trigger area (invisible unless in debug mode)
3. The teleport interface will appear with available destinations
4. Select a destination to initiate teleportation
5. If required, the system will deduct money (DarkRP) and apply cooldowns

## Permissions

The system uses the following permission nodes:

| Permission | Description |
|------------|-------------|
| `TLAccessTool` | Access to use the teleport creation tool |
| `TLEditConfig` | Permission to create/edit/delete locations and access the admin menu |
| `TLUseRestrictedLocations` | Permission to use locations marked as restricted |
| `TLBypassCost` | Bypass any teleport costs |
| `TLBypassCooldown` | Bypass teleport cooldowns |

## Configuration
