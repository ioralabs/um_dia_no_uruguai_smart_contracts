const { expect } = require("chai");

describe("Barbearia Contract", function () {
    let Barbearia, barbearia;
    let owner, account1, account2;
    let mockERC20;

    beforeEach(async () => {
        [owner, account1, account2] = await ethers.getSigners();

        const MockERC20 = await ethers.getContractFactory("DREX");
        mockERC20 = await MockERC20.deploy();

        Barbearia = await ethers.getContractFactory("Barbershop");
        barbearia = await Barbearia.deploy();

        await mockERC20.mint(owner.address, 5000);
        await mockERC20.transfer(account1.address, 1000);
    });

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            expect(await barbearia.dono()).to.equal(owner.address);
        });
    });

    describe("Servico Functions", function () {
        it("Should add a new service", async () => {
            await barbearia.connect(owner).adicionarServico("Corte de Cabelo", 30);
            const servico = await barbearia.servicos(1);
            expect(servico.nomeServico).to.equal("Corte de Cabelo");
            expect(servico.preco).to.equal(30);
        });

        it("Should perform a service and pay with ERC20", async () => {
            await barbearia.connect(owner).adicionarServico("Corte de Cabelo", 30);

            await mockERC20.connect(account1).approve(barbearia.target, 30);

            await expect(barbearia.connect(account1).realizarServico(1, await mockERC20.target))
                .to.emit(barbearia, "ServicoRealizado")
                .withArgs(1, account1.address, "Corte de Cabelo");

            const servico = await barbearia.servicos(1);
            expect(servico.realizado).to.equal(true);
        });
    });
});
