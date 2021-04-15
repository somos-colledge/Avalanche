const Apuestas = artifacts.require("Apuestas");

contract("Apuestas",accounts =>{
    it("Deberia tener apuestas totales de 0", () =>
        Apuestas.deployed()
            .then(instance => instance.total1.call())
            .then(resultado => {
                assert.equal(resultado,0,"Saldo no vacio");
            })
    );
    let meta;
    it("Agregar una apuesta",()=>
            Apuestas.deployed()
                .then(instance => {
                    meta= instance;
                    instance.apostar(1,{from:accounts[1],value:100})
                })
                .then(instance => meta.total1.call())
                .then(resultado => {
                    assert.equal(resultado,100,"Saldo no es 100");
                })
    )
})