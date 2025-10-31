extends Node

## Player Signals
signal AddPlayerXP
signal AddPlayerCoin
signal AddPlayerItem
signal PlayerInventoryUpdate
signal PlayerStatIncrease
signal AvailableStatUP
signal PlayerDead

## Player UI Update
signal PlayerXPUpdate
signal PlayerHPUpdate
signal PlayerCoinUpdate
signal PlayerStatsUpdate

signal ItemUsed

signal OpenEmergentInv
signal CloseEmergentInv
signal UpdateEmergentInv

#Game Signals
signal LaunchDemoScene
signal NavmeshBakeRequest

signal ShowPopupText
signal PauseGame
signal TimeScaleChange
