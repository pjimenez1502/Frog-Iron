extends Node

## Player Signals
signal SetStartPlayerData
signal UpdatePlayerData

signal AddPlayerXP
signal AddPlayerCoin
#signal AddPlayerItem
signal PlayerInventoryUpdate
signal PlayerEquipmentUpdate
#signal PlayerAmmoUpdate
#signal PlayerInventoryDrop
signal PlayerStatIncrease
signal AvailableStatUP
signal PlayerLevelUpdate
signal PlayerWeaponUpdate

signal PlayerDead
signal UpdatePlayerVision

signal UpdateCameraRotation

## Player UI Update
signal PlayerXPUpdate
signal PlayerHPUpdate
signal PlayerStaminaUpdate
signal PlayerSanityUpdate
signal PlayerCoinUpdate
signal PlayerStatsUpdate

signal CursorUpdate

signal CharacterTooltipShow

## Item Actions
signal ItemTake
signal ItemDrop
signal ItemEquip
signal ItemUnequip
signal ItemConsume

## EmergentInv
signal OpenEmergentInv
signal CloseEmergentInv
signal UpdateEmergentInv

signal DropItemBundle

signal MapUpdate
signal VisionBlockUpdate
signal EntityMapPointUpdate

##Game Signals
signal TurnEnded
signal EnemyTurn

signal LaunchDemoScene
signal LaunchDungeonScene
signal LaunchCharCreationScene
signal NavmeshBakeRequest

signal ShowPopupText
signal ShowTooltip
signal TooltipAction

signal DamageText

signal ViewFocusChange

signal PauseGame
signal TimeScaleChange
