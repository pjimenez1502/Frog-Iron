extends Node

## Player Signals
signal AddPlayerXP
signal AddPlayerCoin
signal AddPlayerItem
signal PlayerInventoryUpdate
signal PlayerEquipmentUpdate
signal PlayerStatIncrease
signal AvailableStatUP

signal PlayerDead
signal PlayerMoved

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

signal MapUpdate

##Game Signals
signal TurnEnded
signal EnemyTurn

signal LaunchDemoScene
signal LaunchDungeonScene
signal NavmeshBakeRequest

signal ShowPopupText
signal ShowTooltip

signal DamageText

signal PauseGame
signal TimeScaleChange
