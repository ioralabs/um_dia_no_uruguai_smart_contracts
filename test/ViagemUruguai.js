// test/ViagemUruguai.js
const { expect } = require("chai");

describe("ViagemAoUruguai Contract", function () {
    let ViagemAoUruguai, viagem;
    let owner, account1, account2;

    beforeEach(async () => {
        [owner, account1, account2] = await ethers.getSigners();
        ViagemAoUruguai = await ethers.getContractFactory("ViagemAoUruguai");
        viagem = await ViagemAoUruguai.deploy();
    });

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            expect(await viagem.dono()).to.equal(owner.address);
        });
    });

    describe("Passagem Functions", function () {
        it("Should emit PassagemEmitida event", async () => {
            await expect(viagem.connect(owner).emitirPassagem(account1.address, "John"))
                .to.emit(viagem, "PassagemEmitida")
                .withArgs(1, account1.address, "John");
        });

        it("Should do checkin", async () => {
            await viagem.connect(owner).emitirPassagem(account1.address, "John");
            await expect(viagem.connect(account1).fazerCheckin(1))
                .to.emit(viagem, "CheckinRealizado")
                .withArgs(1);
        });

        it("Should transfer passagem", async () => {
            await viagem.connect(owner).emitirPassagem(account1.address, "John");
            await expect(viagem.connect(account1).transferirPassagem(1, account2.address))
                .to.emit(viagem, "PassagemTransferida")
                .withArgs(1, account2.address);
        });
    });
});
