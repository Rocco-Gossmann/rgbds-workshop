#!/bin/php -f
<?php
    // make sure this is only run via CLI
    if(empty($argc) or empty($argv)) exit("can only be called from cli");
  
    // Check required arguments
    if($argc < 2) exit("Usage: {$argv[0]} inputfile [palettebyte = 0xE4] \n");

    if($argc == 3) $iPalette = (int)$argv[2];
    else           $iPalette = 0xE4;

    // Add a linebreak to output
    echo "\n";

    // Load image
    $img = imagecreatefromstring(file_get_contents($argv[1]));
    if(!$img) die("filed ot open image. Check your format (allowed is PNG, JPG, JPEG, GIF, BMP)");

    // pret output
    $out = false;
    $sOutFile = $argv[1] . ".bin";

    try {
        // Open output
        $out = fopen($sOutFile, "w");
        if(!$out) 
            throw new Exception("failed to open {$sOutFile} for writing. Check your permissions and if the dir exists");

        // Check image dimensions (must be devidable by 8)
        list($iWidth, $iHeight) = getimagesize($argv[1]);
        if($iWidth&8 or $iHeight%8)
            throw new Exception("image dimensions must be divisible by 8");

        // Process Image
        $iTilesW = $iWidth / 8;
        $iTilesH = $iHeight / 8;
        $sSep = "";
        $iCountBytes = 0;

        for($ty=0, $oy=0; $ty < $iTilesH; $ty++,$oy+=8) {       // for each tilerow
            for($tx=0, $ox=0; $tx < $iTilesW; $tx++, $ox+=8) {  // each tile in row
                for($y = $oy; $y < $oy+8; $y++) {               // each line in that tile
                    $aBytes = [0, 0];
                    
                    for($x=$ox, $bo=7; $x < $ox+8; $x++, $bo--) {           // each pixel in that line
                        $iPixel = imagecolorat($img, $x, $y);

                        $r = $iPixel>>16&0xff;
                        $g = $iPixel>> 8&0xff;
                        $b = $iPixel>> 0&0xff;
                        $sum = ($g+$b+$r) / 3;

                        $iGBColor = 3-floor($sum / 64);
                        echo $iGBColor, " ";
    
                        

                        
                        $aBytes[1] = $aBytes[1] | ($iGBColor>>1&0x1)<<$bo;
                        $aBytes[0] = $aBytes[0] | ($iGBColor   &0x1)<<$bo;
                    }

                    fwrite($out, chr($aBytes[0]), 1);
                    fwrite($out, chr($aBytes[1]), 1);
                    $iCountBytes+=2;
                }
            }
        }

        echo "\nwrote $iCountBytes Byte(s) to $sOutFile\n";

    }
    catch( Exception $ex ) {
        echo $ex->getMessage();
        if($out) {
            fclose($out);
            unlink($sOutFile);
            $out = false;
        }
        exit;
    } 
    finally {
        // destroy image instance
        if($out) fclose($out);
        imagedestroy($img);
    }


