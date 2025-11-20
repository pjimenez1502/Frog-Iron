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

signal UpdateCameraRotation

## Player UI Update
signal PlayerXPUpdate
signal PlayerHPUpdate
signal PlayerCoinUpdate
signal PlayerStatsUpdate

signal ItemUsed

## EmergentInv
signal OpenEmergentInv
signal CloseEmergentInv
signal UpdateEmergentInv


##Game Signals
signal PlayerTurn
signal EnemyTurn

signal LaunchDemoScene
signal LaunchDungeonScene
signal NavmeshBakeRequest

signal ShowPopupText
signal ShowTooltip

signal DamageText

signal PauseGame
signal TimeScaleChange
