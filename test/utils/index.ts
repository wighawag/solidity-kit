import {artifacts} from '#rocketh';
import {parseEther} from 'viem';
import {fetchContract, getConnection} from '../../utils/connection';

export async function setupFixtures() {
	const {accounts, walletClient, publicClient, networkHelpers} = await getConnection();

	return {
		networkHelpers,
		async deployTestTokens() {
			const [deployer, ...otherAccounts] = accounts;

			const deploymentHash = await walletClient.deployContract({
				...artifacts.TestTokens,
				account: deployer,
				args: [deployer, parseEther('10')],
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
		},
	};
}
