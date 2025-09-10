import {artifacts, loadEnvironmentFromHardhat} from '#rocketh';
import {parseEther} from 'viem';
import {NetworkConnection} from 'hardhat/types/network';
import hre from 'hardhat';

export function setupFixtures(connection: NetworkConnection) {
	return {
		async deployTestTokens() {
			const env = await loadEnvironmentFromHardhat({hre, connection});

			const walletClient = env.viem.walletClient;
			const [deployer, ...otherAccounts] = (await walletClient.getAddresses()).map(
				// TODO fix it in rocketh ?
				(v) => v.toLowerCase() as `0x${string}`,
			);

			const TestTokensDeployment = await env.deploy('TestTokens', {
				artifact: artifacts.TestTokens,
				account: deployer,
				args: [deployer, parseEther('10')],
			});

			const TestTokens = await env.viem.getWritableContract(TestTokensDeployment);

			return {
				TestTokens,
				deployer,
				otherAccounts,
			};
		},
	};
}
