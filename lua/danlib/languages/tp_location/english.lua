/***
 *   @addon         LFS Travel System
 *   @version       2.0.0
 *   @release_date  11/10/2022
 *   @authors       denchik, Kotyarishka
 *
 *   @contacts      denchik:
 *                  - Discord: denchik_gm
 *                  - Steam: [Profile](https://steamcommunity.com/profiles/76561198405398290/)
 *                  - GitHub: [Profile](https://github.com/denchik5133)
 *
 *                  Kotyarishka:
 *                  - Discord: kotyarishka
 *                  - Steam: [Profile](https://steamcommunity.com/id/kotyarishka/)
 *                  - GitHub: [Profile](https://github.com/Kotyarishka)
 *                
 *   @description   What can be better for comfortable wagering rp on the server? This system gives you the opportunity
 *                  to qualitatively play your role and will give you the opportunity to move between locations on the map without much effort.
 *                  
 *   @usage         !danlibmenu (chat) | danlibmenu (console)
 *   @license       MIT License
 *   @notes         For feature requests or contributions, please open an issue on GitHub.
 */



local ENGLISH = {
    -- TOOL & GENERAL
    ['#first.point'] = '- Set the first point',
    ['#clear.selection'] = '- Clear the selection',
    ['#increase.range'] = '- Increase range',
    ['#teleporting'] = 'Teleporting...',
    ['#hyperspace_travel'] = 'HYPERSPACE TRAVEL',
    ['#portal_transit'] = 'PORTAL TRANSIT',
    ['#hologram_transfer'] = 'HOLOGRAPHIC TRANSFER IN PROGRESS',
    
    -- ERROR MESSAGES
    ['#no.table'] = 'Table not found.',
    ['#not.relocation'] = 'RELOCATION UNAVAILABLE',
    ['#same.planet'] = "You're trying to go to the same planet!",
    ['#not.found'] = 'Exit point not found, contact the administration!',
    ['#not.vector'] = 'Something has gone wrong. Contact the developer. Error: ',
    ['#not.vector2'] = 'No Vectors Set',
    ['#no.id'] = 'ERROR: ID is required',
    ['#no.name'] = 'ERROR: Name is required',
    ['#no.model'] = 'ERROR: Model is required',
    ['#no.boundA'] = 'ERROR: First boundary point is required',
    ['#no.boundB'] = 'ERROR: Second boundary point is required',
    ['#invalid.model.format'] = 'ERROR: Invalid model format. Model must start with "models/" and end with ".mdl"',
    ['#zero.volume'] = 'ERROR: Location volume cannot be zero',
    ['#volume.too.large'] = 'ERROR: Location volume is too large',
    ['#not.in.vehicle'] = 'You need to be in a vehicle to use teleportation!',
    ['#cooldown.active'] = 'You must wait {time} seconds before teleporting again!',
    ['#exit.blocked'] = 'Exit point is blocked by another vehicle. Try again later!',
    ['#exit.crowded'] = 'Too many players at the destination. Try again later!',
    ['#effect.error'] = 'EFFECT ERROR',
    ['#effect.not.found'] = 'Effect "{name}" not found',
    ['#effect.not.allowed'] = 'Selected effect is not allowed in this gamemode',
    ['#entered.teleport.zone'] = 'You have entered the {zone} teleport zone',
    ['#f3.effects.tip'] = 'Press F3 to select teleport effects',

    -- GAMEMODE-SPECIFIC MESSAGES
    ['#not.enough.money'] = 'You need {cost} to teleport!',
    ['#teleport.cost'] = 'TELEPORT COST',
    ['#paid.for.teleport'] = 'You paid {cost} for teleportation',
    ['#job.not.allowed'] = 'Your job ({job}) is not allowed to use teleporters',
    ['#job.restricted'] = 'Teleporters are restricted for your job ({job})',
    ['#need.business.license'] = 'You need a business license to use teleporters',
    ['#disabled.during.round'] = 'Teleporters are disabled during active rounds',
    ['#traitors.cannot.teleport'] = 'Traitors cannot use teleporters',
    ['#innocents.cannot.teleport'] = 'Innocents cannot use teleporters',
    ['#detectives.cannot.teleport'] = 'Detectives cannot use teleporters',
    ['#teleport.alert'] = 'TELEPORT ALERT',
    ['#traitor.teleported'] = 'Traitor {player} used a teleporter!',
    ['#detective.teleported'] = 'Detective {player} used a teleporter',
    ['#player.teleported'] = 'Player {player} used a teleporter',
    ['#no.hyperdrive'] = 'Your ship does not have a hyperdrive installed',
    ['#hyperdrive.charging'] = 'Hyperdrive is charging... ({charge}%)',
    ['#imperial.controlled'] = 'This planet is under Imperial control',
    ['#rebel.controlled'] = 'This planet is under Rebel control',
    ['#hyperdrive.alert'] = 'HYPERDRIVE ALERT',
    ['#hyperdrive.ready'] = 'Hyperdrive charged and ready for jump',
    ['#unsc.controlled'] = 'This area is under UNSC control',
    ['#covenant.controlled'] = 'This area is under Covenant control',
    ['#pilot.required'] = 'Only pilots can operate teleporters',
    ['#teleport.entities'] = 'ENTITY TELEPORT',
    ['#teleporting.entities'] = 'Teleporting {count} entities with you',

    -- LOCATION MANAGEMENT
    ['#added.location'] = 'Location has been successfully added!',
    ['#remove.location'] = 'The location has been successfully deleted!',
    ['#planets.list'] = 'List of Destinations',
    ['#F3.select'] = 'Press F3 to select effects',
    ['#no.name'] = 'No Name',
    ['#you.here'] = 'You Are Here!',
    ['#on.way'] = 'Travel Here',

    -- FILE SYSTEM
    ['#teleports.file.loaded'] = 'The teleports are loaded!',
    ['#error.file.loaded'] = 'Error in reading the teleports file.',
    ['#created.file'] = 'The teleports file has been created.',

    -- ADMIN INTERFACE
    ['#d.model'] = 'Model',
    ['#d.name'] = 'Name',
    ['#d.removal'] = 'REMOVAL',
    ['#d.delete.location'] = 'Do you really want to delete Location ID #{id}?',
    ['#d.confirm.delete'] = 'The location with ID #{id} has been deleted!',
    ['#move.camera'] = '{keys}: Move Camera',
    ['#rotate.camera'] = 'RIGHT-CLICK: Rotate Camera',

    -- LOCATION CREATION
    ['#are.required'] = 'Items marked with (*) are required!',
    ['#id.planet'] = '* Planet ID (Must be unique!)',
    ['#name.planet'] = '* The name of the planet...',
    ['#model.planet'] = '* Path to the model...',
    ['#enter.id'] = 'Enter the location ID!',
    ['#enter.name'] = 'Enter the name of the location!',
    ['#enter.model'] = 'The path to the model was not specified!',
    ['#invalid.model'] = 'Invalid model!',
    ['#enter.valid.model'] = 'Please enter the correct path to the model.\n\nMake sure that:\n- The model exists in the game\n- The addon with the model is installed and loaded\n- The path must start with "models/"\n- The path must end with ".mdl"',

    -- TUTORIAL SYSTEM
    ['#tutorial.intro.title'] = 'Welcome to Teleport System',
    ['#tutorial.intro.desc'] = 'This tutorial will guide you through using the LFS Travel System. This system allows players to teleport between different locations on the map, perfect for space travel or long-distance role-playing scenarios.\n\nUse the navigation buttons below to move through the tutorial steps.',
    
    ['#tutorial.admin.title'] = 'Admin Access',
    ['#tutorial.admin.desc'] = 'To access the admin features, you need appropriate permissions. The admin menu allows you to create, edit, and delete teleport locations.\n\nYou can open the admin menu using the console command or chat command shown below.',
    ['#tutorial.admin.chat_command'] = 'Open admin menu in chat',
    ['#tutorial.admin.console_command'] = 'Open admin menu in console',
    
    ['#tutorial.create.title'] = 'Creating Locations',
    ['#tutorial.create.desc'] = 'To create a teleport location, you need to define a 3D area in the world. This area will serve as the teleport zone.\n\n1. Open the admin menu\n2. Click "Add Location"\n3. Set two points in the world to define the teleport zone boundaries\n4. Enter a unique ID, name, and model path for the location',
    ['#tutorial.create.guide'] = 'Click this button to create a new location',
    
    ['#tutorial.edit.title'] = 'Editing Locations',
    ['#tutorial.edit.desc'] = 'You can edit existing locations to change their properties:\n\n1. Select a location from the list\n2. Click "Edit Location"\n3. Modify the name, model, or other properties\n4. Save your changes',
    ['#tutorial.edit.guide'] = 'Right-click on a location to edit it',
    
    ['#tutorial.delete.title'] = 'Deleting Locations',
    ['#tutorial.delete.desc'] = 'To remove a teleport location:\n\n1. Select a location from the list\n2. Click "Delete Location"\n3. Confirm the deletion\n\nWarning: Deletion cannot be undone!',
    
    ['#tutorial.usage.title'] = 'Using the System',
    ['#tutorial.usage.desc'] = 'Players can use the teleport system when they are in a vehicle and enter a teleport zone. A menu will appear showing available destinations.\n\n1. Drive or fly into a teleport zone\n2. Select a destination from the menu\n3. Click "Travel Here" to teleport',
    ['#tutorial.usage.chat_command'] = 'Open teleport menu in chat',
    ['#tutorial.usage.console_command'] = 'Open teleport menu in console',
    ['#tutorial.usage.guide'] = 'Click on a destination to teleport there',
    
    ['#tutorial.effects.title'] = 'Teleport Effects',
    ['#tutorial.effects.desc'] = 'The system includes several visual effects for teleportation:\n\n- Fade: Simple fade to black\n- Hyperspace: Star Wars-style hyperspace jump\n- Portal: Portal-style teleportation\n- Hologram: Holographic teleportation\n\nPlayers can select their preferred effect by clicking the "Effects" button in the teleport menu.',
    ['#tutorial.effects.guide'] = 'Click this button to preview and select effects',
    
    ['#tutorial.conclusion.title'] = 'Conclusion',
    ['#tutorial.conclusion.desc'] = 'You\'ve now learned how to use the LFS Travel System! Remember:\n\n- Admins can create and manage teleport locations\n- Players can teleport between locations when in a vehicle\n- Different visual effects are available\n\nIf you need more help, you can restart this tutorial at any time using the !tl_tutorial command.',

    -- LOGS
    ['#log.create.location'] = 'Player **%s** [*%s*] ([Profile](https://steamcommunity.com/profiles/%s/)) has created a new location.',
    ['#log.delete.location'] = 'Player **%s** [*%s*] ([Profile](https://steamcommunity.com/profiles/%s/)) deleted location ID #**%s**.',
    ['#log.edit.location'] = 'Player **%s** [*%s*] ([Profile](https://steamcommunity.com/profiles/%s/)) changed the config.',
    
    -- STATUS MESSAGES
    ['info'] = 'INFO',
    ['warning'] = 'WARNING',
    ['error'] = 'ERROR',
    ['confirm'] = 'CONFIRM',
    ['cancel'] = 'CANCEL',
    ['admin'] = 'ADMIN',




    ["#teleporting"] = "Teleporting",
    ["#teleport.request"] = "Teleport Request",
    ["#teleport.successful"] = "Teleportation successful",
    ["#teleport.failed"] = "Teleportation failed",
    ["#teleport.canceled"] = "Teleportation canceled",
    ["#teleport.cooldown"] = "Teleportation cooldown",
    ["#teleport.cost"] = "Teleportation Cost",
    ["#teleport.alert"] = "Teleport Alert",

-- Error messages
    ["#not.relocation"] = "Location Error",
    ["#not.found"] = "Location not found",
    ["#not.in.vehicle"] = "You must be in a vehicle",
    ["#not.vector2"] = "Invalid location bounds",
    ["#exit.blocked"] = "Destination is blocked by a vehicle",
    ["#exit.crowded"] = "Destination is too crowded",
    ["#no.id"] = "No ID provided",
    ["#no.name"] = "No name provided",
    ["#no.model"] = "No model provided",
    ["#no.boundA"] = "No first bound provided",
    ["#no.boundB"] = "No second bound provided",
    ["#invalid.model.format"] = "Invalid model format",
    ["#zero.volume"] = "Location has zero volume",
    ["#volume.too.large"] = "Location volume is too large",
    ["#not.enough.money"] = "You don't have enough money ({cost})",
    ["#paid.for.teleport"] = "You paid {cost} for teleportation",

-- Effect messages
    ["#effect.not.allowed"] = "This effect is not allowed in the current gamemode",
    ["#effect.not.found"] = "Effect {name} not found",
    ["#effect.error"] = "Effect Error",
    ["#hyperspace_travel"] = "Hyperspace Travel",
    ["#portal_transit"] = "Portal Transit",
    ["#hologram_transfer"] = "Hologram Transfer",

-- Cooldown messages
    ["#cooldown.active"] = "Cooldown active: {time} seconds remaining",
    ["#hyperdrive.alert"] = "Hyperdrive Alert",
    ["#hyperdrive.charging"] = "Hyperdrive charging: {charge}%",

-- File messages
    ["#created.file"] = "Created location data file",
    ["#error.file.loaded"] = "Error loading location data file",
    ["#teleports.file.loaded"] = "Teleport locations loaded",
    ["#added.location"] = "Added new location",

-- Gamemode-specific messages
    ["#disabled.during.round"] = "Teleportation is disabled during an active round",
    ["#traitors.cannot.teleport"] = "Traitors cannot use teleportation",
    ["#detectives.cannot.teleport"] = "Detectives cannot use teleportation",
    ["#innocents.cannot.teleport"] = "Innocents cannot use teleportation",
    ["#traitor.teleported"] = "A traitor ({player}) used teleportation",
    ["#imperial.controlled"] = "This planet is under Imperial control",
    ["#rebel.controlled"] = "This planet is under Rebel control",

-- Admin panel
    ["#admin.title"] = "Teleport System Administration",
    ["#admin.locations"] = "Locations",
    ["#admin.users"] = "Users",
    ["#admin.settings"] = "Settings",
    ["#admin.tools"] = "Tools",
    ["#admin.add"] = "Add Location",
    ["#admin.edit"] = "Edit Location",
    ["#admin.remove"] = "Remove Location",
    ["#admin.save"] = "Save Changes",
    ["#admin.cancel"] = "Cancel",
    ["#admin.id"] = "Location ID",
    ["#admin.name"] = "Location Name",
    ["#admin.model"] = "Model Path",
    ["#admin.bounds"] = "Location Bounds",
    ["#admin.confirm.delete"] = "Are you sure you want to delete this location?",
    ["#admin.gamemode"] = "Gamemode Configuration",
    ["#admin.effects"] = "Effects Configuration",

-- Tutorial
    ["#tutorial.title"] = "Teleport System Tutorial",
    ["#tutorial.next"] = "Next",
    ["#tutorial.prev"] = "Previous",
    ["#tutorial.finish"] = "Finish",
    ["#tutorial.step1.title"] = "Introduction",
    ["#tutorial.step1.desc"] = "Welcome to the Teleport System tutorial. This system allows you to teleport between different locations on the map.",
    ["#tutorial.step2.title"] = "Admin Access",
    ["#tutorial.step2.desc"] = "Administrators can create, edit and delete teleport locations using the admin panel. Type !tl_admin in chat to open it.",
    ["#tutorial.step3.title"] = "Creating Locations",
    ["#tutorial.step3.desc"] = "To create a new location, go to the Locations tab in the admin panel and click 'Add Location'.",
    ["#tutorial.step4.title"] = "Using the System",
    ["#tutorial.step4.desc"] = "Players can use the teleport system by typing !tl in chat. This will open the teleport menu.",
    ["#tutorial.step5.title"] = "Teleport Effects",
    ["#tutorial.step5.desc"] = "The system includes various visual effects for teleportation. You can choose your preferred effect in the teleport menu.",
}

DanLib.Func.RegisterLanguage('English', ENGLISH)