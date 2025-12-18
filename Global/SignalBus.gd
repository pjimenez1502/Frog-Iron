extends Node

## Player Signals
signal SetStartPlayerData

signal AddPlayerXP
signal AddPlayerCoin
signal AddPlayerItem
signal PlayerInventoryUpdate
signal PlayerEquipmentUpdate
signal PlayerInventoryDrop
signal PlayerStatIncrease
signal AvailableStatUP

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

signal ItemUsed

## EmergentInv
signal OpenEmergentInv
signal CloseEmergentInv
signal UpdateEmergentInv

signal DropItemBundle

signal MapUpdate
signal VisionBlockUpdate

##Game Signals
signal TurnEnded
signal EnemyTurn

signal LaunchDemoScene
signal LaunchDungeonScene
signal LaunchCharCreationScene
signal NavmeshBakeRequest

signal ShowPopupText
signal ShowTooltip

signal DamageText

signal ViewFocusChange

signal PauseGame
signal TimeScaleChange
