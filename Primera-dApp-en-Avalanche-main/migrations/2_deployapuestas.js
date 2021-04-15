var Apuestas = artifacts.require("Apuestas");

module.exports = function(deployer) {
    deployer.deploy(Apuestas,"¿Annabelle aparece en un video ochentero?","Si","No");
}