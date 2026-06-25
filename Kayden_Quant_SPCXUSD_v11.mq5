<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GMX Synthetics - SPCXUSD Market Setup</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body { font-family: 'Segoe UI', system-ui, sans-serif; }
        .code-block { font-family: ui-monospace, monospace; }
    </style>
</head>
<body class="bg-gray-950 text-gray-200">
    <div class="max-w-4xl mx-auto p-8">
        <!-- Header -->
        <div class="flex items-center gap-4 mb-8 border-b border-gray-800 pb-6">
            <i class="fa-solid fa-rocket text-4xl text-orange-500"></i>
            <div>
                <h1 class="text-4xl font-bold">GMX Synthetics</h1>
                <p class="text-xl text-orange-400">SPCXUSD Market Configuration</p>
            </div>
        </div>

        <div class="bg-gray-900 rounded-2xl p-8 mb-8">
            <h2 class="text-3xl font-bold mb-2 flex items-center gap-3">
                <span class="text-emerald-400">🚀</span> SPCXUSD Synthetic Perpetual
            </h2>
            <p class="text-gray-400">Pre-IPO SpaceX Exposure • Max ~10x Leverage • Arbitrum + Avalanche</p>
        </div>

        <!-- Quick Start -->
        <div class="mb-12">
            <h2 class="text-2xl font-bold mb-6 flex items-center gap-3"><i class="fa-solid fa-bolt"></i> Quick Start</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="bg-gray-900 p-6 rounded-xl">
                    <h3 class="font-semibold mb-4 text-orange-400">1. Clone & Setup</h3>
                    <pre class="code-block bg-black p-4 rounded-lg text-sm overflow-x-auto">git clone https://github.com/YOUR-USERNAME/gmx-synthetics.git
cd gmx-synthetics
npm install
npx hardhat compile</pre>
                </div>
                <div class="bg-gray-900 p-6 rounded-xl">
                    <h3 class="font-semibold mb-4 text-orange-400">2. Add SPCXUSD</h3>
                    <p class="text-sm text-gray-400">Update <code class="bg-black px-1 rounded">config/tokens.ts</code> and <code class="bg-black px-1 rounded">config/markets.ts</code></p>
                </div>
            </div>
        </div>

        <!-- SPCX Token Config -->
        <div class="mb-12">
            <h2 class="text-2xl font-bold mb-6">1. Add SPCX Token — <code class="text-orange-400">config/tokens.ts</code></h2>
            <pre class="code-block bg-black p-6 rounded-2xl text-sm overflow-x-auto leading-relaxed text-emerald-300">
SPCX: {
  name: "SPCX",
  symbol: "SPCX",
  decimals: 18,
  address: "0x0000000000000000000000000000000000000000", // synthetic
  synthetic: true,
  dataStreamFeedId: "0xYOUR_ACTUAL_SPCX_DATASTREAM_FEED_ID", 
  dataStreamFeedDecimals: 18,
  oracleTimestampAdjustment: 1,
  isStable: false,
  isShortable: true,
  isSynthetic: true,
},</pre>
        </div>

        <!-- Full SPCXUSD Market Config -->
        <div class="mb-12">
            <h2 class="text-2xl font-bold mb-6">2. Add SPCXUSD Market — <code class="text-orange-400">config/markets.ts</code></h2>
            <pre class="code-block bg-black p-6 rounded-2xl text-sm overflow-x-auto leading-relaxed text-sky-300">
{
  tokens: {
    indexToken: "SPCX",
    longToken: "WETH",
    shortToken: "USDC"
  },
  virtualTokenIdForIndexToken: hashString("PERP:SPCX/USD"),
  virtualMarketId: hashString("SPOT:SPCX/USD"),

  ...syntheticMarketConfig,
  ...fundingRateConfig_Default,
  ...borrowingRateConfig_HighMax_WithHigherBase,

  // SPCX Specific Parameters
  negativePositionImpactFactor: exponentToFloat("5e-10"),
  positivePositionImpactFactor: exponentToFloat("2.5e-10"),
  negativePositionImpactExponentFactor: exponentToFloat("2.2e0"),

  negativeSwapImpactFactor: exponentToFloat("5e-9"),
  positiveSwapImpactFactor: exponentToFloat("2.5e-9"),

  minCollateralFactor: percentageToFloat("10%"),           // ~10x max leverage
  minCollateralFactorForLiquidation: percentageToFloat("10%"),

  reserveFactor: percentageToFloat("125%"),
  openInterestReserveFactor: percentageToFloat("120%"),

  maxOpenInterest: decimalToFloat(5_000_000),
  maxOpenInterestForLongs: decimalToFloat(3_000_000),
  maxOpenInterestForShorts: decimalToFloat(3_000_000),

  maxPoolUsdForDeposit: decimalToFloat(10_000_000),
  maxLongTokenPoolAmount: expandDecimals(5000, 18),
  maxShortTokenPoolAmount: expandDecimals(10_000_000, 6),

  atomicSwapFeeFactor: percentageToFloat("2.25%"),
  isDisabled: false,
},</pre>
        </div>

        <!-- Deployment -->
        <div class="bg-gray-900 rounded-2xl p-8 mb-12">
            <h2 class="text-2xl font-bold mb-6">Deployment Command</h2>
            <pre class="code-block bg-black p-5 rounded-xl">npx hardhat run scripts/deployContracts.ts --network arbitrum</pre>
            <p class="mt-4 text-sm text-gray-400">Don't forget to create <code>.env</code> with your RPC and private key.</p>
        </div>

        <!-- Final Notes -->
        <div class="border border-orange-500/30 bg-orange-950/30 rounded-2xl p-8">
            <h3 class="font-bold text-orange-400 mb-4">Important Notes</h3>
            <ul class="space-y-3 text-sm">
                <li class="flex gap-3"><i class="fa-solid fa-check text-emerald-400 mt-1"></i> Replace <code>YOUR_ACTUAL_SPCX_DATASTREAM_FEED_ID</code> with real oracle feed from GMX keepers</li>
                <li class="flex gap-3"><i class="fa-solid fa-check text-emerald-400 mt-1"></i> Start with low maxOpenInterest and increase via governance</li>
                <li class="flex gap-3"><i class="fa-solid fa-check text-emerald-400 mt-1"></i> Test thoroughly on testnet before mainnet</li>
                <li class="flex gap-3"><i class="fa-solid fa-check text-emerald-400 mt-1"></i> This config follows GMX's current synthetic market pattern (June 2026)</li>
            </ul>
        </div>

        <div class="text-center text-gray-500 mt-12 text-sm">
            Generated for GitHub • SPCXUSD Market • June 2026
        </div>
    </div>
</body>
</html>