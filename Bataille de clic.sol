// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ClickCounterGame {
    address public owner;
    mapping(address => uint256) public playerClicks;
    address[] public topPlayers;

    event PlayerClicked(address player, uint256 totalClicks);
    event TopPlayersUpdated(address[] topPlayers);

    constructor() {
        owner = msg.sender;
    }

    // Fonction pour que les joueurs cliquent et enregistrent un clic
    function click() external {
        playerClicks[msg.sender] += 1;
        emit PlayerClicked(msg.sender, playerClicks[msg.sender]);
        updateTopPlayers(msg.sender);
    }

    // Fonction pour voir le nombre total de clics d'un joueur
    function getPlayerClicks(address player) external view returns (uint256) {
        return playerClicks[player];
    }

    // Fonction pour voir les meilleurs joueurs (top 5 par exemple)
    function getTopPlayers() external view returns (address[] memory) {
        return topPlayers;
    }

    // Fonction interne pour mettre à jour le classement des meilleurs joueurs
    function updateTopPlayers(address player) internal {
        // Si le joueur est déjà dans le top, mettre à jour son score
        bool playerUpdated = false;
        for (uint256 i = 0; i < topPlayers.length; i++) {
            if (topPlayers[i] == player) {
                playerUpdated = true;
                break;
            }
        }

        // Si le joueur n'est pas déjà dans le top, il faut l'ajouter
        if (!playerUpdated) {
            topPlayers.push(player);
        }

        // Trie les joueurs par nombre de clics en utilisant un simple algorithme de tri
        uint256 len = topPlayers.length;
        for (uint256 i = 0; i < len; i++) {
            for (uint256 j = i + 1; j < len; j++) {
                if (playerClicks[topPlayers[i]] < playerClicks[topPlayers[j]]) {
                    address temp = topPlayers[i];
                    topPlayers[i] = topPlayers[j];
                    topPlayers[j] = temp;
                }
            }
        }

        // Limiter à 5 meilleurs joueurs (peut être ajusté)
        if (topPlayers.length > 5) {
            topPlayers.pop();
        }

        emit TopPlayersUpdated(topPlayers);
    }

    // Permet au propriétaire de retirer des fonds (en cas de besoin)
    function withdraw() external {
        require(msg.sender == owner, "Only the owner can withdraw.");
        payable(owner).transfer(address(this).balance);
    }
}
