import {
	Abi,
	CustomTransport,
	PublicClient,
	WalletClient,
	createPublicClient,
	createWalletClient,
	custom,
	getContract,
} from 'viem';

import hre from 'hardhat';
import type {EIP1193ProviderWithoutEvents} from 'eip-1193';
import {Chain} from 'viem';
import {loadEnvironmentFromHardhat} from '#rocketh';
import {getHardhatConnection} from 'hardhat-deploy';
import {EthereumProvider} from 'hardhat/types/providers';
import {NetworkHelpers} from '@nomicfoundation/hardhat-network-helpers/types';

export type Connection = {
	walletClient: WalletClient<CustomTransport, Chain>;
	publicClient: PublicClient<CustomTransport, Chain>;
	accounts: `0x${string}`[];
	provider: EIP1193ProviderWithoutEvents;
	networkHelpers: NetworkHelpers;
};

const cache: {connection?: Connection} = {};
export async function getConnection(): Promise<Connection> {
	if (cache.connection) {
		return cache.connection;
	}
	const env = await loadEnvironmentFromHardhat({hre});

	const walletClient = createWalletClient({
		chain: env.network.chain,
		transport: custom(env.network.provider),
	});
	const publicClient = createPublicClient({
		chain: env.network.chain,
		transport: custom(env.network.provider),
	});
	return (cache.connection = {
		walletClient,
		publicClient,
		accounts: await walletClient.getAddresses(),
		provider: env.network.provider,
		networkHelpers: getHardhatConnection(env).networkHelpers,
	});
}

export async function fetchContract<TAbi extends Abi>(contractInfo: {address: `0x${string}`; abi: TAbi}) {
	const {walletClient, publicClient} = await getConnection();
	return getContract({
		...contractInfo,
		client: {wallet: walletClient, public: publicClient},
	});
}

export type ContractWithViemClient<TAbi extends Abi> = Awaited<ReturnType<typeof fetchContract<TAbi>>>;
