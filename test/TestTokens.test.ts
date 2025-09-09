import {expect} from 'earl';
import {describe, it} from 'node:test'; // using node:test as hardhat v3 do not support vitest
import {setupFixtures} from './utils/index.js';

const {deployTestTokens, networkHelpers} = await setupFixtures();

describe('TestTokens', function () {
	it('TestTokens', async function () {
		const {TestTokens} = await networkHelpers.loadFixture(deployTestTokens);
		const decimals = await TestTokens.read.decimals();
		expect(decimals).toEqual(18);
	});
});
