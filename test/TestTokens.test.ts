import {expect, describe, it} from 'vitest';
import {loadFixture} from '@nomicfoundation/hardhat-network-helpers';
import {getConnection, fetchContract} from '../utils/connection';
import artifacts from '../generated/artifacts';
import { parseEther } from 'viem';

async function deployTestTokens() {
	const {accounts, walletClient, publicClient} = await getConnection();
	const [deployer, ...otherAccounts] = accounts;

	const deploymentHash = await walletClient.deployContract({
		...artifacts.TestTokens,
		account: deployer,
		args: [deployer, parseEther("10")]
	});

	const receipt = await publicClient.getTransactionReceipt({hash: deploymentHash});
	const TestTokens = await fetchContract({
		...artifacts.TestTokens,
		address: receipt.contractAddress as `0x${string}`,
	});

	return {
		TestTokens,
		deployer,
		otherAccounts,
	};
}

describe('TestTokens', function () {
	it('TestTokens', async function () {
		const {TestTokens} = await loadFixture(deployTestTokens);
		const decimals = await TestTokens.read.decimals();
		expect(decimals).to.equal(18);
	});

	
});
