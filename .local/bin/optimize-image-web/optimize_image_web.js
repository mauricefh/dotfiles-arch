#!/usr/bin/env node

import path from "path";
import fs from "fs/promises";
import sharp from "sharp";
import fg from "fast-glob";
import yargs from "yargs";
import { hideBin } from "yargs/helpers";

async function optimizeImage(inputFile, outputFile, convertToWebp) {
  try {
    let pipeline = sharp(inputFile);

    // For HEIC input, sharp converts automatically
    const metadata = await pipeline.metadata();

    if (convertToWebp) {
      pipeline = pipeline.webp({ quality: 80 });
      // Ensure output file ends with .webp
      if (!outputFile.toLowerCase().endsWith(".webp")) {
        outputFile = outputFile.replace(/\.[^.]+$/, "") + ".webp";
      }
    } else {
      // Compress based on input format
      if (metadata.format === "jpeg") {
        pipeline = pipeline.jpeg({ quality: 80, mozjpeg: true });
      } else if (metadata.format === "png") {
        pipeline = pipeline.png({ compressionLevel: 9 });
      } else if (metadata.format === "webp") {
        pipeline = pipeline.webp({ quality: 80 });
      }
      // For other formats, just copy as is
    }

    await fs.mkdir(path.dirname(outputFile), { recursive: true });
    await pipeline.toFile(outputFile);

    console.log(`Optimized: ${inputFile} -> ${outputFile}`);
  } catch (err) {
    console.error(`Failed to optimize ${inputFile}:`, err.message);
  }
}

async function main() {
  const argv = yargs(hideBin(process.argv))
    .usage("Usage: $0 <input-folder> [output-folder] [--webp]")
    .demandCommand(1)
    .option("webp", {
      type: "boolean",
      description: "Convert images to WebP format",
      default: false,
    })
    .help().argv;

  const inputFolder = path.resolve(argv._[0]);
  const outputFolder = argv._[1] ? path.resolve(argv._[1]) : inputFolder;
  const convertToWebp = argv.webp;

  // Validate input folder exists
  try {
    const stat = await fs.stat(inputFolder);
    if (!stat.isDirectory()) {
      console.error("Input path is not a directory.");
      process.exit(1);
    }
  } catch {
    console.error("Input folder does not exist.");
    process.exit(1);
  }

  // File patterns for images to process
  const patterns = ["**/*.{png,jpeg,jpg,webp,heic}"];

  const files = await fg(patterns, {
    cwd: inputFolder,
    absolute: true,
    onlyFiles: true,
    caseSensitiveMatch: false,
  });

  if (files.length === 0) {
    console.log("No image files found in input folder.");
    process.exit(0);
  }

  for (const inputFile of files) {
    // Determine relative path to keep folder structure in output
    const relativePath = path.relative(inputFolder, inputFile);
    let outputFile = path.join(outputFolder, relativePath);

    // If converting to webp, change extension accordingly
    if (convertToWebp) {
      outputFile = outputFile.replace(/\.[^.]+$/, ".webp");
    }

    await optimizeImage(inputFile, outputFile, convertToWebp);
  }

  console.log("Optimization complete.");
}

main();
