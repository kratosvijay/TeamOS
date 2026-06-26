import * as crypto from 'crypto';

function crc32(buf: Buffer): number {
  let crc = 0xffffffff;
  for (let i = 0; i < buf.length; i++) {
    crc ^= buf[i];
    for (let j = 0; j < 8; j++) {
      if (crc & 1) {
        crc = (crc >>> 1) ^ 0xedb88320;
      } else {
        crc >>>= 1;
      }
    }
  }
  return (crc ^ 0xffffffff) >>> 0;
}

export function createZip(files: { name: string; content: string | Buffer }[]): Buffer {
  const localHeaders: Buffer[] = [];
  const centralDirectories: Buffer[] = [];
  let currentOffset = 0;

  for (const file of files) {
    const dataBuf = typeof file.content === 'string' ? Buffer.from(file.content) : file.content;
    const nameBuf = Buffer.from(file.name);
    const crc = crc32(dataBuf);
    const size = dataBuf.length;

    // Local Header
    const localHeader = Buffer.alloc(30 + nameBuf.length);
    localHeader.writeUInt32LE(0x04034b50, 0); // Local file header signature
    localHeader.writeUInt16LE(10, 4);        // Version needed to extract
    localHeader.writeUInt16LE(0, 6);         // General purpose bit flag
    localHeader.writeUInt16LE(0, 8);         // Compression method (0 = stored)
    localHeader.writeUInt16LE(0, 10);        // Last mod file time
    localHeader.writeUInt16LE(0, 12);        // Last mod file date
    localHeader.writeUInt32LE(crc, 14);      // CRC-32
    localHeader.writeUInt32LE(size, 18);     // Compressed size
    localHeader.writeUInt32LE(size, 22);     // Uncompressed size
    localHeader.writeUInt16LE(nameBuf.length, 26); // File name length
    localHeader.writeUInt16LE(0, 28);        // Extra field length
    nameBuf.copy(localHeader, 30);

    localHeaders.push(localHeader);
    localHeaders.push(dataBuf);

    // Central Directory Header
    const cdHeader = Buffer.alloc(46 + nameBuf.length);
    cdHeader.writeUInt32LE(0x02014b50, 0);   // Central file header signature
    cdHeader.writeUInt16LE(20, 4);           // Version made by
    cdHeader.writeUInt16LE(10, 6);           // Version needed to extract
    cdHeader.writeUInt16LE(0, 8);            // General purpose bit flag
    cdHeader.writeUInt16LE(0, 10);           // Compression method
    cdHeader.writeUInt16LE(0, 12);           // Last mod time
    cdHeader.writeUInt16LE(0, 14);           // Last mod date
    cdHeader.writeUInt32LE(crc, 16);         // CRC-32
    cdHeader.writeUInt32LE(size, 20);        // Compressed size
    cdHeader.writeUInt32LE(size, 24);        // Uncompressed size
    cdHeader.writeUInt16LE(nameBuf.length, 28); // File name length
    cdHeader.writeUInt16LE(0, 30);           // Extra field length
    cdHeader.writeUInt16LE(0, 32);           // File comment length
    cdHeader.writeUInt16LE(0, 34);           // Disk number start
    cdHeader.writeUInt16LE(0, 36);           // Internal file attrs
    cdHeader.writeUInt32LE(0, 38);           // External file attrs
    cdHeader.writeUInt32LE(currentOffset, 42); // Relative offset of local header
    nameBuf.copy(cdHeader, 46);

    centralDirectories.push(cdHeader);
    currentOffset += localHeader.length + dataBuf.length;
  }

  const cdStartOffset = currentOffset;
  const cdBuf = Buffer.concat(centralDirectories);
  const cdSize = cdBuf.length;

  // End of Central Directory
  const eocd = Buffer.alloc(22);
  eocd.writeUInt32LE(0x06054b50, 0);        // End of central dir signature
  eocd.writeUInt16LE(0, 4);                 // Number of this disk
  eocd.writeUInt16LE(0, 6);                 // Disk where central directory starts
  eocd.writeUInt16LE(files.length, 8);      // Number of central directory records on this disk
  eocd.writeUInt16LE(files.length, 10);     // Total number of central directory records
  eocd.writeUInt32LE(cdSize, 12);           // Size of central directory
  eocd.writeUInt32LE(cdStartOffset, 16);    // Offset of start of central directory, relative to start of archive
  eocd.writeUInt16LE(0, 20);                 // Comment length

  return Buffer.concat([...localHeaders, cdBuf, eocd]);
}
