pragma solidity ^0.8.24;

import {Test, console2} from "forge-std/Test.sol";
import {IUniswapV3Pool} from
    "../../../src/interfaces/uniswap-v3/IUniswapV3Pool.sol";
import {UNISWAP_V3_POOL_USDC_WETH_500} from "../../../src/Constants.sol";
import {FullMath} from "../../../src/uniswap-v3/FullMath.sol";

contract UniswapV3SwapTest is Test {
    // token0 (X)
    uint256 private constant USDC_DECIMALS = 1e6;
    // token1 (Y)
    uint256 private constant WETH_DECIMALS = 1e18;
    // 1 << 96 = 2 ** 96
    uint256 private constant Q96 = 1 << 96;
    IUniswapV3Pool private immutable pool =
        IUniswapV3Pool(UNISWAP_V3_POOL_USDC_WETH_500);

    // Get price of WETH in terms of USDC and return price with 18 decimals
    function test_spot_price_from_sqrtPriceX96() public {
        uint256 price = 0;
        IUniswapV3Pool.Slot0 memory slot0 = pool.slot0();

        // Write your code here
        // Don’t change any other code
        uint256 sqrtPricex96 = uint256(slot0.sqrtPriceX96());

        uint256 Price = FullMath.mulDiv(sqrtPricex96, sqrtPricex96, Q96);
        // now price = y/x but here we use x/y weth in usdc
        // price = 1e6/1e18 but 1/p = 1e12
        price = (1e12 * Q96 / Price) * 1e18;

        // sqrtPriceX96 * sqrtPriceX96 might overflow
        // So use FullMath.mulDiv to do uint256 * uint256 / uint256 without overflow

        assertGt(price, 0, "price = 0");
        console2.log("price %e", price);
    }
}
