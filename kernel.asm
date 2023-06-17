
kernel:     formato del fichero elf32-i386


Desensamblado de la sección .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 99 2a 10 80       	mov    $0x80102a99,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	57                   	push   %edi
80100038:	56                   	push   %esi
80100039:	53                   	push   %ebx
8010003a:	83 ec 18             	sub    $0x18,%esp
8010003d:	89 c6                	mov    %eax,%esi
8010003f:	89 d7                	mov    %edx,%edi
  struct buf *b;

  acquire(&bcache.lock);
80100041:	68 c0 b5 10 80       	push   $0x8010b5c0
80100046:	e8 01 3c 00 00       	call   80103c4c <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010004b:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
80100051:	83 c4 10             	add    $0x10,%esp
80100054:	eb 03                	jmp    80100059 <bget+0x25>
80100056:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100059:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010005f:	74 2e                	je     8010008f <bget+0x5b>
    if(b->dev == dev && b->blockno == blockno){
80100061:	39 73 04             	cmp    %esi,0x4(%ebx)
80100064:	75 f0                	jne    80100056 <bget+0x22>
80100066:	39 7b 08             	cmp    %edi,0x8(%ebx)
80100069:	75 eb                	jne    80100056 <bget+0x22>
      b->refcnt++;
8010006b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010006e:	40                   	inc    %eax
8010006f:	89 43 4c             	mov    %eax,0x4c(%ebx)
      release(&bcache.lock);
80100072:	83 ec 0c             	sub    $0xc,%esp
80100075:	68 c0 b5 10 80       	push   $0x8010b5c0
8010007a:	e8 36 3c 00 00       	call   80103cb5 <release>
      acquiresleep(&b->lock);
8010007f:	8d 43 0c             	lea    0xc(%ebx),%eax
80100082:	89 04 24             	mov    %eax,(%esp)
80100085:	e8 93 39 00 00       	call   80103a1d <acquiresleep>
      return b;
8010008a:	83 c4 10             	add    $0x10,%esp
8010008d:	eb 4c                	jmp    801000db <bget+0xa7>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010008f:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100095:	eb 03                	jmp    8010009a <bget+0x66>
80100097:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010009a:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000a0:	74 43                	je     801000e5 <bget+0xb1>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
801000a2:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801000a6:	75 ef                	jne    80100097 <bget+0x63>
801000a8:	f6 03 04             	testb  $0x4,(%ebx)
801000ab:	75 ea                	jne    80100097 <bget+0x63>
      b->dev = dev;
801000ad:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
801000b0:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
801000b3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
801000b9:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
801000c0:	83 ec 0c             	sub    $0xc,%esp
801000c3:	68 c0 b5 10 80       	push   $0x8010b5c0
801000c8:	e8 e8 3b 00 00       	call   80103cb5 <release>
      acquiresleep(&b->lock);
801000cd:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d0:	89 04 24             	mov    %eax,(%esp)
801000d3:	e8 45 39 00 00       	call   80103a1d <acquiresleep>
      return b;
801000d8:	83 c4 10             	add    $0x10,%esp
    }
  }
  panic("bget: no buffers");
}
801000db:	89 d8                	mov    %ebx,%eax
801000dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000e0:	5b                   	pop    %ebx
801000e1:	5e                   	pop    %esi
801000e2:	5f                   	pop    %edi
801000e3:	5d                   	pop    %ebp
801000e4:	c3                   	ret    
  panic("bget: no buffers");
801000e5:	83 ec 0c             	sub    $0xc,%esp
801000e8:	68 40 66 10 80       	push   $0x80106640
801000ed:	e8 63 02 00 00       	call   80100355 <panic>

801000f2 <binit>:
{
801000f2:	f3 0f 1e fb          	endbr32 
801000f6:	55                   	push   %ebp
801000f7:	89 e5                	mov    %esp,%ebp
801000f9:	53                   	push   %ebx
801000fa:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
801000fd:	68 51 66 10 80       	push   $0x80106651
80100102:	68 c0 b5 10 80       	push   $0x8010b5c0
80100107:	e8 f5 39 00 00       	call   80103b01 <initlock>
  bcache.head.prev = &bcache.head;
8010010c:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100113:	fc 10 80 
  bcache.head.next = &bcache.head;
80100116:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010011d:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100120:	83 c4 10             	add    $0x10,%esp
80100123:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
80100128:	eb 37                	jmp    80100161 <binit+0x6f>
    b->next = bcache.head.next;
8010012a:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010012f:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100132:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100139:	83 ec 08             	sub    $0x8,%esp
8010013c:	68 58 66 10 80       	push   $0x80106658
80100141:	8d 43 0c             	lea    0xc(%ebx),%eax
80100144:	50                   	push   %eax
80100145:	e8 9c 38 00 00       	call   801039e6 <initsleeplock>
    bcache.head.next->prev = b;
8010014a:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010014f:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100152:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100158:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
8010015e:	83 c4 10             	add    $0x10,%esp
80100161:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100167:	72 c1                	jb     8010012a <binit+0x38>
}
80100169:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010016c:	c9                   	leave  
8010016d:	c3                   	ret    

8010016e <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
8010016e:	f3 0f 1e fb          	endbr32 
80100172:	55                   	push   %ebp
80100173:	89 e5                	mov    %esp,%ebp
80100175:	53                   	push   %ebx
80100176:	83 ec 04             	sub    $0x4,%esp
  struct buf *b;

  b = bget(dev, blockno);
80100179:	8b 55 0c             	mov    0xc(%ebp),%edx
8010017c:	8b 45 08             	mov    0x8(%ebp),%eax
8010017f:	e8 b0 fe ff ff       	call   80100034 <bget>
80100184:	89 c3                	mov    %eax,%ebx
  if((b->flags & B_VALID) == 0) {
80100186:	f6 00 02             	testb  $0x2,(%eax)
80100189:	74 07                	je     80100192 <bread+0x24>
    iderw(b);
  }
  return b;
}
8010018b:	89 d8                	mov    %ebx,%eax
8010018d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100190:	c9                   	leave  
80100191:	c3                   	ret    
    iderw(b);
80100192:	83 ec 0c             	sub    $0xc,%esp
80100195:	50                   	push   %eax
80100196:	e8 9a 1c 00 00       	call   80101e35 <iderw>
8010019b:	83 c4 10             	add    $0x10,%esp
  return b;
8010019e:	eb eb                	jmp    8010018b <bread+0x1d>

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	f3 0f 1e fb          	endbr32 
801001a4:	55                   	push   %ebp
801001a5:	89 e5                	mov    %esp,%ebp
801001a7:	53                   	push   %ebx
801001a8:	83 ec 10             	sub    $0x10,%esp
801001ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801001b1:	50                   	push   %eax
801001b2:	e8 f8 38 00 00       	call   80103aaf <holdingsleep>
801001b7:	83 c4 10             	add    $0x10,%esp
801001ba:	85 c0                	test   %eax,%eax
801001bc:	74 14                	je     801001d2 <bwrite+0x32>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001be:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001c1:	83 ec 0c             	sub    $0xc,%esp
801001c4:	53                   	push   %ebx
801001c5:	e8 6b 1c 00 00       	call   80101e35 <iderw>
}
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d0:	c9                   	leave  
801001d1:	c3                   	ret    
    panic("bwrite");
801001d2:	83 ec 0c             	sub    $0xc,%esp
801001d5:	68 5f 66 10 80       	push   $0x8010665f
801001da:	e8 76 01 00 00       	call   80100355 <panic>

801001df <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001df:	f3 0f 1e fb          	endbr32 
801001e3:	55                   	push   %ebp
801001e4:	89 e5                	mov    %esp,%ebp
801001e6:	56                   	push   %esi
801001e7:	53                   	push   %ebx
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	83 ec 0c             	sub    $0xc,%esp
801001f1:	56                   	push   %esi
801001f2:	e8 b8 38 00 00       	call   80103aaf <holdingsleep>
801001f7:	83 c4 10             	add    $0x10,%esp
801001fa:	85 c0                	test   %eax,%eax
801001fc:	74 69                	je     80100267 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
801001fe:	83 ec 0c             	sub    $0xc,%esp
80100201:	56                   	push   %esi
80100202:	e8 69 38 00 00       	call   80103a70 <releasesleep>

  acquire(&bcache.lock);
80100207:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020e:	e8 39 3a 00 00       	call   80103c4c <acquire>
  b->refcnt--;
80100213:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100216:	48                   	dec    %eax
80100217:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021a:	83 c4 10             	add    $0x10,%esp
8010021d:	85 c0                	test   %eax,%eax
8010021f:	75 2f                	jne    80100250 <brelse+0x71>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100221:	8b 43 54             	mov    0x54(%ebx),%eax
80100224:	8b 53 50             	mov    0x50(%ebx),%edx
80100227:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010022a:	8b 43 50             	mov    0x50(%ebx),%eax
8010022d:	8b 53 54             	mov    0x54(%ebx),%edx
80100230:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100233:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100238:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010023b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    bcache.head.next->prev = b;
80100242:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100247:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010024a:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100250:	83 ec 0c             	sub    $0xc,%esp
80100253:	68 c0 b5 10 80       	push   $0x8010b5c0
80100258:	e8 58 3a 00 00       	call   80103cb5 <release>
}
8010025d:	83 c4 10             	add    $0x10,%esp
80100260:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100263:	5b                   	pop    %ebx
80100264:	5e                   	pop    %esi
80100265:	5d                   	pop    %ebp
80100266:	c3                   	ret    
    panic("brelse");
80100267:	83 ec 0c             	sub    $0xc,%esp
8010026a:	68 66 66 10 80       	push   $0x80106666
8010026f:	e8 e1 00 00 00       	call   80100355 <panic>

80100274 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100274:	f3 0f 1e fb          	endbr32 
80100278:	55                   	push   %ebp
80100279:	89 e5                	mov    %esp,%ebp
8010027b:	57                   	push   %edi
8010027c:	56                   	push   %esi
8010027d:	53                   	push   %ebx
8010027e:	83 ec 28             	sub    $0x28,%esp
80100281:	8b 7d 08             	mov    0x8(%ebp),%edi
80100284:	8b 75 0c             	mov    0xc(%ebp),%esi
80100287:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
8010028a:	57                   	push   %edi
8010028b:	e8 ba 13 00 00       	call   8010164a <iunlock>
  target = n;
80100290:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
80100293:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010029a:	e8 ad 39 00 00       	call   80103c4c <acquire>
  while(n > 0){
8010029f:	83 c4 10             	add    $0x10,%esp
801002a2:	85 db                	test   %ebx,%ebx
801002a4:	0f 8e 8c 00 00 00    	jle    80100336 <consoleread+0xc2>
    while(input.r == input.w){
801002aa:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002af:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002b5:	75 47                	jne    801002fe <consoleread+0x8a>
      if(myproc()->killed){
801002b7:	e8 95 2f 00 00       	call   80103251 <myproc>
801002bc:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801002c0:	75 17                	jne    801002d9 <consoleread+0x65>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c2:	83 ec 08             	sub    $0x8,%esp
801002c5:	68 20 a5 10 80       	push   $0x8010a520
801002ca:	68 a0 ff 10 80       	push   $0x8010ffa0
801002cf:	e8 4a 34 00 00       	call   8010371e <sleep>
801002d4:	83 c4 10             	add    $0x10,%esp
801002d7:	eb d1                	jmp    801002aa <consoleread+0x36>
        release(&cons.lock);
801002d9:	83 ec 0c             	sub    $0xc,%esp
801002dc:	68 20 a5 10 80       	push   $0x8010a520
801002e1:	e8 cf 39 00 00       	call   80103cb5 <release>
        ilock(ip);
801002e6:	89 3c 24             	mov    %edi,(%esp)
801002e9:	e8 98 12 00 00       	call   80101586 <ilock>
        return -1;
801002ee:	83 c4 10             	add    $0x10,%esp
801002f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002f9:	5b                   	pop    %ebx
801002fa:	5e                   	pop    %esi
801002fb:	5f                   	pop    %edi
801002fc:	5d                   	pop    %ebp
801002fd:	c3                   	ret    
    c = input.buf[input.r++ % INPUT_BUF];
801002fe:	8d 50 01             	lea    0x1(%eax),%edx
80100301:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100307:	89 c2                	mov    %eax,%edx
80100309:	83 e2 7f             	and    $0x7f,%edx
8010030c:	8a 92 20 ff 10 80    	mov    -0x7fef00e0(%edx),%dl
80100312:	0f be ca             	movsbl %dl,%ecx
    if(c == C('D')){  // EOF
80100315:	80 fa 04             	cmp    $0x4,%dl
80100318:	74 12                	je     8010032c <consoleread+0xb8>
    *dst++ = c;
8010031a:	8d 46 01             	lea    0x1(%esi),%eax
8010031d:	88 16                	mov    %dl,(%esi)
    --n;
8010031f:	4b                   	dec    %ebx
    if(c == '\n')
80100320:	83 f9 0a             	cmp    $0xa,%ecx
80100323:	74 11                	je     80100336 <consoleread+0xc2>
    *dst++ = c;
80100325:	89 c6                	mov    %eax,%esi
80100327:	e9 76 ff ff ff       	jmp    801002a2 <consoleread+0x2e>
      if(n < target){
8010032c:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
8010032f:	73 05                	jae    80100336 <consoleread+0xc2>
        input.r--;
80100331:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
  release(&cons.lock);
80100336:	83 ec 0c             	sub    $0xc,%esp
80100339:	68 20 a5 10 80       	push   $0x8010a520
8010033e:	e8 72 39 00 00       	call   80103cb5 <release>
  ilock(ip);
80100343:	89 3c 24             	mov    %edi,(%esp)
80100346:	e8 3b 12 00 00       	call   80101586 <ilock>
  return target - n;
8010034b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010034e:	29 d8                	sub    %ebx,%eax
80100350:	83 c4 10             	add    $0x10,%esp
80100353:	eb a1                	jmp    801002f6 <consoleread+0x82>

80100355 <panic>:
{
80100355:	f3 0f 1e fb          	endbr32 
80100359:	55                   	push   %ebp
8010035a:	89 e5                	mov    %esp,%ebp
8010035c:	53                   	push   %ebx
8010035d:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100360:	fa                   	cli    
  cons.locking = 0;
80100361:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100368:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
8010036b:	e8 52 20 00 00       	call   801023c2 <lapicid>
80100370:	83 ec 08             	sub    $0x8,%esp
80100373:	50                   	push   %eax
80100374:	68 6d 66 10 80       	push   $0x8010666d
80100379:	e8 7f 02 00 00       	call   801005fd <cprintf>
  cprintf(s);
8010037e:	83 c4 04             	add    $0x4,%esp
80100381:	ff 75 08             	pushl  0x8(%ebp)
80100384:	e8 74 02 00 00       	call   801005fd <cprintf>
  cprintf("\n");
80100389:	c7 04 24 9f 6f 10 80 	movl   $0x80106f9f,(%esp)
80100390:	e8 68 02 00 00       	call   801005fd <cprintf>
  getcallerpcs(&s, pcs);
80100395:	83 c4 08             	add    $0x8,%esp
80100398:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010039b:	50                   	push   %eax
8010039c:	8d 45 08             	lea    0x8(%ebp),%eax
8010039f:	50                   	push   %eax
801003a0:	e8 7b 37 00 00       	call   80103b20 <getcallerpcs>
  for(i=0; i<10; i++)
801003a5:	83 c4 10             	add    $0x10,%esp
801003a8:	bb 00 00 00 00       	mov    $0x0,%ebx
801003ad:	eb 15                	jmp    801003c4 <panic+0x6f>
    cprintf(" %p", pcs[i]);
801003af:	83 ec 08             	sub    $0x8,%esp
801003b2:	ff 74 9d d0          	pushl  -0x30(%ebp,%ebx,4)
801003b6:	68 81 66 10 80       	push   $0x80106681
801003bb:	e8 3d 02 00 00       	call   801005fd <cprintf>
  for(i=0; i<10; i++)
801003c0:	43                   	inc    %ebx
801003c1:	83 c4 10             	add    $0x10,%esp
801003c4:	83 fb 09             	cmp    $0x9,%ebx
801003c7:	7e e6                	jle    801003af <panic+0x5a>
  panicked = 1; // freeze other CPU
801003c9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d0:	00 00 00 
  for(;;)
801003d3:	eb fe                	jmp    801003d3 <panic+0x7e>

801003d5 <cgaputc>:
{
801003d5:	55                   	push   %ebp
801003d6:	89 e5                	mov    %esp,%ebp
801003d8:	57                   	push   %edi
801003d9:	56                   	push   %esi
801003da:	53                   	push   %ebx
801003db:	83 ec 0c             	sub    $0xc,%esp
801003de:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003e0:	bf d4 03 00 00       	mov    $0x3d4,%edi
801003e5:	b0 0e                	mov    $0xe,%al
801003e7:	89 fa                	mov    %edi,%edx
801003e9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003ea:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801003ef:	89 da                	mov    %ebx,%edx
801003f1:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003f2:	0f b6 c8             	movzbl %al,%ecx
801003f5:	c1 e1 08             	shl    $0x8,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003f8:	b0 0f                	mov    $0xf,%al
801003fa:	89 fa                	mov    %edi,%edx
801003fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003fd:	89 da                	mov    %ebx,%edx
801003ff:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100400:	0f b6 c0             	movzbl %al,%eax
80100403:	09 c1                	or     %eax,%ecx
  if(c == '\n')
80100405:	83 fe 0a             	cmp    $0xa,%esi
80100408:	74 61                	je     8010046b <cgaputc+0x96>
  else if(c == BACKSPACE){
8010040a:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80100410:	74 69                	je     8010047b <cgaputc+0xa6>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100412:	89 f0                	mov    %esi,%eax
80100414:	0f b6 f0             	movzbl %al,%esi
80100417:	8d 59 01             	lea    0x1(%ecx),%ebx
8010041a:	81 ce 00 07 00 00    	or     $0x700,%esi
80100420:	66 89 b4 09 00 80 0b 	mov    %si,-0x7ff48000(%ecx,%ecx,1)
80100427:	80 
  if(pos < 0 || pos > 25*80)
80100428:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010042e:	77 58                	ja     80100488 <cgaputc+0xb3>
  if((pos/80) >= 24){  // Scroll up.
80100430:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100436:	7f 5d                	jg     80100495 <cgaputc+0xc0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100438:	be d4 03 00 00       	mov    $0x3d4,%esi
8010043d:	b0 0e                	mov    $0xe,%al
8010043f:	89 f2                	mov    %esi,%edx
80100441:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80100442:	89 d8                	mov    %ebx,%eax
80100444:	c1 f8 08             	sar    $0x8,%eax
80100447:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010044c:	89 ca                	mov    %ecx,%edx
8010044e:	ee                   	out    %al,(%dx)
8010044f:	b0 0f                	mov    $0xf,%al
80100451:	89 f2                	mov    %esi,%edx
80100453:	ee                   	out    %al,(%dx)
80100454:	88 d8                	mov    %bl,%al
80100456:	89 ca                	mov    %ecx,%edx
80100458:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
80100459:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
80100460:	80 20 07 
}
80100463:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100466:	5b                   	pop    %ebx
80100467:	5e                   	pop    %esi
80100468:	5f                   	pop    %edi
80100469:	5d                   	pop    %ebp
8010046a:	c3                   	ret    
    pos += 80 - pos%80;
8010046b:	bb 50 00 00 00       	mov    $0x50,%ebx
80100470:	89 c8                	mov    %ecx,%eax
80100472:	99                   	cltd   
80100473:	f7 fb                	idiv   %ebx
80100475:	29 d3                	sub    %edx,%ebx
80100477:	01 cb                	add    %ecx,%ebx
80100479:	eb ad                	jmp    80100428 <cgaputc+0x53>
    if(pos > 0) --pos;
8010047b:	85 c9                	test   %ecx,%ecx
8010047d:	7e 05                	jle    80100484 <cgaputc+0xaf>
8010047f:	8d 59 ff             	lea    -0x1(%ecx),%ebx
80100482:	eb a4                	jmp    80100428 <cgaputc+0x53>
  pos |= inb(CRTPORT+1);
80100484:	89 cb                	mov    %ecx,%ebx
80100486:	eb a0                	jmp    80100428 <cgaputc+0x53>
    panic("pos under/overflow");
80100488:	83 ec 0c             	sub    $0xc,%esp
8010048b:	68 85 66 10 80       	push   $0x80106685
80100490:	e8 c0 fe ff ff       	call   80100355 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100495:	83 ec 04             	sub    $0x4,%esp
80100498:	68 60 0e 00 00       	push   $0xe60
8010049d:	68 a0 80 0b 80       	push   $0x800b80a0
801004a2:	68 00 80 0b 80       	push   $0x800b8000
801004a7:	e8 d2 38 00 00       	call   80103d7e <memmove>
    pos -= 80;
801004ac:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004af:	b8 80 07 00 00       	mov    $0x780,%eax
801004b4:	29 d8                	sub    %ebx,%eax
801004b6:	8d 94 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edx
801004bd:	83 c4 0c             	add    $0xc,%esp
801004c0:	01 c0                	add    %eax,%eax
801004c2:	50                   	push   %eax
801004c3:	6a 00                	push   $0x0
801004c5:	52                   	push   %edx
801004c6:	e8 35 38 00 00       	call   80103d00 <memset>
801004cb:	83 c4 10             	add    $0x10,%esp
801004ce:	e9 65 ff ff ff       	jmp    80100438 <cgaputc+0x63>

801004d3 <consputc>:
  if(panicked){
801004d3:	83 3d 58 a5 10 80 00 	cmpl   $0x0,0x8010a558
801004da:	74 03                	je     801004df <consputc+0xc>
  asm volatile("cli");
801004dc:	fa                   	cli    
    for(;;)
801004dd:	eb fe                	jmp    801004dd <consputc+0xa>
{
801004df:	55                   	push   %ebp
801004e0:	89 e5                	mov    %esp,%ebp
801004e2:	53                   	push   %ebx
801004e3:	83 ec 04             	sub    $0x4,%esp
801004e6:	89 c3                	mov    %eax,%ebx
  if(c == BACKSPACE){
801004e8:	3d 00 01 00 00       	cmp    $0x100,%eax
801004ed:	74 18                	je     80100507 <consputc+0x34>
    uartputc(c);
801004ef:	83 ec 0c             	sub    $0xc,%esp
801004f2:	50                   	push   %eax
801004f3:	e8 d1 4c 00 00       	call   801051c9 <uartputc>
801004f8:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801004fb:	89 d8                	mov    %ebx,%eax
801004fd:	e8 d3 fe ff ff       	call   801003d5 <cgaputc>
}
80100502:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100505:	c9                   	leave  
80100506:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100507:	83 ec 0c             	sub    $0xc,%esp
8010050a:	6a 08                	push   $0x8
8010050c:	e8 b8 4c 00 00       	call   801051c9 <uartputc>
80100511:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100518:	e8 ac 4c 00 00       	call   801051c9 <uartputc>
8010051d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100524:	e8 a0 4c 00 00       	call   801051c9 <uartputc>
80100529:	83 c4 10             	add    $0x10,%esp
8010052c:	eb cd                	jmp    801004fb <consputc+0x28>

8010052e <printint>:
{
8010052e:	55                   	push   %ebp
8010052f:	89 e5                	mov    %esp,%ebp
80100531:	57                   	push   %edi
80100532:	56                   	push   %esi
80100533:	53                   	push   %ebx
80100534:	83 ec 2c             	sub    $0x2c,%esp
80100537:	89 d6                	mov    %edx,%esi
80100539:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
8010053c:	85 c9                	test   %ecx,%ecx
8010053e:	74 0c                	je     8010054c <printint+0x1e>
80100540:	89 c7                	mov    %eax,%edi
80100542:	c1 ef 1f             	shr    $0x1f,%edi
80100545:	89 7d d4             	mov    %edi,-0x2c(%ebp)
80100548:	85 c0                	test   %eax,%eax
8010054a:	78 35                	js     80100581 <printint+0x53>
    x = xx;
8010054c:	89 c1                	mov    %eax,%ecx
  i = 0;
8010054e:	bb 00 00 00 00       	mov    $0x0,%ebx
    buf[i++] = digits[x % base];
80100553:	89 c8                	mov    %ecx,%eax
80100555:	ba 00 00 00 00       	mov    $0x0,%edx
8010055a:	f7 f6                	div    %esi
8010055c:	89 df                	mov    %ebx,%edi
8010055e:	43                   	inc    %ebx
8010055f:	8a 92 b0 66 10 80    	mov    -0x7fef9950(%edx),%dl
80100565:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
80100569:	89 ca                	mov    %ecx,%edx
8010056b:	89 c1                	mov    %eax,%ecx
8010056d:	39 d6                	cmp    %edx,%esi
8010056f:	76 e2                	jbe    80100553 <printint+0x25>
  if(sign)
80100571:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100575:	74 1a                	je     80100591 <printint+0x63>
    buf[i++] = '-';
80100577:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
8010057c:	8d 5f 02             	lea    0x2(%edi),%ebx
8010057f:	eb 10                	jmp    80100591 <printint+0x63>
    x = -xx;
80100581:	f7 d8                	neg    %eax
80100583:	89 c1                	mov    %eax,%ecx
80100585:	eb c7                	jmp    8010054e <printint+0x20>
    consputc(buf[i]);
80100587:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
8010058c:	e8 42 ff ff ff       	call   801004d3 <consputc>
  while(--i >= 0)
80100591:	4b                   	dec    %ebx
80100592:	79 f3                	jns    80100587 <printint+0x59>
}
80100594:	83 c4 2c             	add    $0x2c,%esp
80100597:	5b                   	pop    %ebx
80100598:	5e                   	pop    %esi
80100599:	5f                   	pop    %edi
8010059a:	5d                   	pop    %ebp
8010059b:	c3                   	ret    

8010059c <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010059c:	f3 0f 1e fb          	endbr32 
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 18             	sub    $0x18,%esp
801005a9:	8b 7d 0c             	mov    0xc(%ebp),%edi
801005ac:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005af:	ff 75 08             	pushl  0x8(%ebp)
801005b2:	e8 93 10 00 00       	call   8010164a <iunlock>
  acquire(&cons.lock);
801005b7:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801005be:	e8 89 36 00 00       	call   80103c4c <acquire>
  for(i = 0; i < n; i++)
801005c3:	83 c4 10             	add    $0x10,%esp
801005c6:	bb 00 00 00 00       	mov    $0x0,%ebx
801005cb:	39 f3                	cmp    %esi,%ebx
801005cd:	7d 0c                	jge    801005db <consolewrite+0x3f>
    consputc(buf[i] & 0xff);
801005cf:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801005d3:	e8 fb fe ff ff       	call   801004d3 <consputc>
  for(i = 0; i < n; i++)
801005d8:	43                   	inc    %ebx
801005d9:	eb f0                	jmp    801005cb <consolewrite+0x2f>
  release(&cons.lock);
801005db:	83 ec 0c             	sub    $0xc,%esp
801005de:	68 20 a5 10 80       	push   $0x8010a520
801005e3:	e8 cd 36 00 00       	call   80103cb5 <release>
  ilock(ip);
801005e8:	83 c4 04             	add    $0x4,%esp
801005eb:	ff 75 08             	pushl  0x8(%ebp)
801005ee:	e8 93 0f 00 00       	call   80101586 <ilock>

  return n;
}
801005f3:	89 f0                	mov    %esi,%eax
801005f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f8:	5b                   	pop    %ebx
801005f9:	5e                   	pop    %esi
801005fa:	5f                   	pop    %edi
801005fb:	5d                   	pop    %ebp
801005fc:	c3                   	ret    

801005fd <cprintf>:
{
801005fd:	f3 0f 1e fb          	endbr32 
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	57                   	push   %edi
80100605:	56                   	push   %esi
80100606:	53                   	push   %ebx
80100607:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
8010060a:	a1 54 a5 10 80       	mov    0x8010a554,%eax
8010060f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100612:	85 c0                	test   %eax,%eax
80100614:	75 10                	jne    80100626 <cprintf+0x29>
  if (fmt == 0)
80100616:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010061a:	74 1c                	je     80100638 <cprintf+0x3b>
  argp = (uint*)(void*)(&fmt + 1);
8010061c:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010061f:	be 00 00 00 00       	mov    $0x0,%esi
80100624:	eb 25                	jmp    8010064b <cprintf+0x4e>
    acquire(&cons.lock);
80100626:	83 ec 0c             	sub    $0xc,%esp
80100629:	68 20 a5 10 80       	push   $0x8010a520
8010062e:	e8 19 36 00 00       	call   80103c4c <acquire>
80100633:	83 c4 10             	add    $0x10,%esp
80100636:	eb de                	jmp    80100616 <cprintf+0x19>
    panic("null fmt");
80100638:	83 ec 0c             	sub    $0xc,%esp
8010063b:	68 9f 66 10 80       	push   $0x8010669f
80100640:	e8 10 fd ff ff       	call   80100355 <panic>
      consputc(c);
80100645:	e8 89 fe ff ff       	call   801004d3 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010064a:	46                   	inc    %esi
8010064b:	8b 55 08             	mov    0x8(%ebp),%edx
8010064e:	0f b6 04 32          	movzbl (%edx,%esi,1),%eax
80100652:	85 c0                	test   %eax,%eax
80100654:	0f 84 ac 00 00 00    	je     80100706 <cprintf+0x109>
    if(c != '%'){
8010065a:	83 f8 25             	cmp    $0x25,%eax
8010065d:	75 e6                	jne    80100645 <cprintf+0x48>
    c = fmt[++i] & 0xff;
8010065f:	46                   	inc    %esi
80100660:	0f b6 1c 32          	movzbl (%edx,%esi,1),%ebx
    if(c == 0)
80100664:	85 db                	test   %ebx,%ebx
80100666:	0f 84 9a 00 00 00    	je     80100706 <cprintf+0x109>
    switch(c){
8010066c:	83 fb 70             	cmp    $0x70,%ebx
8010066f:	74 2e                	je     8010069f <cprintf+0xa2>
80100671:	7f 22                	jg     80100695 <cprintf+0x98>
80100673:	83 fb 25             	cmp    $0x25,%ebx
80100676:	74 69                	je     801006e1 <cprintf+0xe4>
80100678:	83 fb 64             	cmp    $0x64,%ebx
8010067b:	75 73                	jne    801006f0 <cprintf+0xf3>
      printint(*argp++, 10, 1);
8010067d:	8d 5f 04             	lea    0x4(%edi),%ebx
80100680:	8b 07                	mov    (%edi),%eax
80100682:	b9 01 00 00 00       	mov    $0x1,%ecx
80100687:	ba 0a 00 00 00       	mov    $0xa,%edx
8010068c:	e8 9d fe ff ff       	call   8010052e <printint>
80100691:	89 df                	mov    %ebx,%edi
      break;
80100693:	eb b5                	jmp    8010064a <cprintf+0x4d>
    switch(c){
80100695:	83 fb 73             	cmp    $0x73,%ebx
80100698:	74 1d                	je     801006b7 <cprintf+0xba>
8010069a:	83 fb 78             	cmp    $0x78,%ebx
8010069d:	75 51                	jne    801006f0 <cprintf+0xf3>
      printint(*argp++, 16, 0);
8010069f:	8d 5f 04             	lea    0x4(%edi),%ebx
801006a2:	8b 07                	mov    (%edi),%eax
801006a4:	b9 00 00 00 00       	mov    $0x0,%ecx
801006a9:	ba 10 00 00 00       	mov    $0x10,%edx
801006ae:	e8 7b fe ff ff       	call   8010052e <printint>
801006b3:	89 df                	mov    %ebx,%edi
      break;
801006b5:	eb 93                	jmp    8010064a <cprintf+0x4d>
      if((s = (char*)*argp++) == 0)
801006b7:	8d 47 04             	lea    0x4(%edi),%eax
801006ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006bd:	8b 1f                	mov    (%edi),%ebx
801006bf:	85 db                	test   %ebx,%ebx
801006c1:	75 05                	jne    801006c8 <cprintf+0xcb>
        s = "(null)";
801006c3:	bb 98 66 10 80       	mov    $0x80106698,%ebx
      for(; *s; s++)
801006c8:	8a 03                	mov    (%ebx),%al
801006ca:	84 c0                	test   %al,%al
801006cc:	74 0b                	je     801006d9 <cprintf+0xdc>
        consputc(*s);
801006ce:	0f be c0             	movsbl %al,%eax
801006d1:	e8 fd fd ff ff       	call   801004d3 <consputc>
      for(; *s; s++)
801006d6:	43                   	inc    %ebx
801006d7:	eb ef                	jmp    801006c8 <cprintf+0xcb>
      if((s = (char*)*argp++) == 0)
801006d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801006dc:	e9 69 ff ff ff       	jmp    8010064a <cprintf+0x4d>
      consputc('%');
801006e1:	b8 25 00 00 00       	mov    $0x25,%eax
801006e6:	e8 e8 fd ff ff       	call   801004d3 <consputc>
      break;
801006eb:	e9 5a ff ff ff       	jmp    8010064a <cprintf+0x4d>
      consputc('%');
801006f0:	b8 25 00 00 00       	mov    $0x25,%eax
801006f5:	e8 d9 fd ff ff       	call   801004d3 <consputc>
      consputc(c);
801006fa:	89 d8                	mov    %ebx,%eax
801006fc:	e8 d2 fd ff ff       	call   801004d3 <consputc>
      break;
80100701:	e9 44 ff ff ff       	jmp    8010064a <cprintf+0x4d>
  if(locking)
80100706:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010070a:	75 08                	jne    80100714 <cprintf+0x117>
}
8010070c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010070f:	5b                   	pop    %ebx
80100710:	5e                   	pop    %esi
80100711:	5f                   	pop    %edi
80100712:	5d                   	pop    %ebp
80100713:	c3                   	ret    
    release(&cons.lock);
80100714:	83 ec 0c             	sub    $0xc,%esp
80100717:	68 20 a5 10 80       	push   $0x8010a520
8010071c:	e8 94 35 00 00       	call   80103cb5 <release>
80100721:	83 c4 10             	add    $0x10,%esp
}
80100724:	eb e6                	jmp    8010070c <cprintf+0x10f>

80100726 <consoleintr>:
{
80100726:	f3 0f 1e fb          	endbr32 
8010072a:	55                   	push   %ebp
8010072b:	89 e5                	mov    %esp,%ebp
8010072d:	57                   	push   %edi
8010072e:	56                   	push   %esi
8010072f:	53                   	push   %ebx
80100730:	83 ec 18             	sub    $0x18,%esp
80100733:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
80100736:	68 20 a5 10 80       	push   $0x8010a520
8010073b:	e8 0c 35 00 00       	call   80103c4c <acquire>
  while((c = getc()) >= 0){
80100740:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100743:	be 00 00 00 00       	mov    $0x0,%esi
  while((c = getc()) >= 0){
80100748:	eb 13                	jmp    8010075d <consoleintr+0x37>
    switch(c){
8010074a:	83 ff 08             	cmp    $0x8,%edi
8010074d:	0f 84 d1 00 00 00    	je     80100824 <consoleintr+0xfe>
80100753:	83 ff 10             	cmp    $0x10,%edi
80100756:	75 25                	jne    8010077d <consoleintr+0x57>
80100758:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
8010075d:	ff d3                	call   *%ebx
8010075f:	89 c7                	mov    %eax,%edi
80100761:	85 c0                	test   %eax,%eax
80100763:	0f 88 eb 00 00 00    	js     80100854 <consoleintr+0x12e>
    switch(c){
80100769:	83 ff 15             	cmp    $0x15,%edi
8010076c:	0f 84 8d 00 00 00    	je     801007ff <consoleintr+0xd9>
80100772:	7e d6                	jle    8010074a <consoleintr+0x24>
80100774:	83 ff 7f             	cmp    $0x7f,%edi
80100777:	0f 84 a7 00 00 00    	je     80100824 <consoleintr+0xfe>
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010077d:	85 ff                	test   %edi,%edi
8010077f:	74 dc                	je     8010075d <consoleintr+0x37>
80100781:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100786:	89 c2                	mov    %eax,%edx
80100788:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
8010078e:	83 fa 7f             	cmp    $0x7f,%edx
80100791:	77 ca                	ja     8010075d <consoleintr+0x37>
        c = (c == '\r') ? '\n' : c;
80100793:	83 ff 0d             	cmp    $0xd,%edi
80100796:	0f 84 ae 00 00 00    	je     8010084a <consoleintr+0x124>
        input.buf[input.e++ % INPUT_BUF] = c;
8010079c:	8d 50 01             	lea    0x1(%eax),%edx
8010079f:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
801007a5:	83 e0 7f             	and    $0x7f,%eax
801007a8:	89 f9                	mov    %edi,%ecx
801007aa:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801007b0:	89 f8                	mov    %edi,%eax
801007b2:	e8 1c fd ff ff       	call   801004d3 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801007b7:	83 ff 0a             	cmp    $0xa,%edi
801007ba:	74 15                	je     801007d1 <consoleintr+0xab>
801007bc:	83 ff 04             	cmp    $0x4,%edi
801007bf:	74 10                	je     801007d1 <consoleintr+0xab>
801007c1:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801007c6:	83 e8 80             	sub    $0xffffff80,%eax
801007c9:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
801007cf:	75 8c                	jne    8010075d <consoleintr+0x37>
          input.w = input.e;
801007d1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007d6:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801007db:	83 ec 0c             	sub    $0xc,%esp
801007de:	68 a0 ff 10 80       	push   $0x8010ffa0
801007e3:	e8 a5 30 00 00       	call   8010388d <wakeup>
801007e8:	83 c4 10             	add    $0x10,%esp
801007eb:	e9 6d ff ff ff       	jmp    8010075d <consoleintr+0x37>
        input.e--;
801007f0:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801007f5:	b8 00 01 00 00       	mov    $0x100,%eax
801007fa:	e8 d4 fc ff ff       	call   801004d3 <consputc>
      while(input.e != input.w &&
801007ff:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100804:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010080a:	0f 84 4d ff ff ff    	je     8010075d <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100810:	48                   	dec    %eax
80100811:	89 c2                	mov    %eax,%edx
80100813:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100816:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010081d:	75 d1                	jne    801007f0 <consoleintr+0xca>
8010081f:	e9 39 ff ff ff       	jmp    8010075d <consoleintr+0x37>
      if(input.e != input.w){
80100824:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100829:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010082f:	0f 84 28 ff ff ff    	je     8010075d <consoleintr+0x37>
        input.e--;
80100835:	48                   	dec    %eax
80100836:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
8010083b:	b8 00 01 00 00       	mov    $0x100,%eax
80100840:	e8 8e fc ff ff       	call   801004d3 <consputc>
80100845:	e9 13 ff ff ff       	jmp    8010075d <consoleintr+0x37>
        c = (c == '\r') ? '\n' : c;
8010084a:	bf 0a 00 00 00       	mov    $0xa,%edi
8010084f:	e9 48 ff ff ff       	jmp    8010079c <consoleintr+0x76>
  release(&cons.lock);
80100854:	83 ec 0c             	sub    $0xc,%esp
80100857:	68 20 a5 10 80       	push   $0x8010a520
8010085c:	e8 54 34 00 00       	call   80103cb5 <release>
  if(doprocdump) {
80100861:	83 c4 10             	add    $0x10,%esp
80100864:	85 f6                	test   %esi,%esi
80100866:	75 08                	jne    80100870 <consoleintr+0x14a>
}
80100868:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010086b:	5b                   	pop    %ebx
8010086c:	5e                   	pop    %esi
8010086d:	5f                   	pop    %edi
8010086e:	5d                   	pop    %ebp
8010086f:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
80100870:	e8 bd 30 00 00       	call   80103932 <procdump>
}
80100875:	eb f1                	jmp    80100868 <consoleintr+0x142>

80100877 <consoleinit>:

void
consoleinit(void)
{
80100877:	f3 0f 1e fb          	endbr32 
8010087b:	55                   	push   %ebp
8010087c:	89 e5                	mov    %esp,%ebp
8010087e:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100881:	68 a8 66 10 80       	push   $0x801066a8
80100886:	68 20 a5 10 80       	push   $0x8010a520
8010088b:	e8 71 32 00 00       	call   80103b01 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100890:	c7 05 6c 09 11 80 9c 	movl   $0x8010059c,0x8011096c
80100897:	05 10 80 
  devsw[CONSOLE].read = consoleread;
8010089a:	c7 05 68 09 11 80 74 	movl   $0x80100274,0x80110968
801008a1:	02 10 80 
  cons.locking = 1;
801008a4:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801008ab:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801008ae:	83 c4 08             	add    $0x8,%esp
801008b1:	6a 00                	push   $0x0
801008b3:	6a 01                	push   $0x1
801008b5:	e8 eb 16 00 00       	call   80101fa5 <ioapicenable>
}
801008ba:	83 c4 10             	add    $0x10,%esp
801008bd:	c9                   	leave  
801008be:	c3                   	ret    

801008bf <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801008bf:	f3 0f 1e fb          	endbr32 
801008c3:	55                   	push   %ebp
801008c4:	89 e5                	mov    %esp,%ebp
801008c6:	57                   	push   %edi
801008c7:	56                   	push   %esi
801008c8:	53                   	push   %ebx
801008c9:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801008cf:	e8 7d 29 00 00       	call   80103251 <myproc>
801008d4:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
801008da:	e8 f4 1e 00 00       	call   801027d3 <begin_op>

  if((ip = namei(path)) == 0){
801008df:	83 ec 0c             	sub    $0xc,%esp
801008e2:	ff 75 08             	pushl  0x8(%ebp)
801008e5:	e8 28 13 00 00       	call   80101c12 <namei>
801008ea:	83 c4 10             	add    $0x10,%esp
801008ed:	85 c0                	test   %eax,%eax
801008ef:	74 56                	je     80100947 <exec+0x88>
801008f1:	89 c3                	mov    %eax,%ebx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801008f3:	83 ec 0c             	sub    $0xc,%esp
801008f6:	50                   	push   %eax
801008f7:	e8 8a 0c 00 00       	call   80101586 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801008fc:	6a 34                	push   $0x34
801008fe:	6a 00                	push   $0x0
80100900:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100906:	50                   	push   %eax
80100907:	53                   	push   %ebx
80100908:	e8 7a 0e 00 00       	call   80101787 <readi>
8010090d:	83 c4 20             	add    $0x20,%esp
80100910:	83 f8 34             	cmp    $0x34,%eax
80100913:	75 0c                	jne    80100921 <exec+0x62>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100915:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
8010091c:	45 4c 46 
8010091f:	74 42                	je     80100963 <exec+0xa4>
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir, 1);
  if(ip){
80100921:	85 db                	test   %ebx,%ebx
80100923:	0f 84 d0 02 00 00    	je     80100bf9 <exec+0x33a>
    iunlockput(ip);
80100929:	83 ec 0c             	sub    $0xc,%esp
8010092c:	53                   	push   %ebx
8010092d:	e8 03 0e 00 00       	call   80101735 <iunlockput>
    end_op();
80100932:	e8 1c 1f 00 00       	call   80102853 <end_op>
80100937:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
8010093a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010093f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100942:	5b                   	pop    %ebx
80100943:	5e                   	pop    %esi
80100944:	5f                   	pop    %edi
80100945:	5d                   	pop    %ebp
80100946:	c3                   	ret    
    end_op();
80100947:	e8 07 1f 00 00       	call   80102853 <end_op>
    cprintf("exec: fail\n");
8010094c:	83 ec 0c             	sub    $0xc,%esp
8010094f:	68 c1 66 10 80       	push   $0x801066c1
80100954:	e8 a4 fc ff ff       	call   801005fd <cprintf>
    return -1;
80100959:	83 c4 10             	add    $0x10,%esp
8010095c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100961:	eb dc                	jmp    8010093f <exec+0x80>
  if((pgdir = setupkvm()) == 0)
80100963:	e8 58 5a 00 00       	call   801063c0 <setupkvm>
80100968:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
8010096e:	85 c0                	test   %eax,%eax
80100970:	0f 84 14 01 00 00    	je     80100a8a <exec+0x1cb>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100976:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  sz = 0;
8010097c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100983:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100986:	be 00 00 00 00       	mov    $0x0,%esi
8010098b:	eb 04                	jmp    80100991 <exec+0xd2>
8010098d:	46                   	inc    %esi
8010098e:	8d 47 20             	lea    0x20(%edi),%eax
80100991:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
80100998:	39 f2                	cmp    %esi,%edx
8010099a:	0f 8e a1 00 00 00    	jle    80100a41 <exec+0x182>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801009a0:	89 c7                	mov    %eax,%edi
801009a2:	6a 20                	push   $0x20
801009a4:	50                   	push   %eax
801009a5:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801009ab:	50                   	push   %eax
801009ac:	53                   	push   %ebx
801009ad:	e8 d5 0d 00 00       	call   80101787 <readi>
801009b2:	83 c4 10             	add    $0x10,%esp
801009b5:	83 f8 20             	cmp    $0x20,%eax
801009b8:	0f 85 cc 00 00 00    	jne    80100a8a <exec+0x1cb>
    if(ph.type != ELF_PROG_LOAD || ph.memsz == 0)
801009be:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801009c5:	75 c6                	jne    8010098d <exec+0xce>
801009c7:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801009cd:	85 c0                	test   %eax,%eax
801009cf:	74 bc                	je     8010098d <exec+0xce>
    if(ph.memsz < ph.filesz)
801009d1:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801009d7:	0f 82 ad 00 00 00    	jb     80100a8a <exec+0x1cb>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801009dd:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801009e3:	0f 82 a1 00 00 00    	jb     80100a8a <exec+0x1cb>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801009e9:	83 ec 04             	sub    $0x4,%esp
801009ec:	50                   	push   %eax
801009ed:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
801009f3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
801009f9:	e8 5b 58 00 00       	call   80106259 <allocuvm>
801009fe:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a04:	83 c4 10             	add    $0x10,%esp
80100a07:	85 c0                	test   %eax,%eax
80100a09:	74 7f                	je     80100a8a <exec+0x1cb>
    if(ph.vaddr % PGSIZE != 0)
80100a0b:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a11:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a16:	75 72                	jne    80100a8a <exec+0x1cb>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a18:	83 ec 0c             	sub    $0xc,%esp
80100a1b:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100a21:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100a27:	53                   	push   %ebx
80100a28:	50                   	push   %eax
80100a29:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100a2f:	e8 f3 56 00 00       	call   80106127 <loaduvm>
80100a34:	83 c4 20             	add    $0x20,%esp
80100a37:	85 c0                	test   %eax,%eax
80100a39:	0f 89 4e ff ff ff    	jns    8010098d <exec+0xce>
80100a3f:	eb 49                	jmp    80100a8a <exec+0x1cb>
  iunlockput(ip);
80100a41:	83 ec 0c             	sub    $0xc,%esp
80100a44:	53                   	push   %ebx
80100a45:	e8 eb 0c 00 00       	call   80101735 <iunlockput>
  end_op();
80100a4a:	e8 04 1e 00 00       	call   80102853 <end_op>
  sz = PGROUNDUP(sz);
80100a4f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100a55:	05 ff 0f 00 00       	add    $0xfff,%eax
80100a5a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100a5f:	83 c4 0c             	add    $0xc,%esp
80100a62:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100a68:	52                   	push   %edx
80100a69:	50                   	push   %eax
80100a6a:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100a70:	56                   	push   %esi
80100a71:	e8 e3 57 00 00       	call   80106259 <allocuvm>
80100a76:	89 c7                	mov    %eax,%edi
80100a78:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a7e:	83 c4 10             	add    $0x10,%esp
80100a81:	85 c0                	test   %eax,%eax
80100a83:	75 26                	jne    80100aab <exec+0x1ec>
  ip = 0;
80100a85:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(pgdir)
80100a8a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100a90:	85 c0                	test   %eax,%eax
80100a92:	0f 84 89 fe ff ff    	je     80100921 <exec+0x62>
    freevm(pgdir, 1);
80100a98:	83 ec 08             	sub    $0x8,%esp
80100a9b:	6a 01                	push   $0x1
80100a9d:	50                   	push   %eax
80100a9e:	e8 a3 58 00 00       	call   80106346 <freevm>
80100aa3:	83 c4 10             	add    $0x10,%esp
80100aa6:	e9 76 fe ff ff       	jmp    80100921 <exec+0x62>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100aab:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100ab1:	83 ec 08             	sub    $0x8,%esp
80100ab4:	50                   	push   %eax
80100ab5:	56                   	push   %esi
80100ab6:	e8 94 59 00 00       	call   8010644f <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100abb:	83 c4 10             	add    $0x10,%esp
80100abe:	be 00 00 00 00       	mov    $0x0,%esi
80100ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ac6:	8d 1c b0             	lea    (%eax,%esi,4),%ebx
80100ac9:	8b 03                	mov    (%ebx),%eax
80100acb:	85 c0                	test   %eax,%eax
80100acd:	74 47                	je     80100b16 <exec+0x257>
    if(argc >= MAXARG)
80100acf:	83 fe 1f             	cmp    $0x1f,%esi
80100ad2:	0f 87 0d 01 00 00    	ja     80100be5 <exec+0x326>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ad8:	83 ec 0c             	sub    $0xc,%esp
80100adb:	50                   	push   %eax
80100adc:	e8 c7 33 00 00       	call   80103ea8 <strlen>
80100ae1:	29 c7                	sub    %eax,%edi
80100ae3:	4f                   	dec    %edi
80100ae4:	83 e7 fc             	and    $0xfffffffc,%edi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ae7:	83 c4 04             	add    $0x4,%esp
80100aea:	ff 33                	pushl  (%ebx)
80100aec:	e8 b7 33 00 00       	call   80103ea8 <strlen>
80100af1:	40                   	inc    %eax
80100af2:	50                   	push   %eax
80100af3:	ff 33                	pushl  (%ebx)
80100af5:	57                   	push   %edi
80100af6:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100afc:	e8 aa 5a 00 00       	call   801065ab <copyout>
80100b01:	83 c4 20             	add    $0x20,%esp
80100b04:	85 c0                	test   %eax,%eax
80100b06:	0f 88 e3 00 00 00    	js     80100bef <exec+0x330>
    ustack[3+argc] = sp;
80100b0c:	89 bc b5 64 ff ff ff 	mov    %edi,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100b13:	46                   	inc    %esi
80100b14:	eb ad                	jmp    80100ac3 <exec+0x204>
80100b16:	89 f9                	mov    %edi,%ecx
80100b18:	89 c3                	mov    %eax,%ebx
  ustack[3+argc] = 0;
80100b1a:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100b21:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100b25:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100b2c:	ff ff ff 
  ustack[1] = argc;
80100b2f:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b35:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100b3c:	89 fa                	mov    %edi,%edx
80100b3e:	29 c2                	sub    %eax,%edx
80100b40:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100b46:	8d 04 b5 10 00 00 00 	lea    0x10(,%esi,4),%eax
80100b4d:	29 c1                	sub    %eax,%ecx
80100b4f:	89 ce                	mov    %ecx,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100b51:	50                   	push   %eax
80100b52:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100b58:	50                   	push   %eax
80100b59:	51                   	push   %ecx
80100b5a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b60:	e8 46 5a 00 00       	call   801065ab <copyout>
80100b65:	83 c4 10             	add    $0x10,%esp
80100b68:	85 c0                	test   %eax,%eax
80100b6a:	0f 88 1a ff ff ff    	js     80100a8a <exec+0x1cb>
  for(last=s=path; *s; s++)
80100b70:	8b 55 08             	mov    0x8(%ebp),%edx
80100b73:	89 d0                	mov    %edx,%eax
80100b75:	eb 01                	jmp    80100b78 <exec+0x2b9>
80100b77:	40                   	inc    %eax
80100b78:	8a 08                	mov    (%eax),%cl
80100b7a:	84 c9                	test   %cl,%cl
80100b7c:	74 0a                	je     80100b88 <exec+0x2c9>
    if(*s == '/')
80100b7e:	80 f9 2f             	cmp    $0x2f,%cl
80100b81:	75 f4                	jne    80100b77 <exec+0x2b8>
      last = s+1;
80100b83:	8d 50 01             	lea    0x1(%eax),%edx
80100b86:	eb ef                	jmp    80100b77 <exec+0x2b8>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100b88:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100b8e:	89 f8                	mov    %edi,%eax
80100b90:	83 c0 6c             	add    $0x6c,%eax
80100b93:	83 ec 04             	sub    $0x4,%esp
80100b96:	6a 10                	push   $0x10
80100b98:	52                   	push   %edx
80100b99:	50                   	push   %eax
80100b9a:	e8 cd 32 00 00       	call   80103e6c <safestrcpy>
  oldpgdir = curproc->pgdir;
80100b9f:	8b 5f 04             	mov    0x4(%edi),%ebx
  curproc->pgdir = pgdir;
80100ba2:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100ba8:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100bab:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100bb1:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100bb3:	8b 47 18             	mov    0x18(%edi),%eax
80100bb6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100bbc:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100bbf:	8b 47 18             	mov    0x18(%edi),%eax
80100bc2:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100bc5:	89 3c 24             	mov    %edi,(%esp)
80100bc8:	e8 d4 53 00 00       	call   80105fa1 <switchuvm>
  freevm(oldpgdir, 1);
80100bcd:	83 c4 08             	add    $0x8,%esp
80100bd0:	6a 01                	push   $0x1
80100bd2:	53                   	push   %ebx
80100bd3:	e8 6e 57 00 00       	call   80106346 <freevm>
  return 0;
80100bd8:	83 c4 10             	add    $0x10,%esp
80100bdb:	b8 00 00 00 00       	mov    $0x0,%eax
80100be0:	e9 5a fd ff ff       	jmp    8010093f <exec+0x80>
  ip = 0;
80100be5:	bb 00 00 00 00       	mov    $0x0,%ebx
80100bea:	e9 9b fe ff ff       	jmp    80100a8a <exec+0x1cb>
80100bef:	bb 00 00 00 00       	mov    $0x0,%ebx
80100bf4:	e9 91 fe ff ff       	jmp    80100a8a <exec+0x1cb>
  return -1;
80100bf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bfe:	e9 3c fd ff ff       	jmp    8010093f <exec+0x80>

80100c03 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c03:	f3 0f 1e fb          	endbr32 
80100c07:	55                   	push   %ebp
80100c08:	89 e5                	mov    %esp,%ebp
80100c0a:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c0d:	68 cd 66 10 80       	push   $0x801066cd
80100c12:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c17:	e8 e5 2e 00 00       	call   80103b01 <initlock>
}
80100c1c:	83 c4 10             	add    $0x10,%esp
80100c1f:	c9                   	leave  
80100c20:	c3                   	ret    

80100c21 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c21:	f3 0f 1e fb          	endbr32 
80100c25:	55                   	push   %ebp
80100c26:	89 e5                	mov    %esp,%ebp
80100c28:	53                   	push   %ebx
80100c29:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100c2c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c31:	e8 16 30 00 00       	call   80103c4c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c36:	83 c4 10             	add    $0x10,%esp
80100c39:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
80100c3e:	eb 03                	jmp    80100c43 <filealloc+0x22>
80100c40:	83 c3 18             	add    $0x18,%ebx
80100c43:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100c49:	73 24                	jae    80100c6f <filealloc+0x4e>
    if(f->ref == 0){
80100c4b:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100c4f:	75 ef                	jne    80100c40 <filealloc+0x1f>
      f->ref = 1;
80100c51:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100c58:	83 ec 0c             	sub    $0xc,%esp
80100c5b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c60:	e8 50 30 00 00       	call   80103cb5 <release>
      return f;
80100c65:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100c68:	89 d8                	mov    %ebx,%eax
80100c6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c6d:	c9                   	leave  
80100c6e:	c3                   	ret    
  release(&ftable.lock);
80100c6f:	83 ec 0c             	sub    $0xc,%esp
80100c72:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c77:	e8 39 30 00 00       	call   80103cb5 <release>
  return 0;
80100c7c:	83 c4 10             	add    $0x10,%esp
80100c7f:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c84:	eb e2                	jmp    80100c68 <filealloc+0x47>

80100c86 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100c86:	f3 0f 1e fb          	endbr32 
80100c8a:	55                   	push   %ebp
80100c8b:	89 e5                	mov    %esp,%ebp
80100c8d:	53                   	push   %ebx
80100c8e:	83 ec 10             	sub    $0x10,%esp
80100c91:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100c94:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c99:	e8 ae 2f 00 00       	call   80103c4c <acquire>
  if(f->ref < 1)
80100c9e:	8b 43 04             	mov    0x4(%ebx),%eax
80100ca1:	83 c4 10             	add    $0x10,%esp
80100ca4:	85 c0                	test   %eax,%eax
80100ca6:	7e 18                	jle    80100cc0 <filedup+0x3a>
    panic("filedup");
  f->ref++;
80100ca8:	40                   	inc    %eax
80100ca9:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100cac:	83 ec 0c             	sub    $0xc,%esp
80100caf:	68 c0 ff 10 80       	push   $0x8010ffc0
80100cb4:	e8 fc 2f 00 00       	call   80103cb5 <release>
  return f;
}
80100cb9:	89 d8                	mov    %ebx,%eax
80100cbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cbe:	c9                   	leave  
80100cbf:	c3                   	ret    
    panic("filedup");
80100cc0:	83 ec 0c             	sub    $0xc,%esp
80100cc3:	68 d4 66 10 80       	push   $0x801066d4
80100cc8:	e8 88 f6 ff ff       	call   80100355 <panic>

80100ccd <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ccd:	f3 0f 1e fb          	endbr32 
80100cd1:	55                   	push   %ebp
80100cd2:	89 e5                	mov    %esp,%ebp
80100cd4:	57                   	push   %edi
80100cd5:	56                   	push   %esi
80100cd6:	53                   	push   %ebx
80100cd7:	83 ec 38             	sub    $0x38,%esp
80100cda:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100cdd:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ce2:	e8 65 2f 00 00       	call   80103c4c <acquire>
  if(f->ref < 1)
80100ce7:	8b 43 04             	mov    0x4(%ebx),%eax
80100cea:	83 c4 10             	add    $0x10,%esp
80100ced:	85 c0                	test   %eax,%eax
80100cef:	7e 58                	jle    80100d49 <fileclose+0x7c>
    panic("fileclose");
  if(--f->ref > 0){
80100cf1:	48                   	dec    %eax
80100cf2:	89 43 04             	mov    %eax,0x4(%ebx)
80100cf5:	85 c0                	test   %eax,%eax
80100cf7:	7f 5d                	jg     80100d56 <fileclose+0x89>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100cf9:	8d 7d d0             	lea    -0x30(%ebp),%edi
80100cfc:	b9 06 00 00 00       	mov    $0x6,%ecx
80100d01:	89 de                	mov    %ebx,%esi
80100d03:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
80100d05:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100d0c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100d12:	83 ec 0c             	sub    $0xc,%esp
80100d15:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d1a:	e8 96 2f 00 00       	call   80103cb5 <release>

  if(ff.type == FD_PIPE)
80100d1f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100d22:	83 c4 10             	add    $0x10,%esp
80100d25:	83 f8 01             	cmp    $0x1,%eax
80100d28:	74 44                	je     80100d6e <fileclose+0xa1>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100d2a:	83 f8 02             	cmp    $0x2,%eax
80100d2d:	75 37                	jne    80100d66 <fileclose+0x99>
    begin_op();
80100d2f:	e8 9f 1a 00 00       	call   801027d3 <begin_op>
    iput(ff.ip);
80100d34:	83 ec 0c             	sub    $0xc,%esp
80100d37:	ff 75 e0             	pushl  -0x20(%ebp)
80100d3a:	e8 54 09 00 00       	call   80101693 <iput>
    end_op();
80100d3f:	e8 0f 1b 00 00       	call   80102853 <end_op>
80100d44:	83 c4 10             	add    $0x10,%esp
80100d47:	eb 1d                	jmp    80100d66 <fileclose+0x99>
    panic("fileclose");
80100d49:	83 ec 0c             	sub    $0xc,%esp
80100d4c:	68 dc 66 10 80       	push   $0x801066dc
80100d51:	e8 ff f5 ff ff       	call   80100355 <panic>
    release(&ftable.lock);
80100d56:	83 ec 0c             	sub    $0xc,%esp
80100d59:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d5e:	e8 52 2f 00 00       	call   80103cb5 <release>
    return;
80100d63:	83 c4 10             	add    $0x10,%esp
  }
}
80100d66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d69:	5b                   	pop    %ebx
80100d6a:	5e                   	pop    %esi
80100d6b:	5f                   	pop    %edi
80100d6c:	5d                   	pop    %ebp
80100d6d:	c3                   	ret    
    pipeclose(ff.pipe, ff.writable);
80100d6e:	83 ec 08             	sub    $0x8,%esp
80100d71:	0f be 45 d9          	movsbl -0x27(%ebp),%eax
80100d75:	50                   	push   %eax
80100d76:	ff 75 dc             	pushl  -0x24(%ebp)
80100d79:	e8 d6 20 00 00       	call   80102e54 <pipeclose>
80100d7e:	83 c4 10             	add    $0x10,%esp
80100d81:	eb e3                	jmp    80100d66 <fileclose+0x99>

80100d83 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100d83:	f3 0f 1e fb          	endbr32 
80100d87:	55                   	push   %ebp
80100d88:	89 e5                	mov    %esp,%ebp
80100d8a:	53                   	push   %ebx
80100d8b:	83 ec 04             	sub    $0x4,%esp
80100d8e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100d91:	83 3b 02             	cmpl   $0x2,(%ebx)
80100d94:	75 31                	jne    80100dc7 <filestat+0x44>
    ilock(f->ip);
80100d96:	83 ec 0c             	sub    $0xc,%esp
80100d99:	ff 73 10             	pushl  0x10(%ebx)
80100d9c:	e8 e5 07 00 00       	call   80101586 <ilock>
    stati(f->ip, st);
80100da1:	83 c4 08             	add    $0x8,%esp
80100da4:	ff 75 0c             	pushl  0xc(%ebp)
80100da7:	ff 73 10             	pushl  0x10(%ebx)
80100daa:	e8 aa 09 00 00       	call   80101759 <stati>
    iunlock(f->ip);
80100daf:	83 c4 04             	add    $0x4,%esp
80100db2:	ff 73 10             	pushl  0x10(%ebx)
80100db5:	e8 90 08 00 00       	call   8010164a <iunlock>
    return 0;
80100dba:	83 c4 10             	add    $0x10,%esp
80100dbd:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100dc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dc5:	c9                   	leave  
80100dc6:	c3                   	ret    
  return -1;
80100dc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dcc:	eb f4                	jmp    80100dc2 <filestat+0x3f>

80100dce <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100dce:	f3 0f 1e fb          	endbr32 
80100dd2:	55                   	push   %ebp
80100dd3:	89 e5                	mov    %esp,%ebp
80100dd5:	56                   	push   %esi
80100dd6:	53                   	push   %ebx
80100dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100dda:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100dde:	74 70                	je     80100e50 <fileread+0x82>
    return -1;
  if(f->type == FD_PIPE)
80100de0:	8b 03                	mov    (%ebx),%eax
80100de2:	83 f8 01             	cmp    $0x1,%eax
80100de5:	74 44                	je     80100e2b <fileread+0x5d>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100de7:	83 f8 02             	cmp    $0x2,%eax
80100dea:	75 57                	jne    80100e43 <fileread+0x75>
    ilock(f->ip);
80100dec:	83 ec 0c             	sub    $0xc,%esp
80100def:	ff 73 10             	pushl  0x10(%ebx)
80100df2:	e8 8f 07 00 00       	call   80101586 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100df7:	ff 75 10             	pushl  0x10(%ebp)
80100dfa:	ff 73 14             	pushl  0x14(%ebx)
80100dfd:	ff 75 0c             	pushl  0xc(%ebp)
80100e00:	ff 73 10             	pushl  0x10(%ebx)
80100e03:	e8 7f 09 00 00       	call   80101787 <readi>
80100e08:	89 c6                	mov    %eax,%esi
80100e0a:	83 c4 20             	add    $0x20,%esp
80100e0d:	85 c0                	test   %eax,%eax
80100e0f:	7e 03                	jle    80100e14 <fileread+0x46>
      f->off += r;
80100e11:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100e14:	83 ec 0c             	sub    $0xc,%esp
80100e17:	ff 73 10             	pushl  0x10(%ebx)
80100e1a:	e8 2b 08 00 00       	call   8010164a <iunlock>
    return r;
80100e1f:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100e22:	89 f0                	mov    %esi,%eax
80100e24:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100e27:	5b                   	pop    %ebx
80100e28:	5e                   	pop    %esi
80100e29:	5d                   	pop    %ebp
80100e2a:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100e2b:	83 ec 04             	sub    $0x4,%esp
80100e2e:	ff 75 10             	pushl  0x10(%ebp)
80100e31:	ff 75 0c             	pushl  0xc(%ebp)
80100e34:	ff 73 0c             	pushl  0xc(%ebx)
80100e37:	e8 72 21 00 00       	call   80102fae <piperead>
80100e3c:	89 c6                	mov    %eax,%esi
80100e3e:	83 c4 10             	add    $0x10,%esp
80100e41:	eb df                	jmp    80100e22 <fileread+0x54>
  panic("fileread");
80100e43:	83 ec 0c             	sub    $0xc,%esp
80100e46:	68 e6 66 10 80       	push   $0x801066e6
80100e4b:	e8 05 f5 ff ff       	call   80100355 <panic>
    return -1;
80100e50:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100e55:	eb cb                	jmp    80100e22 <fileread+0x54>

80100e57 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100e57:	f3 0f 1e fb          	endbr32 
80100e5b:	55                   	push   %ebp
80100e5c:	89 e5                	mov    %esp,%ebp
80100e5e:	57                   	push   %edi
80100e5f:	56                   	push   %esi
80100e60:	53                   	push   %ebx
80100e61:	83 ec 1c             	sub    $0x1c,%esp
80100e64:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100e67:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100e6b:	0f 84 cc 00 00 00    	je     80100f3d <filewrite+0xe6>
    return -1;
  if(f->type == FD_PIPE)
80100e71:	8b 06                	mov    (%esi),%eax
80100e73:	83 f8 01             	cmp    $0x1,%eax
80100e76:	74 10                	je     80100e88 <filewrite+0x31>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e78:	83 f8 02             	cmp    $0x2,%eax
80100e7b:	0f 85 af 00 00 00    	jne    80100f30 <filewrite+0xd9>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100e81:	bf 00 00 00 00       	mov    $0x0,%edi
80100e86:	eb 67                	jmp    80100eef <filewrite+0x98>
    return pipewrite(f->pipe, addr, n);
80100e88:	83 ec 04             	sub    $0x4,%esp
80100e8b:	ff 75 10             	pushl  0x10(%ebp)
80100e8e:	ff 75 0c             	pushl  0xc(%ebp)
80100e91:	ff 76 0c             	pushl  0xc(%esi)
80100e94:	e8 4b 20 00 00       	call   80102ee4 <pipewrite>
80100e99:	83 c4 10             	add    $0x10,%esp
80100e9c:	e9 82 00 00 00       	jmp    80100f23 <filewrite+0xcc>
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
80100ea1:	e8 2d 19 00 00       	call   801027d3 <begin_op>
      ilock(f->ip);
80100ea6:	83 ec 0c             	sub    $0xc,%esp
80100ea9:	ff 76 10             	pushl  0x10(%esi)
80100eac:	e8 d5 06 00 00       	call   80101586 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100eb1:	ff 75 e4             	pushl  -0x1c(%ebp)
80100eb4:	ff 76 14             	pushl  0x14(%esi)
80100eb7:	89 f8                	mov    %edi,%eax
80100eb9:	03 45 0c             	add    0xc(%ebp),%eax
80100ebc:	50                   	push   %eax
80100ebd:	ff 76 10             	pushl  0x10(%esi)
80100ec0:	e8 c6 09 00 00       	call   8010188b <writei>
80100ec5:	89 c3                	mov    %eax,%ebx
80100ec7:	83 c4 20             	add    $0x20,%esp
80100eca:	85 c0                	test   %eax,%eax
80100ecc:	7e 03                	jle    80100ed1 <filewrite+0x7a>
        f->off += r;
80100ece:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100ed1:	83 ec 0c             	sub    $0xc,%esp
80100ed4:	ff 76 10             	pushl  0x10(%esi)
80100ed7:	e8 6e 07 00 00       	call   8010164a <iunlock>
      end_op();
80100edc:	e8 72 19 00 00       	call   80102853 <end_op>

      if(r < 0)
80100ee1:	83 c4 10             	add    $0x10,%esp
80100ee4:	85 db                	test   %ebx,%ebx
80100ee6:	78 31                	js     80100f19 <filewrite+0xc2>
        break;
      if(r != n1)
80100ee8:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100eeb:	75 1f                	jne    80100f0c <filewrite+0xb5>
        panic("short filewrite");
      i += r;
80100eed:	01 df                	add    %ebx,%edi
    while(i < n){
80100eef:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100ef2:	7d 25                	jge    80100f19 <filewrite+0xc2>
      int n1 = n - i;
80100ef4:	8b 45 10             	mov    0x10(%ebp),%eax
80100ef7:	29 f8                	sub    %edi,%eax
80100ef9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(n1 > max)
80100efc:	3d 00 06 00 00       	cmp    $0x600,%eax
80100f01:	7e 9e                	jle    80100ea1 <filewrite+0x4a>
        n1 = max;
80100f03:	c7 45 e4 00 06 00 00 	movl   $0x600,-0x1c(%ebp)
80100f0a:	eb 95                	jmp    80100ea1 <filewrite+0x4a>
        panic("short filewrite");
80100f0c:	83 ec 0c             	sub    $0xc,%esp
80100f0f:	68 ef 66 10 80       	push   $0x801066ef
80100f14:	e8 3c f4 ff ff       	call   80100355 <panic>
    }
    return i == n ? n : -1;
80100f19:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100f1c:	74 0d                	je     80100f2b <filewrite+0xd4>
80100f1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80100f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f26:	5b                   	pop    %ebx
80100f27:	5e                   	pop    %esi
80100f28:	5f                   	pop    %edi
80100f29:	5d                   	pop    %ebp
80100f2a:	c3                   	ret    
    return i == n ? n : -1;
80100f2b:	8b 45 10             	mov    0x10(%ebp),%eax
80100f2e:	eb f3                	jmp    80100f23 <filewrite+0xcc>
  panic("filewrite");
80100f30:	83 ec 0c             	sub    $0xc,%esp
80100f33:	68 f5 66 10 80       	push   $0x801066f5
80100f38:	e8 18 f4 ff ff       	call   80100355 <panic>
    return -1;
80100f3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f42:	eb df                	jmp    80100f23 <filewrite+0xcc>

80100f44 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80100f44:	55                   	push   %ebp
80100f45:	89 e5                	mov    %esp,%ebp
80100f47:	57                   	push   %edi
80100f48:	56                   	push   %esi
80100f49:	53                   	push   %ebx
80100f4a:	83 ec 0c             	sub    $0xc,%esp
80100f4d:	89 d6                	mov    %edx,%esi
  char *s;
  int len;

  while(*path == '/')
80100f4f:	8a 10                	mov    (%eax),%dl
80100f51:	80 fa 2f             	cmp    $0x2f,%dl
80100f54:	75 03                	jne    80100f59 <skipelem+0x15>
    path++;
80100f56:	40                   	inc    %eax
80100f57:	eb f6                	jmp    80100f4f <skipelem+0xb>
  if(*path == 0)
80100f59:	84 d2                	test   %dl,%dl
80100f5b:	74 4e                	je     80100fab <skipelem+0x67>
80100f5d:	89 c3                	mov    %eax,%ebx
80100f5f:	eb 01                	jmp    80100f62 <skipelem+0x1e>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80100f61:	43                   	inc    %ebx
  while(*path != '/' && *path != 0)
80100f62:	8a 13                	mov    (%ebx),%dl
80100f64:	80 fa 2f             	cmp    $0x2f,%dl
80100f67:	74 04                	je     80100f6d <skipelem+0x29>
80100f69:	84 d2                	test   %dl,%dl
80100f6b:	75 f4                	jne    80100f61 <skipelem+0x1d>
  len = path - s;
80100f6d:	89 df                	mov    %ebx,%edi
80100f6f:	29 c7                	sub    %eax,%edi
  if(len >= DIRSIZ)
80100f71:	83 ff 0d             	cmp    $0xd,%edi
80100f74:	7e 11                	jle    80100f87 <skipelem+0x43>
    memmove(name, s, DIRSIZ);
80100f76:	83 ec 04             	sub    $0x4,%esp
80100f79:	6a 0e                	push   $0xe
80100f7b:	50                   	push   %eax
80100f7c:	56                   	push   %esi
80100f7d:	e8 fc 2d 00 00       	call   80103d7e <memmove>
80100f82:	83 c4 10             	add    $0x10,%esp
80100f85:	eb 15                	jmp    80100f9c <skipelem+0x58>
  else {
    memmove(name, s, len);
80100f87:	83 ec 04             	sub    $0x4,%esp
80100f8a:	57                   	push   %edi
80100f8b:	50                   	push   %eax
80100f8c:	56                   	push   %esi
80100f8d:	e8 ec 2d 00 00       	call   80103d7e <memmove>
    name[len] = 0;
80100f92:	c6 04 3e 00          	movb   $0x0,(%esi,%edi,1)
80100f96:	83 c4 10             	add    $0x10,%esp
80100f99:	eb 01                	jmp    80100f9c <skipelem+0x58>
  }
  while(*path == '/')
    path++;
80100f9b:	43                   	inc    %ebx
  while(*path == '/')
80100f9c:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80100f9f:	74 fa                	je     80100f9b <skipelem+0x57>
  return path;
}
80100fa1:	89 d8                	mov    %ebx,%eax
80100fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa6:	5b                   	pop    %ebx
80100fa7:	5e                   	pop    %esi
80100fa8:	5f                   	pop    %edi
80100fa9:	5d                   	pop    %ebp
80100faa:	c3                   	ret    
    return 0;
80100fab:	bb 00 00 00 00       	mov    $0x0,%ebx
80100fb0:	eb ef                	jmp    80100fa1 <skipelem+0x5d>

80100fb2 <bzero>:
{
80100fb2:	55                   	push   %ebp
80100fb3:	89 e5                	mov    %esp,%ebp
80100fb5:	53                   	push   %ebx
80100fb6:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, bno);
80100fb9:	52                   	push   %edx
80100fba:	50                   	push   %eax
80100fbb:	e8 ae f1 ff ff       	call   8010016e <bread>
80100fc0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80100fc2:	8d 40 5c             	lea    0x5c(%eax),%eax
80100fc5:	83 c4 0c             	add    $0xc,%esp
80100fc8:	68 00 02 00 00       	push   $0x200
80100fcd:	6a 00                	push   $0x0
80100fcf:	50                   	push   %eax
80100fd0:	e8 2b 2d 00 00       	call   80103d00 <memset>
  log_write(bp);
80100fd5:	89 1c 24             	mov    %ebx,(%esp)
80100fd8:	e8 27 19 00 00       	call   80102904 <log_write>
  brelse(bp);
80100fdd:	89 1c 24             	mov    %ebx,(%esp)
80100fe0:	e8 fa f1 ff ff       	call   801001df <brelse>
}
80100fe5:	83 c4 10             	add    $0x10,%esp
80100fe8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100feb:	c9                   	leave  
80100fec:	c3                   	ret    

80100fed <balloc>:
{
80100fed:	55                   	push   %ebp
80100fee:	89 e5                	mov    %esp,%ebp
80100ff0:	57                   	push   %edi
80100ff1:	56                   	push   %esi
80100ff2:	53                   	push   %ebx
80100ff3:	83 ec 1c             	sub    $0x1c,%esp
80100ff6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80100ff9:	bf 00 00 00 00       	mov    $0x0,%edi
80100ffe:	eb 6d                	jmp    8010106d <balloc+0x80>
    bp = bread(dev, BBLOCK(b, sb));
80101000:	8d 87 ff 0f 00 00    	lea    0xfff(%edi),%eax
80101006:	eb 73                	jmp    8010107b <balloc+0x8e>
      m = 1 << (bi % 8);
80101008:	49                   	dec    %ecx
80101009:	83 c9 f8             	or     $0xfffffff8,%ecx
8010100c:	41                   	inc    %ecx
8010100d:	eb 38                	jmp    80101047 <balloc+0x5a>
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010100f:	c1 f9 03             	sar    $0x3,%ecx
80101012:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80101015:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101018:	8a 4c 0e 5c          	mov    0x5c(%esi,%ecx,1),%cl
8010101c:	0f b6 f1             	movzbl %cl,%esi
8010101f:	85 d6                	test   %edx,%esi
80101021:	0f 84 83 00 00 00    	je     801010aa <balloc+0xbd>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101027:	40                   	inc    %eax
80101028:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010102d:	7f 2a                	jg     80101059 <balloc+0x6c>
8010102f:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
80101032:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80101035:	3b 1d c0 09 11 80    	cmp    0x801109c0,%ebx
8010103b:	73 1c                	jae    80101059 <balloc+0x6c>
      m = 1 << (bi % 8);
8010103d:	89 c1                	mov    %eax,%ecx
8010103f:	81 e1 07 00 00 80    	and    $0x80000007,%ecx
80101045:	78 c1                	js     80101008 <balloc+0x1b>
80101047:	ba 01 00 00 00       	mov    $0x1,%edx
8010104c:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010104e:	89 c1                	mov    %eax,%ecx
80101050:	85 c0                	test   %eax,%eax
80101052:	79 bb                	jns    8010100f <balloc+0x22>
80101054:	8d 48 07             	lea    0x7(%eax),%ecx
80101057:	eb b6                	jmp    8010100f <balloc+0x22>
    brelse(bp);
80101059:	83 ec 0c             	sub    $0xc,%esp
8010105c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010105f:	e8 7b f1 ff ff       	call   801001df <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101064:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010106a:	83 c4 10             	add    $0x10,%esp
8010106d:	39 3d c0 09 11 80    	cmp    %edi,0x801109c0
80101073:	76 28                	jbe    8010109d <balloc+0xb0>
    bp = bread(dev, BBLOCK(b, sb));
80101075:	89 f8                	mov    %edi,%eax
80101077:	85 ff                	test   %edi,%edi
80101079:	78 85                	js     80101000 <balloc+0x13>
8010107b:	c1 f8 0c             	sar    $0xc,%eax
8010107e:	83 ec 08             	sub    $0x8,%esp
80101081:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101087:	50                   	push   %eax
80101088:	ff 75 d8             	pushl  -0x28(%ebp)
8010108b:	e8 de f0 ff ff       	call   8010016e <bread>
80101090:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101093:	83 c4 10             	add    $0x10,%esp
80101096:	b8 00 00 00 00       	mov    $0x0,%eax
8010109b:	eb 8b                	jmp    80101028 <balloc+0x3b>
  panic("balloc: out of blocks");
8010109d:	83 ec 0c             	sub    $0xc,%esp
801010a0:	68 ff 66 10 80       	push   $0x801066ff
801010a5:	e8 ab f2 ff ff       	call   80100355 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
801010aa:	09 ca                	or     %ecx,%edx
801010ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010af:	8b 7d dc             	mov    -0x24(%ebp),%edi
801010b2:	88 54 38 5c          	mov    %dl,0x5c(%eax,%edi,1)
        log_write(bp);
801010b6:	83 ec 0c             	sub    $0xc,%esp
801010b9:	89 c7                	mov    %eax,%edi
801010bb:	50                   	push   %eax
801010bc:	e8 43 18 00 00       	call   80102904 <log_write>
        brelse(bp);
801010c1:	89 3c 24             	mov    %edi,(%esp)
801010c4:	e8 16 f1 ff ff       	call   801001df <brelse>
        bzero(dev, b + bi);
801010c9:	89 da                	mov    %ebx,%edx
801010cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
801010ce:	e8 df fe ff ff       	call   80100fb2 <bzero>
}
801010d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d9:	5b                   	pop    %ebx
801010da:	5e                   	pop    %esi
801010db:	5f                   	pop    %edi
801010dc:	5d                   	pop    %ebp
801010dd:	c3                   	ret    

801010de <bmap>:
{
801010de:	55                   	push   %ebp
801010df:	89 e5                	mov    %esp,%ebp
801010e1:	57                   	push   %edi
801010e2:	56                   	push   %esi
801010e3:	53                   	push   %ebx
801010e4:	83 ec 1c             	sub    $0x1c,%esp
801010e7:	89 c3                	mov    %eax,%ebx
801010e9:	89 d7                	mov    %edx,%edi
  if(bn < NDIRECT){
801010eb:	83 fa 0b             	cmp    $0xb,%edx
801010ee:	76 45                	jbe    80101135 <bmap+0x57>
  bn -= NDIRECT;
801010f0:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
801010f3:	83 fe 7f             	cmp    $0x7f,%esi
801010f6:	77 7f                	ja     80101177 <bmap+0x99>
    if((addr = ip->addrs[NDIRECT]) == 0)
801010f8:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801010fe:	85 c0                	test   %eax,%eax
80101100:	74 4a                	je     8010114c <bmap+0x6e>
    bp = bread(ip->dev, addr);
80101102:	83 ec 08             	sub    $0x8,%esp
80101105:	50                   	push   %eax
80101106:	ff 33                	pushl  (%ebx)
80101108:	e8 61 f0 ff ff       	call   8010016e <bread>
8010110d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010110f:	8d 44 b0 5c          	lea    0x5c(%eax,%esi,4),%eax
80101113:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101116:	8b 30                	mov    (%eax),%esi
80101118:	83 c4 10             	add    $0x10,%esp
8010111b:	85 f6                	test   %esi,%esi
8010111d:	74 3c                	je     8010115b <bmap+0x7d>
    brelse(bp);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	57                   	push   %edi
80101123:	e8 b7 f0 ff ff       	call   801001df <brelse>
    return addr;
80101128:	83 c4 10             	add    $0x10,%esp
}
8010112b:	89 f0                	mov    %esi,%eax
8010112d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101130:	5b                   	pop    %ebx
80101131:	5e                   	pop    %esi
80101132:	5f                   	pop    %edi
80101133:	5d                   	pop    %ebp
80101134:	c3                   	ret    
    if((addr = ip->addrs[bn]) == 0)
80101135:	8b 74 90 5c          	mov    0x5c(%eax,%edx,4),%esi
80101139:	85 f6                	test   %esi,%esi
8010113b:	75 ee                	jne    8010112b <bmap+0x4d>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010113d:	8b 00                	mov    (%eax),%eax
8010113f:	e8 a9 fe ff ff       	call   80100fed <balloc>
80101144:	89 c6                	mov    %eax,%esi
80101146:	89 44 bb 5c          	mov    %eax,0x5c(%ebx,%edi,4)
    return addr;
8010114a:	eb df                	jmp    8010112b <bmap+0x4d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
8010114c:	8b 03                	mov    (%ebx),%eax
8010114e:	e8 9a fe ff ff       	call   80100fed <balloc>
80101153:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101159:	eb a7                	jmp    80101102 <bmap+0x24>
      a[bn] = addr = balloc(ip->dev);
8010115b:	8b 03                	mov    (%ebx),%eax
8010115d:	e8 8b fe ff ff       	call   80100fed <balloc>
80101162:	89 c6                	mov    %eax,%esi
80101164:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101167:	89 30                	mov    %esi,(%eax)
      log_write(bp);
80101169:	83 ec 0c             	sub    $0xc,%esp
8010116c:	57                   	push   %edi
8010116d:	e8 92 17 00 00       	call   80102904 <log_write>
80101172:	83 c4 10             	add    $0x10,%esp
80101175:	eb a8                	jmp    8010111f <bmap+0x41>
  panic("bmap: out of range");
80101177:	83 ec 0c             	sub    $0xc,%esp
8010117a:	68 15 67 10 80       	push   $0x80106715
8010117f:	e8 d1 f1 ff ff       	call   80100355 <panic>

80101184 <iget>:
{
80101184:	55                   	push   %ebp
80101185:	89 e5                	mov    %esp,%ebp
80101187:	57                   	push   %edi
80101188:	56                   	push   %esi
80101189:	53                   	push   %ebx
8010118a:	83 ec 28             	sub    $0x28,%esp
8010118d:	89 c7                	mov    %eax,%edi
8010118f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101192:	68 e0 09 11 80       	push   $0x801109e0
80101197:	e8 b0 2a 00 00       	call   80103c4c <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010119c:	83 c4 10             	add    $0x10,%esp
  empty = 0;
8010119f:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011a4:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
801011a9:	eb 0a                	jmp    801011b5 <iget+0x31>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801011ab:	85 f6                	test   %esi,%esi
801011ad:	74 39                	je     801011e8 <iget+0x64>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011af:	81 c3 90 00 00 00    	add    $0x90,%ebx
801011b5:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801011bb:	73 33                	jae    801011f0 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801011bd:	8b 43 08             	mov    0x8(%ebx),%eax
801011c0:	85 c0                	test   %eax,%eax
801011c2:	7e e7                	jle    801011ab <iget+0x27>
801011c4:	39 3b                	cmp    %edi,(%ebx)
801011c6:	75 e3                	jne    801011ab <iget+0x27>
801011c8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801011cb:	39 4b 04             	cmp    %ecx,0x4(%ebx)
801011ce:	75 db                	jne    801011ab <iget+0x27>
      ip->ref++;
801011d0:	40                   	inc    %eax
801011d1:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801011d4:	83 ec 0c             	sub    $0xc,%esp
801011d7:	68 e0 09 11 80       	push   $0x801109e0
801011dc:	e8 d4 2a 00 00       	call   80103cb5 <release>
      return ip;
801011e1:	83 c4 10             	add    $0x10,%esp
801011e4:	89 de                	mov    %ebx,%esi
801011e6:	eb 32                	jmp    8010121a <iget+0x96>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801011e8:	85 c0                	test   %eax,%eax
801011ea:	75 c3                	jne    801011af <iget+0x2b>
      empty = ip;
801011ec:	89 de                	mov    %ebx,%esi
801011ee:	eb bf                	jmp    801011af <iget+0x2b>
  if(empty == 0)
801011f0:	85 f6                	test   %esi,%esi
801011f2:	74 30                	je     80101224 <iget+0xa0>
  ip->dev = dev;
801011f4:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801011f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011f9:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
801011fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101203:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010120a:	83 ec 0c             	sub    $0xc,%esp
8010120d:	68 e0 09 11 80       	push   $0x801109e0
80101212:	e8 9e 2a 00 00       	call   80103cb5 <release>
  return ip;
80101217:	83 c4 10             	add    $0x10,%esp
}
8010121a:	89 f0                	mov    %esi,%eax
8010121c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010121f:	5b                   	pop    %ebx
80101220:	5e                   	pop    %esi
80101221:	5f                   	pop    %edi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("iget: no inodes");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 28 67 10 80       	push   $0x80106728
8010122c:	e8 24 f1 ff ff       	call   80100355 <panic>

80101231 <readsb>:
{
80101231:	f3 0f 1e fb          	endbr32 
80101235:	55                   	push   %ebp
80101236:	89 e5                	mov    %esp,%ebp
80101238:	53                   	push   %ebx
80101239:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
8010123c:	6a 01                	push   $0x1
8010123e:	ff 75 08             	pushl  0x8(%ebp)
80101241:	e8 28 ef ff ff       	call   8010016e <bread>
80101246:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101248:	8d 40 5c             	lea    0x5c(%eax),%eax
8010124b:	83 c4 0c             	add    $0xc,%esp
8010124e:	6a 1c                	push   $0x1c
80101250:	50                   	push   %eax
80101251:	ff 75 0c             	pushl  0xc(%ebp)
80101254:	e8 25 2b 00 00       	call   80103d7e <memmove>
  brelse(bp);
80101259:	89 1c 24             	mov    %ebx,(%esp)
8010125c:	e8 7e ef ff ff       	call   801001df <brelse>
}
80101261:	83 c4 10             	add    $0x10,%esp
80101264:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101267:	c9                   	leave  
80101268:	c3                   	ret    

80101269 <bfree>:
{
80101269:	55                   	push   %ebp
8010126a:	89 e5                	mov    %esp,%ebp
8010126c:	57                   	push   %edi
8010126d:	56                   	push   %esi
8010126e:	53                   	push   %ebx
8010126f:	83 ec 14             	sub    $0x14,%esp
80101272:	89 c3                	mov    %eax,%ebx
80101274:	89 d6                	mov    %edx,%esi
  readsb(dev, &sb);
80101276:	68 c0 09 11 80       	push   $0x801109c0
8010127b:	50                   	push   %eax
8010127c:	e8 b0 ff ff ff       	call   80101231 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101281:	89 f0                	mov    %esi,%eax
80101283:	c1 e8 0c             	shr    $0xc,%eax
80101286:	83 c4 08             	add    $0x8,%esp
80101289:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010128f:	50                   	push   %eax
80101290:	53                   	push   %ebx
80101291:	e8 d8 ee ff ff       	call   8010016e <bread>
80101296:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
80101298:	89 f7                	mov    %esi,%edi
8010129a:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
  m = 1 << (bi % 8);
801012a0:	89 f1                	mov    %esi,%ecx
801012a2:	83 e1 07             	and    $0x7,%ecx
801012a5:	b8 01 00 00 00       	mov    $0x1,%eax
801012aa:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801012ac:	83 c4 10             	add    $0x10,%esp
801012af:	c1 ff 03             	sar    $0x3,%edi
801012b2:	8a 54 3b 5c          	mov    0x5c(%ebx,%edi,1),%dl
801012b6:	0f b6 ca             	movzbl %dl,%ecx
801012b9:	85 c1                	test   %eax,%ecx
801012bb:	74 24                	je     801012e1 <bfree+0x78>
  bp->data[bi/8] &= ~m;
801012bd:	f7 d0                	not    %eax
801012bf:	21 d0                	and    %edx,%eax
801012c1:	88 44 3b 5c          	mov    %al,0x5c(%ebx,%edi,1)
  log_write(bp);
801012c5:	83 ec 0c             	sub    $0xc,%esp
801012c8:	53                   	push   %ebx
801012c9:	e8 36 16 00 00       	call   80102904 <log_write>
  brelse(bp);
801012ce:	89 1c 24             	mov    %ebx,(%esp)
801012d1:	e8 09 ef ff ff       	call   801001df <brelse>
}
801012d6:	83 c4 10             	add    $0x10,%esp
801012d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012dc:	5b                   	pop    %ebx
801012dd:	5e                   	pop    %esi
801012de:	5f                   	pop    %edi
801012df:	5d                   	pop    %ebp
801012e0:	c3                   	ret    
    panic("freeing free block");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 38 67 10 80       	push   $0x80106738
801012e9:	e8 67 f0 ff ff       	call   80100355 <panic>

801012ee <iinit>:
{
801012ee:	f3 0f 1e fb          	endbr32 
801012f2:	55                   	push   %ebp
801012f3:	89 e5                	mov    %esp,%ebp
801012f5:	53                   	push   %ebx
801012f6:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801012f9:	68 4b 67 10 80       	push   $0x8010674b
801012fe:	68 e0 09 11 80       	push   $0x801109e0
80101303:	e8 f9 27 00 00       	call   80103b01 <initlock>
  for(i = 0; i < NINODE; i++) {
80101308:	83 c4 10             	add    $0x10,%esp
8010130b:	bb 00 00 00 00       	mov    $0x0,%ebx
80101310:	83 fb 31             	cmp    $0x31,%ebx
80101313:	7f 21                	jg     80101336 <iinit+0x48>
    initsleeplock(&icache.inode[i].lock, "inode");
80101315:	83 ec 08             	sub    $0x8,%esp
80101318:	68 52 67 10 80       	push   $0x80106752
8010131d:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
80101320:	89 d0                	mov    %edx,%eax
80101322:	c1 e0 04             	shl    $0x4,%eax
80101325:	05 20 0a 11 80       	add    $0x80110a20,%eax
8010132a:	50                   	push   %eax
8010132b:	e8 b6 26 00 00       	call   801039e6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101330:	43                   	inc    %ebx
80101331:	83 c4 10             	add    $0x10,%esp
80101334:	eb da                	jmp    80101310 <iinit+0x22>
  readsb(dev, &sb);
80101336:	83 ec 08             	sub    $0x8,%esp
80101339:	68 c0 09 11 80       	push   $0x801109c0
8010133e:	ff 75 08             	pushl  0x8(%ebp)
80101341:	e8 eb fe ff ff       	call   80101231 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101346:	ff 35 d8 09 11 80    	pushl  0x801109d8
8010134c:	ff 35 d4 09 11 80    	pushl  0x801109d4
80101352:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101358:	ff 35 cc 09 11 80    	pushl  0x801109cc
8010135e:	ff 35 c8 09 11 80    	pushl  0x801109c8
80101364:	ff 35 c4 09 11 80    	pushl  0x801109c4
8010136a:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101370:	68 b8 67 10 80       	push   $0x801067b8
80101375:	e8 83 f2 ff ff       	call   801005fd <cprintf>
}
8010137a:	83 c4 30             	add    $0x30,%esp
8010137d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101380:	c9                   	leave  
80101381:	c3                   	ret    

80101382 <ialloc>:
{
80101382:	f3 0f 1e fb          	endbr32 
80101386:	55                   	push   %ebp
80101387:	89 e5                	mov    %esp,%ebp
80101389:	57                   	push   %edi
8010138a:	56                   	push   %esi
8010138b:	53                   	push   %ebx
8010138c:	83 ec 1c             	sub    $0x1c,%esp
8010138f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101392:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101395:	bb 01 00 00 00       	mov    $0x1,%ebx
8010139a:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010139d:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
801013a3:	76 73                	jbe    80101418 <ialloc+0x96>
    bp = bread(dev, IBLOCK(inum, sb));
801013a5:	89 d8                	mov    %ebx,%eax
801013a7:	c1 e8 03             	shr    $0x3,%eax
801013aa:	83 ec 08             	sub    $0x8,%esp
801013ad:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801013b3:	50                   	push   %eax
801013b4:	ff 75 08             	pushl  0x8(%ebp)
801013b7:	e8 b2 ed ff ff       	call   8010016e <bread>
801013bc:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
801013be:	89 d8                	mov    %ebx,%eax
801013c0:	83 e0 07             	and    $0x7,%eax
801013c3:	c1 e0 06             	shl    $0x6,%eax
801013c6:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
801013ca:	83 c4 10             	add    $0x10,%esp
801013cd:	66 83 3f 00          	cmpw   $0x0,(%edi)
801013d1:	74 0f                	je     801013e2 <ialloc+0x60>
    brelse(bp);
801013d3:	83 ec 0c             	sub    $0xc,%esp
801013d6:	56                   	push   %esi
801013d7:	e8 03 ee ff ff       	call   801001df <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801013dc:	43                   	inc    %ebx
801013dd:	83 c4 10             	add    $0x10,%esp
801013e0:	eb b8                	jmp    8010139a <ialloc+0x18>
      memset(dip, 0, sizeof(*dip));
801013e2:	83 ec 04             	sub    $0x4,%esp
801013e5:	6a 40                	push   $0x40
801013e7:	6a 00                	push   $0x0
801013e9:	57                   	push   %edi
801013ea:	e8 11 29 00 00       	call   80103d00 <memset>
      dip->type = type;
801013ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
801013f2:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
801013f5:	89 34 24             	mov    %esi,(%esp)
801013f8:	e8 07 15 00 00       	call   80102904 <log_write>
      brelse(bp);
801013fd:	89 34 24             	mov    %esi,(%esp)
80101400:	e8 da ed ff ff       	call   801001df <brelse>
      return iget(dev, inum);
80101405:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101408:	8b 45 08             	mov    0x8(%ebp),%eax
8010140b:	e8 74 fd ff ff       	call   80101184 <iget>
}
80101410:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101413:	5b                   	pop    %ebx
80101414:	5e                   	pop    %esi
80101415:	5f                   	pop    %edi
80101416:	5d                   	pop    %ebp
80101417:	c3                   	ret    
  panic("ialloc: no inodes");
80101418:	83 ec 0c             	sub    $0xc,%esp
8010141b:	68 58 67 10 80       	push   $0x80106758
80101420:	e8 30 ef ff ff       	call   80100355 <panic>

80101425 <iupdate>:
{
80101425:	f3 0f 1e fb          	endbr32 
80101429:	55                   	push   %ebp
8010142a:	89 e5                	mov    %esp,%ebp
8010142c:	56                   	push   %esi
8010142d:	53                   	push   %ebx
8010142e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101431:	8b 43 04             	mov    0x4(%ebx),%eax
80101434:	c1 e8 03             	shr    $0x3,%eax
80101437:	83 ec 08             	sub    $0x8,%esp
8010143a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101440:	50                   	push   %eax
80101441:	ff 33                	pushl  (%ebx)
80101443:	e8 26 ed ff ff       	call   8010016e <bread>
80101448:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010144a:	8b 43 04             	mov    0x4(%ebx),%eax
8010144d:	83 e0 07             	and    $0x7,%eax
80101450:	c1 e0 06             	shl    $0x6,%eax
80101453:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101457:	8b 53 50             	mov    0x50(%ebx),%edx
8010145a:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010145d:	66 8b 53 52          	mov    0x52(%ebx),%dx
80101461:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101465:	8b 53 54             	mov    0x54(%ebx),%edx
80101468:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010146c:	66 8b 53 56          	mov    0x56(%ebx),%dx
80101470:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101474:	8b 53 58             	mov    0x58(%ebx),%edx
80101477:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010147a:	83 c3 5c             	add    $0x5c,%ebx
8010147d:	83 c0 0c             	add    $0xc,%eax
80101480:	83 c4 0c             	add    $0xc,%esp
80101483:	6a 34                	push   $0x34
80101485:	53                   	push   %ebx
80101486:	50                   	push   %eax
80101487:	e8 f2 28 00 00       	call   80103d7e <memmove>
  log_write(bp);
8010148c:	89 34 24             	mov    %esi,(%esp)
8010148f:	e8 70 14 00 00       	call   80102904 <log_write>
  brelse(bp);
80101494:	89 34 24             	mov    %esi,(%esp)
80101497:	e8 43 ed ff ff       	call   801001df <brelse>
}
8010149c:	83 c4 10             	add    $0x10,%esp
8010149f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014a2:	5b                   	pop    %ebx
801014a3:	5e                   	pop    %esi
801014a4:	5d                   	pop    %ebp
801014a5:	c3                   	ret    

801014a6 <itrunc>:
{
801014a6:	55                   	push   %ebp
801014a7:	89 e5                	mov    %esp,%ebp
801014a9:	57                   	push   %edi
801014aa:	56                   	push   %esi
801014ab:	53                   	push   %ebx
801014ac:	83 ec 1c             	sub    $0x1c,%esp
801014af:	89 c6                	mov    %eax,%esi
  for(i = 0; i < NDIRECT; i++){
801014b1:	bb 00 00 00 00       	mov    $0x0,%ebx
801014b6:	eb 01                	jmp    801014b9 <itrunc+0x13>
801014b8:	43                   	inc    %ebx
801014b9:	83 fb 0b             	cmp    $0xb,%ebx
801014bc:	7f 19                	jg     801014d7 <itrunc+0x31>
    if(ip->addrs[i]){
801014be:	8b 54 9e 5c          	mov    0x5c(%esi,%ebx,4),%edx
801014c2:	85 d2                	test   %edx,%edx
801014c4:	74 f2                	je     801014b8 <itrunc+0x12>
      bfree(ip->dev, ip->addrs[i]);
801014c6:	8b 06                	mov    (%esi),%eax
801014c8:	e8 9c fd ff ff       	call   80101269 <bfree>
      ip->addrs[i] = 0;
801014cd:	c7 44 9e 5c 00 00 00 	movl   $0x0,0x5c(%esi,%ebx,4)
801014d4:	00 
801014d5:	eb e1                	jmp    801014b8 <itrunc+0x12>
  if(ip->addrs[NDIRECT]){
801014d7:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801014dd:	85 c0                	test   %eax,%eax
801014df:	75 1b                	jne    801014fc <itrunc+0x56>
  ip->size = 0;
801014e1:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801014e8:	83 ec 0c             	sub    $0xc,%esp
801014eb:	56                   	push   %esi
801014ec:	e8 34 ff ff ff       	call   80101425 <iupdate>
}
801014f1:	83 c4 10             	add    $0x10,%esp
801014f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f7:	5b                   	pop    %ebx
801014f8:	5e                   	pop    %esi
801014f9:	5f                   	pop    %edi
801014fa:	5d                   	pop    %ebp
801014fb:	c3                   	ret    
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801014fc:	83 ec 08             	sub    $0x8,%esp
801014ff:	50                   	push   %eax
80101500:	ff 36                	pushl  (%esi)
80101502:	e8 67 ec ff ff       	call   8010016e <bread>
80101507:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
8010150a:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
8010150d:	83 c4 10             	add    $0x10,%esp
80101510:	bb 00 00 00 00       	mov    $0x0,%ebx
80101515:	eb 08                	jmp    8010151f <itrunc+0x79>
        bfree(ip->dev, a[j]);
80101517:	8b 06                	mov    (%esi),%eax
80101519:	e8 4b fd ff ff       	call   80101269 <bfree>
    for(j = 0; j < NINDIRECT; j++){
8010151e:	43                   	inc    %ebx
8010151f:	83 fb 7f             	cmp    $0x7f,%ebx
80101522:	77 09                	ja     8010152d <itrunc+0x87>
      if(a[j])
80101524:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
80101527:	85 d2                	test   %edx,%edx
80101529:	74 f3                	je     8010151e <itrunc+0x78>
8010152b:	eb ea                	jmp    80101517 <itrunc+0x71>
    brelse(bp);
8010152d:	83 ec 0c             	sub    $0xc,%esp
80101530:	ff 75 e4             	pushl  -0x1c(%ebp)
80101533:	e8 a7 ec ff ff       	call   801001df <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101538:	8b 06                	mov    (%esi),%eax
8010153a:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101540:	e8 24 fd ff ff       	call   80101269 <bfree>
    ip->addrs[NDIRECT] = 0;
80101545:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
8010154c:	00 00 00 
8010154f:	83 c4 10             	add    $0x10,%esp
80101552:	eb 8d                	jmp    801014e1 <itrunc+0x3b>

80101554 <idup>:
{
80101554:	f3 0f 1e fb          	endbr32 
80101558:	55                   	push   %ebp
80101559:	89 e5                	mov    %esp,%ebp
8010155b:	53                   	push   %ebx
8010155c:	83 ec 10             	sub    $0x10,%esp
8010155f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101562:	68 e0 09 11 80       	push   $0x801109e0
80101567:	e8 e0 26 00 00       	call   80103c4c <acquire>
  ip->ref++;
8010156c:	8b 43 08             	mov    0x8(%ebx),%eax
8010156f:	40                   	inc    %eax
80101570:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
80101573:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010157a:	e8 36 27 00 00       	call   80103cb5 <release>
}
8010157f:	89 d8                	mov    %ebx,%eax
80101581:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101584:	c9                   	leave  
80101585:	c3                   	ret    

80101586 <ilock>:
{
80101586:	f3 0f 1e fb          	endbr32 
8010158a:	55                   	push   %ebp
8010158b:	89 e5                	mov    %esp,%ebp
8010158d:	56                   	push   %esi
8010158e:	53                   	push   %ebx
8010158f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101592:	85 db                	test   %ebx,%ebx
80101594:	74 22                	je     801015b8 <ilock+0x32>
80101596:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
8010159a:	7e 1c                	jle    801015b8 <ilock+0x32>
  acquiresleep(&ip->lock);
8010159c:	83 ec 0c             	sub    $0xc,%esp
8010159f:	8d 43 0c             	lea    0xc(%ebx),%eax
801015a2:	50                   	push   %eax
801015a3:	e8 75 24 00 00       	call   80103a1d <acquiresleep>
  if(ip->valid == 0){
801015a8:	83 c4 10             	add    $0x10,%esp
801015ab:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801015af:	74 14                	je     801015c5 <ilock+0x3f>
}
801015b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015b4:	5b                   	pop    %ebx
801015b5:	5e                   	pop    %esi
801015b6:	5d                   	pop    %ebp
801015b7:	c3                   	ret    
    panic("ilock");
801015b8:	83 ec 0c             	sub    $0xc,%esp
801015bb:	68 6a 67 10 80       	push   $0x8010676a
801015c0:	e8 90 ed ff ff       	call   80100355 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015c5:	8b 43 04             	mov    0x4(%ebx),%eax
801015c8:	c1 e8 03             	shr    $0x3,%eax
801015cb:	83 ec 08             	sub    $0x8,%esp
801015ce:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015d4:	50                   	push   %eax
801015d5:	ff 33                	pushl  (%ebx)
801015d7:	e8 92 eb ff ff       	call   8010016e <bread>
801015dc:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801015de:	8b 43 04             	mov    0x4(%ebx),%eax
801015e1:	83 e0 07             	and    $0x7,%eax
801015e4:	c1 e0 06             	shl    $0x6,%eax
801015e7:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801015eb:	8b 10                	mov    (%eax),%edx
801015ed:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801015f1:	66 8b 50 02          	mov    0x2(%eax),%dx
801015f5:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801015f9:	8b 50 04             	mov    0x4(%eax),%edx
801015fc:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101600:	66 8b 50 06          	mov    0x6(%eax),%dx
80101604:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101608:	8b 50 08             	mov    0x8(%eax),%edx
8010160b:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010160e:	83 c0 0c             	add    $0xc,%eax
80101611:	8d 53 5c             	lea    0x5c(%ebx),%edx
80101614:	83 c4 0c             	add    $0xc,%esp
80101617:	6a 34                	push   $0x34
80101619:	50                   	push   %eax
8010161a:	52                   	push   %edx
8010161b:	e8 5e 27 00 00       	call   80103d7e <memmove>
    brelse(bp);
80101620:	89 34 24             	mov    %esi,(%esp)
80101623:	e8 b7 eb ff ff       	call   801001df <brelse>
    ip->valid = 1;
80101628:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
8010162f:	83 c4 10             	add    $0x10,%esp
80101632:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101637:	0f 85 74 ff ff ff    	jne    801015b1 <ilock+0x2b>
      panic("ilock: no type");
8010163d:	83 ec 0c             	sub    $0xc,%esp
80101640:	68 70 67 10 80       	push   $0x80106770
80101645:	e8 0b ed ff ff       	call   80100355 <panic>

8010164a <iunlock>:
{
8010164a:	f3 0f 1e fb          	endbr32 
8010164e:	55                   	push   %ebp
8010164f:	89 e5                	mov    %esp,%ebp
80101651:	56                   	push   %esi
80101652:	53                   	push   %ebx
80101653:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101656:	85 db                	test   %ebx,%ebx
80101658:	74 2c                	je     80101686 <iunlock+0x3c>
8010165a:	8d 73 0c             	lea    0xc(%ebx),%esi
8010165d:	83 ec 0c             	sub    $0xc,%esp
80101660:	56                   	push   %esi
80101661:	e8 49 24 00 00       	call   80103aaf <holdingsleep>
80101666:	83 c4 10             	add    $0x10,%esp
80101669:	85 c0                	test   %eax,%eax
8010166b:	74 19                	je     80101686 <iunlock+0x3c>
8010166d:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101671:	7e 13                	jle    80101686 <iunlock+0x3c>
  releasesleep(&ip->lock);
80101673:	83 ec 0c             	sub    $0xc,%esp
80101676:	56                   	push   %esi
80101677:	e8 f4 23 00 00       	call   80103a70 <releasesleep>
}
8010167c:	83 c4 10             	add    $0x10,%esp
8010167f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101682:	5b                   	pop    %ebx
80101683:	5e                   	pop    %esi
80101684:	5d                   	pop    %ebp
80101685:	c3                   	ret    
    panic("iunlock");
80101686:	83 ec 0c             	sub    $0xc,%esp
80101689:	68 7f 67 10 80       	push   $0x8010677f
8010168e:	e8 c2 ec ff ff       	call   80100355 <panic>

80101693 <iput>:
{
80101693:	f3 0f 1e fb          	endbr32 
80101697:	55                   	push   %ebp
80101698:	89 e5                	mov    %esp,%ebp
8010169a:	57                   	push   %edi
8010169b:	56                   	push   %esi
8010169c:	53                   	push   %ebx
8010169d:	83 ec 18             	sub    $0x18,%esp
801016a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801016a3:	8d 73 0c             	lea    0xc(%ebx),%esi
801016a6:	56                   	push   %esi
801016a7:	e8 71 23 00 00       	call   80103a1d <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801016ac:	83 c4 10             	add    $0x10,%esp
801016af:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801016b3:	74 07                	je     801016bc <iput+0x29>
801016b5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801016ba:	74 33                	je     801016ef <iput+0x5c>
  releasesleep(&ip->lock);
801016bc:	83 ec 0c             	sub    $0xc,%esp
801016bf:	56                   	push   %esi
801016c0:	e8 ab 23 00 00       	call   80103a70 <releasesleep>
  acquire(&icache.lock);
801016c5:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016cc:	e8 7b 25 00 00       	call   80103c4c <acquire>
  ip->ref--;
801016d1:	8b 43 08             	mov    0x8(%ebx),%eax
801016d4:	48                   	dec    %eax
801016d5:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801016d8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016df:	e8 d1 25 00 00       	call   80103cb5 <release>
}
801016e4:	83 c4 10             	add    $0x10,%esp
801016e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016ea:	5b                   	pop    %ebx
801016eb:	5e                   	pop    %esi
801016ec:	5f                   	pop    %edi
801016ed:	5d                   	pop    %ebp
801016ee:	c3                   	ret    
    acquire(&icache.lock);
801016ef:	83 ec 0c             	sub    $0xc,%esp
801016f2:	68 e0 09 11 80       	push   $0x801109e0
801016f7:	e8 50 25 00 00       	call   80103c4c <acquire>
    int r = ip->ref;
801016fc:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
801016ff:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101706:	e8 aa 25 00 00       	call   80103cb5 <release>
    if(r == 1){
8010170b:	83 c4 10             	add    $0x10,%esp
8010170e:	83 ff 01             	cmp    $0x1,%edi
80101711:	75 a9                	jne    801016bc <iput+0x29>
      itrunc(ip);
80101713:	89 d8                	mov    %ebx,%eax
80101715:	e8 8c fd ff ff       	call   801014a6 <itrunc>
      ip->type = 0;
8010171a:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101720:	83 ec 0c             	sub    $0xc,%esp
80101723:	53                   	push   %ebx
80101724:	e8 fc fc ff ff       	call   80101425 <iupdate>
      ip->valid = 0;
80101729:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101730:	83 c4 10             	add    $0x10,%esp
80101733:	eb 87                	jmp    801016bc <iput+0x29>

80101735 <iunlockput>:
{
80101735:	f3 0f 1e fb          	endbr32 
80101739:	55                   	push   %ebp
8010173a:	89 e5                	mov    %esp,%ebp
8010173c:	53                   	push   %ebx
8010173d:	83 ec 10             	sub    $0x10,%esp
80101740:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101743:	53                   	push   %ebx
80101744:	e8 01 ff ff ff       	call   8010164a <iunlock>
  iput(ip);
80101749:	89 1c 24             	mov    %ebx,(%esp)
8010174c:	e8 42 ff ff ff       	call   80101693 <iput>
}
80101751:	83 c4 10             	add    $0x10,%esp
80101754:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101757:	c9                   	leave  
80101758:	c3                   	ret    

80101759 <stati>:
{
80101759:	f3 0f 1e fb          	endbr32 
8010175d:	55                   	push   %ebp
8010175e:	89 e5                	mov    %esp,%ebp
80101760:	8b 55 08             	mov    0x8(%ebp),%edx
80101763:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101766:	8b 0a                	mov    (%edx),%ecx
80101768:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010176b:	8b 4a 04             	mov    0x4(%edx),%ecx
8010176e:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101771:	8b 4a 50             	mov    0x50(%edx),%ecx
80101774:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101777:	66 8b 4a 56          	mov    0x56(%edx),%cx
8010177b:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
8010177f:	8b 52 58             	mov    0x58(%edx),%edx
80101782:	89 50 10             	mov    %edx,0x10(%eax)
}
80101785:	5d                   	pop    %ebp
80101786:	c3                   	ret    

80101787 <readi>:
{
80101787:	f3 0f 1e fb          	endbr32 
8010178b:	55                   	push   %ebp
8010178c:	89 e5                	mov    %esp,%ebp
8010178e:	57                   	push   %edi
8010178f:	56                   	push   %esi
80101790:	53                   	push   %ebx
80101791:	83 ec 0c             	sub    $0xc,%esp
  if(ip->type == T_DEV){
80101794:	8b 45 08             	mov    0x8(%ebp),%eax
80101797:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
8010179c:	74 2c                	je     801017ca <readi+0x43>
  if(off > ip->size || off + n < off)
8010179e:	8b 45 08             	mov    0x8(%ebp),%eax
801017a1:	8b 40 58             	mov    0x58(%eax),%eax
801017a4:	3b 45 10             	cmp    0x10(%ebp),%eax
801017a7:	0f 82 d0 00 00 00    	jb     8010187d <readi+0xf6>
801017ad:	8b 55 10             	mov    0x10(%ebp),%edx
801017b0:	03 55 14             	add    0x14(%ebp),%edx
801017b3:	0f 82 cb 00 00 00    	jb     80101884 <readi+0xfd>
  if(off + n > ip->size)
801017b9:	39 d0                	cmp    %edx,%eax
801017bb:	73 06                	jae    801017c3 <readi+0x3c>
    n = ip->size - off;
801017bd:	2b 45 10             	sub    0x10(%ebp),%eax
801017c0:	89 45 14             	mov    %eax,0x14(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801017c3:	bf 00 00 00 00       	mov    $0x0,%edi
801017c8:	eb 55                	jmp    8010181f <readi+0x98>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801017ca:	66 8b 40 52          	mov    0x52(%eax),%ax
801017ce:	66 83 f8 09          	cmp    $0x9,%ax
801017d2:	0f 87 97 00 00 00    	ja     8010186f <readi+0xe8>
801017d8:	98                   	cwtl   
801017d9:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
801017e0:	85 c0                	test   %eax,%eax
801017e2:	0f 84 8e 00 00 00    	je     80101876 <readi+0xef>
    return devsw[ip->major].read(ip, dst, n);
801017e8:	83 ec 04             	sub    $0x4,%esp
801017eb:	ff 75 14             	pushl  0x14(%ebp)
801017ee:	ff 75 0c             	pushl  0xc(%ebp)
801017f1:	ff 75 08             	pushl  0x8(%ebp)
801017f4:	ff d0                	call   *%eax
801017f6:	83 c4 10             	add    $0x10,%esp
801017f9:	eb 6c                	jmp    80101867 <readi+0xe0>
    memmove(dst, bp->data + off%BSIZE, m);
801017fb:	83 ec 04             	sub    $0x4,%esp
801017fe:	53                   	push   %ebx
801017ff:	8d 44 16 5c          	lea    0x5c(%esi,%edx,1),%eax
80101803:	50                   	push   %eax
80101804:	ff 75 0c             	pushl  0xc(%ebp)
80101807:	e8 72 25 00 00       	call   80103d7e <memmove>
    brelse(bp);
8010180c:	89 34 24             	mov    %esi,(%esp)
8010180f:	e8 cb e9 ff ff       	call   801001df <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101814:	01 df                	add    %ebx,%edi
80101816:	01 5d 10             	add    %ebx,0x10(%ebp)
80101819:	01 5d 0c             	add    %ebx,0xc(%ebp)
8010181c:	83 c4 10             	add    $0x10,%esp
8010181f:	39 7d 14             	cmp    %edi,0x14(%ebp)
80101822:	76 40                	jbe    80101864 <readi+0xdd>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101824:	8b 55 10             	mov    0x10(%ebp),%edx
80101827:	c1 ea 09             	shr    $0x9,%edx
8010182a:	8b 45 08             	mov    0x8(%ebp),%eax
8010182d:	e8 ac f8 ff ff       	call   801010de <bmap>
80101832:	83 ec 08             	sub    $0x8,%esp
80101835:	50                   	push   %eax
80101836:	8b 45 08             	mov    0x8(%ebp),%eax
80101839:	ff 30                	pushl  (%eax)
8010183b:	e8 2e e9 ff ff       	call   8010016e <bread>
80101840:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101842:	8b 55 10             	mov    0x10(%ebp),%edx
80101845:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010184b:	b8 00 02 00 00       	mov    $0x200,%eax
80101850:	29 d0                	sub    %edx,%eax
80101852:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101855:	29 f9                	sub    %edi,%ecx
80101857:	89 c3                	mov    %eax,%ebx
80101859:	83 c4 10             	add    $0x10,%esp
8010185c:	39 c8                	cmp    %ecx,%eax
8010185e:	76 9b                	jbe    801017fb <readi+0x74>
80101860:	89 cb                	mov    %ecx,%ebx
80101862:	eb 97                	jmp    801017fb <readi+0x74>
  return n;
80101864:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101867:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010186a:	5b                   	pop    %ebx
8010186b:	5e                   	pop    %esi
8010186c:	5f                   	pop    %edi
8010186d:	5d                   	pop    %ebp
8010186e:	c3                   	ret    
      return -1;
8010186f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101874:	eb f1                	jmp    80101867 <readi+0xe0>
80101876:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010187b:	eb ea                	jmp    80101867 <readi+0xe0>
    return -1;
8010187d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101882:	eb e3                	jmp    80101867 <readi+0xe0>
80101884:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101889:	eb dc                	jmp    80101867 <readi+0xe0>

8010188b <writei>:
{
8010188b:	f3 0f 1e fb          	endbr32 
8010188f:	55                   	push   %ebp
80101890:	89 e5                	mov    %esp,%ebp
80101892:	57                   	push   %edi
80101893:	56                   	push   %esi
80101894:	53                   	push   %ebx
80101895:	83 ec 0c             	sub    $0xc,%esp
  if(ip->type == T_DEV){
80101898:	8b 45 08             	mov    0x8(%ebp),%eax
8010189b:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801018a0:	74 2c                	je     801018ce <writei+0x43>
  if(off > ip->size || off + n < off)
801018a2:	8b 45 08             	mov    0x8(%ebp),%eax
801018a5:	8b 7d 10             	mov    0x10(%ebp),%edi
801018a8:	39 78 58             	cmp    %edi,0x58(%eax)
801018ab:	0f 82 fd 00 00 00    	jb     801019ae <writei+0x123>
801018b1:	89 f8                	mov    %edi,%eax
801018b3:	03 45 14             	add    0x14(%ebp),%eax
801018b6:	0f 82 f9 00 00 00    	jb     801019b5 <writei+0x12a>
  if(off + n > MAXFILE*BSIZE)
801018bc:	3d 00 18 01 00       	cmp    $0x11800,%eax
801018c1:	0f 87 f5 00 00 00    	ja     801019bc <writei+0x131>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801018c7:	bf 00 00 00 00       	mov    $0x0,%edi
801018cc:	eb 60                	jmp    8010192e <writei+0xa3>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801018ce:	66 8b 40 52          	mov    0x52(%eax),%ax
801018d2:	66 83 f8 09          	cmp    $0x9,%ax
801018d6:	0f 87 c4 00 00 00    	ja     801019a0 <writei+0x115>
801018dc:	98                   	cwtl   
801018dd:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
801018e4:	85 c0                	test   %eax,%eax
801018e6:	0f 84 bb 00 00 00    	je     801019a7 <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
801018ec:	83 ec 04             	sub    $0x4,%esp
801018ef:	ff 75 14             	pushl  0x14(%ebp)
801018f2:	ff 75 0c             	pushl  0xc(%ebp)
801018f5:	ff 75 08             	pushl  0x8(%ebp)
801018f8:	ff d0                	call   *%eax
801018fa:	83 c4 10             	add    $0x10,%esp
801018fd:	e9 85 00 00 00       	jmp    80101987 <writei+0xfc>
    memmove(bp->data + off%BSIZE, src, m);
80101902:	83 ec 04             	sub    $0x4,%esp
80101905:	56                   	push   %esi
80101906:	ff 75 0c             	pushl  0xc(%ebp)
80101909:	8d 44 13 5c          	lea    0x5c(%ebx,%edx,1),%eax
8010190d:	50                   	push   %eax
8010190e:	e8 6b 24 00 00       	call   80103d7e <memmove>
    log_write(bp);
80101913:	89 1c 24             	mov    %ebx,(%esp)
80101916:	e8 e9 0f 00 00       	call   80102904 <log_write>
    brelse(bp);
8010191b:	89 1c 24             	mov    %ebx,(%esp)
8010191e:	e8 bc e8 ff ff       	call   801001df <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101923:	01 f7                	add    %esi,%edi
80101925:	01 75 10             	add    %esi,0x10(%ebp)
80101928:	01 75 0c             	add    %esi,0xc(%ebp)
8010192b:	83 c4 10             	add    $0x10,%esp
8010192e:	3b 7d 14             	cmp    0x14(%ebp),%edi
80101931:	73 40                	jae    80101973 <writei+0xe8>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101933:	8b 55 10             	mov    0x10(%ebp),%edx
80101936:	c1 ea 09             	shr    $0x9,%edx
80101939:	8b 45 08             	mov    0x8(%ebp),%eax
8010193c:	e8 9d f7 ff ff       	call   801010de <bmap>
80101941:	83 ec 08             	sub    $0x8,%esp
80101944:	50                   	push   %eax
80101945:	8b 45 08             	mov    0x8(%ebp),%eax
80101948:	ff 30                	pushl  (%eax)
8010194a:	e8 1f e8 ff ff       	call   8010016e <bread>
8010194f:	89 c3                	mov    %eax,%ebx
    m = min(n - tot, BSIZE - off%BSIZE);
80101951:	8b 55 10             	mov    0x10(%ebp),%edx
80101954:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010195a:	b8 00 02 00 00       	mov    $0x200,%eax
8010195f:	29 d0                	sub    %edx,%eax
80101961:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101964:	29 f9                	sub    %edi,%ecx
80101966:	89 c6                	mov    %eax,%esi
80101968:	83 c4 10             	add    $0x10,%esp
8010196b:	39 c8                	cmp    %ecx,%eax
8010196d:	76 93                	jbe    80101902 <writei+0x77>
8010196f:	89 ce                	mov    %ecx,%esi
80101971:	eb 8f                	jmp    80101902 <writei+0x77>
  if(n > 0 && off > ip->size){
80101973:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80101977:	74 0b                	je     80101984 <writei+0xf9>
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	8b 7d 10             	mov    0x10(%ebp),%edi
8010197f:	39 78 58             	cmp    %edi,0x58(%eax)
80101982:	72 0b                	jb     8010198f <writei+0x104>
  return n;
80101984:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101987:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010198a:	5b                   	pop    %ebx
8010198b:	5e                   	pop    %esi
8010198c:	5f                   	pop    %edi
8010198d:	5d                   	pop    %ebp
8010198e:	c3                   	ret    
    ip->size = off;
8010198f:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101992:	83 ec 0c             	sub    $0xc,%esp
80101995:	50                   	push   %eax
80101996:	e8 8a fa ff ff       	call   80101425 <iupdate>
8010199b:	83 c4 10             	add    $0x10,%esp
8010199e:	eb e4                	jmp    80101984 <writei+0xf9>
      return -1;
801019a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019a5:	eb e0                	jmp    80101987 <writei+0xfc>
801019a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019ac:	eb d9                	jmp    80101987 <writei+0xfc>
    return -1;
801019ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019b3:	eb d2                	jmp    80101987 <writei+0xfc>
801019b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019ba:	eb cb                	jmp    80101987 <writei+0xfc>
    return -1;
801019bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019c1:	eb c4                	jmp    80101987 <writei+0xfc>

801019c3 <namecmp>:
{
801019c3:	f3 0f 1e fb          	endbr32 
801019c7:	55                   	push   %ebp
801019c8:	89 e5                	mov    %esp,%ebp
801019ca:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
801019cd:	6a 0e                	push   $0xe
801019cf:	ff 75 0c             	pushl  0xc(%ebp)
801019d2:	ff 75 08             	pushl  0x8(%ebp)
801019d5:	e8 10 24 00 00       	call   80103dea <strncmp>
}
801019da:	c9                   	leave  
801019db:	c3                   	ret    

801019dc <dirlookup>:
{
801019dc:	f3 0f 1e fb          	endbr32 
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	57                   	push   %edi
801019e4:	56                   	push   %esi
801019e5:	53                   	push   %ebx
801019e6:	83 ec 1c             	sub    $0x1c,%esp
801019e9:	8b 75 08             	mov    0x8(%ebp),%esi
801019ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(dp->type != T_DIR)
801019ef:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801019f4:	75 07                	jne    801019fd <dirlookup+0x21>
  for(off = 0; off < dp->size; off += sizeof(de)){
801019f6:	bb 00 00 00 00       	mov    $0x0,%ebx
801019fb:	eb 1d                	jmp    80101a1a <dirlookup+0x3e>
    panic("dirlookup not DIR");
801019fd:	83 ec 0c             	sub    $0xc,%esp
80101a00:	68 87 67 10 80       	push   $0x80106787
80101a05:	e8 4b e9 ff ff       	call   80100355 <panic>
      panic("dirlookup read");
80101a0a:	83 ec 0c             	sub    $0xc,%esp
80101a0d:	68 99 67 10 80       	push   $0x80106799
80101a12:	e8 3e e9 ff ff       	call   80100355 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a17:	83 c3 10             	add    $0x10,%ebx
80101a1a:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101a1d:	76 48                	jbe    80101a67 <dirlookup+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a1f:	6a 10                	push   $0x10
80101a21:	53                   	push   %ebx
80101a22:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101a25:	50                   	push   %eax
80101a26:	56                   	push   %esi
80101a27:	e8 5b fd ff ff       	call   80101787 <readi>
80101a2c:	83 c4 10             	add    $0x10,%esp
80101a2f:	83 f8 10             	cmp    $0x10,%eax
80101a32:	75 d6                	jne    80101a0a <dirlookup+0x2e>
    if(de.inum == 0)
80101a34:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a39:	74 dc                	je     80101a17 <dirlookup+0x3b>
    if(namecmp(name, de.name) == 0){
80101a3b:	83 ec 08             	sub    $0x8,%esp
80101a3e:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a41:	50                   	push   %eax
80101a42:	57                   	push   %edi
80101a43:	e8 7b ff ff ff       	call   801019c3 <namecmp>
80101a48:	83 c4 10             	add    $0x10,%esp
80101a4b:	85 c0                	test   %eax,%eax
80101a4d:	75 c8                	jne    80101a17 <dirlookup+0x3b>
      if(poff)
80101a4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101a53:	74 05                	je     80101a5a <dirlookup+0x7e>
        *poff = off;
80101a55:	8b 45 10             	mov    0x10(%ebp),%eax
80101a58:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101a5a:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101a5e:	8b 06                	mov    (%esi),%eax
80101a60:	e8 1f f7 ff ff       	call   80101184 <iget>
80101a65:	eb 05                	jmp    80101a6c <dirlookup+0x90>
  return 0;
80101a67:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101a6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a6f:	5b                   	pop    %ebx
80101a70:	5e                   	pop    %esi
80101a71:	5f                   	pop    %edi
80101a72:	5d                   	pop    %ebp
80101a73:	c3                   	ret    

80101a74 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101a74:	55                   	push   %ebp
80101a75:	89 e5                	mov    %esp,%ebp
80101a77:	57                   	push   %edi
80101a78:	56                   	push   %esi
80101a79:	53                   	push   %ebx
80101a7a:	83 ec 1c             	sub    $0x1c,%esp
80101a7d:	89 c3                	mov    %eax,%ebx
80101a7f:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101a82:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101a85:	80 38 2f             	cmpb   $0x2f,(%eax)
80101a88:	74 17                	je     80101aa1 <namex+0x2d>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101a8a:	e8 c2 17 00 00       	call   80103251 <myproc>
80101a8f:	83 ec 0c             	sub    $0xc,%esp
80101a92:	ff 70 68             	pushl  0x68(%eax)
80101a95:	e8 ba fa ff ff       	call   80101554 <idup>
80101a9a:	89 c6                	mov    %eax,%esi
80101a9c:	83 c4 10             	add    $0x10,%esp
80101a9f:	eb 53                	jmp    80101af4 <namex+0x80>
    ip = iget(ROOTDEV, ROOTINO);
80101aa1:	ba 01 00 00 00       	mov    $0x1,%edx
80101aa6:	b8 01 00 00 00       	mov    $0x1,%eax
80101aab:	e8 d4 f6 ff ff       	call   80101184 <iget>
80101ab0:	89 c6                	mov    %eax,%esi
80101ab2:	eb 40                	jmp    80101af4 <namex+0x80>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101ab4:	83 ec 0c             	sub    $0xc,%esp
80101ab7:	56                   	push   %esi
80101ab8:	e8 78 fc ff ff       	call   80101735 <iunlockput>
      return 0;
80101abd:	83 c4 10             	add    $0x10,%esp
80101ac0:	be 00 00 00 00       	mov    $0x0,%esi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101ac5:	89 f0                	mov    %esi,%eax
80101ac7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aca:	5b                   	pop    %ebx
80101acb:	5e                   	pop    %esi
80101acc:	5f                   	pop    %edi
80101acd:	5d                   	pop    %ebp
80101ace:	c3                   	ret    
    if((next = dirlookup(ip, name, 0)) == 0){
80101acf:	83 ec 04             	sub    $0x4,%esp
80101ad2:	6a 00                	push   $0x0
80101ad4:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ad7:	56                   	push   %esi
80101ad8:	e8 ff fe ff ff       	call   801019dc <dirlookup>
80101add:	89 c7                	mov    %eax,%edi
80101adf:	83 c4 10             	add    $0x10,%esp
80101ae2:	85 c0                	test   %eax,%eax
80101ae4:	74 4a                	je     80101b30 <namex+0xbc>
    iunlockput(ip);
80101ae6:	83 ec 0c             	sub    $0xc,%esp
80101ae9:	56                   	push   %esi
80101aea:	e8 46 fc ff ff       	call   80101735 <iunlockput>
80101aef:	83 c4 10             	add    $0x10,%esp
    ip = next;
80101af2:	89 fe                	mov    %edi,%esi
  while((path = skipelem(path, name)) != 0){
80101af4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101af7:	89 d8                	mov    %ebx,%eax
80101af9:	e8 46 f4 ff ff       	call   80100f44 <skipelem>
80101afe:	89 c3                	mov    %eax,%ebx
80101b00:	85 c0                	test   %eax,%eax
80101b02:	74 3c                	je     80101b40 <namex+0xcc>
    ilock(ip);
80101b04:	83 ec 0c             	sub    $0xc,%esp
80101b07:	56                   	push   %esi
80101b08:	e8 79 fa ff ff       	call   80101586 <ilock>
    if(ip->type != T_DIR){
80101b0d:	83 c4 10             	add    $0x10,%esp
80101b10:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101b15:	75 9d                	jne    80101ab4 <namex+0x40>
    if(nameiparent && *path == '\0'){
80101b17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b1b:	74 b2                	je     80101acf <namex+0x5b>
80101b1d:	80 3b 00             	cmpb   $0x0,(%ebx)
80101b20:	75 ad                	jne    80101acf <namex+0x5b>
      iunlock(ip);
80101b22:	83 ec 0c             	sub    $0xc,%esp
80101b25:	56                   	push   %esi
80101b26:	e8 1f fb ff ff       	call   8010164a <iunlock>
      return ip;
80101b2b:	83 c4 10             	add    $0x10,%esp
80101b2e:	eb 95                	jmp    80101ac5 <namex+0x51>
      iunlockput(ip);
80101b30:	83 ec 0c             	sub    $0xc,%esp
80101b33:	56                   	push   %esi
80101b34:	e8 fc fb ff ff       	call   80101735 <iunlockput>
      return 0;
80101b39:	83 c4 10             	add    $0x10,%esp
80101b3c:	89 fe                	mov    %edi,%esi
80101b3e:	eb 85                	jmp    80101ac5 <namex+0x51>
  if(nameiparent){
80101b40:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b44:	0f 84 7b ff ff ff    	je     80101ac5 <namex+0x51>
    iput(ip);
80101b4a:	83 ec 0c             	sub    $0xc,%esp
80101b4d:	56                   	push   %esi
80101b4e:	e8 40 fb ff ff       	call   80101693 <iput>
    return 0;
80101b53:	83 c4 10             	add    $0x10,%esp
80101b56:	89 de                	mov    %ebx,%esi
80101b58:	e9 68 ff ff ff       	jmp    80101ac5 <namex+0x51>

80101b5d <dirlink>:
{
80101b5d:	f3 0f 1e fb          	endbr32 
80101b61:	55                   	push   %ebp
80101b62:	89 e5                	mov    %esp,%ebp
80101b64:	57                   	push   %edi
80101b65:	56                   	push   %esi
80101b66:	53                   	push   %ebx
80101b67:	83 ec 20             	sub    $0x20,%esp
80101b6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101b6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101b70:	6a 00                	push   $0x0
80101b72:	57                   	push   %edi
80101b73:	53                   	push   %ebx
80101b74:	e8 63 fe ff ff       	call   801019dc <dirlookup>
80101b79:	83 c4 10             	add    $0x10,%esp
80101b7c:	85 c0                	test   %eax,%eax
80101b7e:	75 07                	jne    80101b87 <dirlink+0x2a>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b80:	b8 00 00 00 00       	mov    $0x0,%eax
80101b85:	eb 23                	jmp    80101baa <dirlink+0x4d>
    iput(ip);
80101b87:	83 ec 0c             	sub    $0xc,%esp
80101b8a:	50                   	push   %eax
80101b8b:	e8 03 fb ff ff       	call   80101693 <iput>
    return -1;
80101b90:	83 c4 10             	add    $0x10,%esp
80101b93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b98:	eb 63                	jmp    80101bfd <dirlink+0xa0>
      panic("dirlink read");
80101b9a:	83 ec 0c             	sub    $0xc,%esp
80101b9d:	68 a8 67 10 80       	push   $0x801067a8
80101ba2:	e8 ae e7 ff ff       	call   80100355 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ba7:	8d 46 10             	lea    0x10(%esi),%eax
80101baa:	89 c6                	mov    %eax,%esi
80101bac:	39 43 58             	cmp    %eax,0x58(%ebx)
80101baf:	76 1c                	jbe    80101bcd <dirlink+0x70>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bb1:	6a 10                	push   $0x10
80101bb3:	50                   	push   %eax
80101bb4:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101bb7:	50                   	push   %eax
80101bb8:	53                   	push   %ebx
80101bb9:	e8 c9 fb ff ff       	call   80101787 <readi>
80101bbe:	83 c4 10             	add    $0x10,%esp
80101bc1:	83 f8 10             	cmp    $0x10,%eax
80101bc4:	75 d4                	jne    80101b9a <dirlink+0x3d>
    if(de.inum == 0)
80101bc6:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bcb:	75 da                	jne    80101ba7 <dirlink+0x4a>
  strncpy(de.name, name, DIRSIZ);
80101bcd:	83 ec 04             	sub    $0x4,%esp
80101bd0:	6a 0e                	push   $0xe
80101bd2:	57                   	push   %edi
80101bd3:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101bd6:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bd9:	50                   	push   %eax
80101bda:	e8 45 22 00 00       	call   80103e24 <strncpy>
  de.inum = inum;
80101bdf:	8b 45 10             	mov    0x10(%ebp),%eax
80101be2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be6:	6a 10                	push   $0x10
80101be8:	56                   	push   %esi
80101be9:	57                   	push   %edi
80101bea:	53                   	push   %ebx
80101beb:	e8 9b fc ff ff       	call   8010188b <writei>
80101bf0:	83 c4 20             	add    $0x20,%esp
80101bf3:	83 f8 10             	cmp    $0x10,%eax
80101bf6:	75 0d                	jne    80101c05 <dirlink+0xa8>
  return 0;
80101bf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101bfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c00:	5b                   	pop    %ebx
80101c01:	5e                   	pop    %esi
80101c02:	5f                   	pop    %edi
80101c03:	5d                   	pop    %ebp
80101c04:	c3                   	ret    
    panic("dirlink");
80101c05:	83 ec 0c             	sub    $0xc,%esp
80101c08:	68 98 6d 10 80       	push   $0x80106d98
80101c0d:	e8 43 e7 ff ff       	call   80100355 <panic>

80101c12 <namei>:

struct inode*
namei(char *path)
{
80101c12:	f3 0f 1e fb          	endbr32 
80101c16:	55                   	push   %ebp
80101c17:	89 e5                	mov    %esp,%ebp
80101c19:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101c1c:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101c1f:	ba 00 00 00 00       	mov    $0x0,%edx
80101c24:	8b 45 08             	mov    0x8(%ebp),%eax
80101c27:	e8 48 fe ff ff       	call   80101a74 <namex>
}
80101c2c:	c9                   	leave  
80101c2d:	c3                   	ret    

80101c2e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101c2e:	f3 0f 1e fb          	endbr32 
80101c32:	55                   	push   %ebp
80101c33:	89 e5                	mov    %esp,%ebp
80101c35:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101c38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101c3b:	ba 01 00 00 00       	mov    $0x1,%edx
80101c40:	8b 45 08             	mov    0x8(%ebp),%eax
80101c43:	e8 2c fe ff ff       	call   80101a74 <namex>
}
80101c48:	c9                   	leave  
80101c49:	c3                   	ret    

80101c4a <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80101c4a:	89 c1                	mov    %eax,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101c4c:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c51:	ec                   	in     (%dx),%al
80101c52:	88 c2                	mov    %al,%dl
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101c54:	83 e0 c0             	and    $0xffffffc0,%eax
80101c57:	3c 40                	cmp    $0x40,%al
80101c59:	75 f1                	jne    80101c4c <idewait+0x2>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101c5b:	85 c9                	test   %ecx,%ecx
80101c5d:	74 0a                	je     80101c69 <idewait+0x1f>
80101c5f:	f6 c2 21             	test   $0x21,%dl
80101c62:	75 08                	jne    80101c6c <idewait+0x22>
    return -1;
  return 0;
80101c64:	b9 00 00 00 00       	mov    $0x0,%ecx
}
80101c69:	89 c8                	mov    %ecx,%eax
80101c6b:	c3                   	ret    
    return -1;
80101c6c:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80101c71:	eb f6                	jmp    80101c69 <idewait+0x1f>

80101c73 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101c73:	55                   	push   %ebp
80101c74:	89 e5                	mov    %esp,%ebp
80101c76:	56                   	push   %esi
80101c77:	53                   	push   %ebx
  if(b == 0)
80101c78:	85 c0                	test   %eax,%eax
80101c7a:	0f 84 87 00 00 00    	je     80101d07 <idestart+0x94>
80101c80:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101c82:	8b 58 08             	mov    0x8(%eax),%ebx
80101c85:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101c8b:	0f 87 83 00 00 00    	ja     80101d14 <idestart+0xa1>
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
80101c91:	b8 00 00 00 00       	mov    $0x0,%eax
80101c96:	e8 af ff ff ff       	call   80101c4a <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101c9b:	b0 00                	mov    $0x0,%al
80101c9d:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101ca2:	ee                   	out    %al,(%dx)
80101ca3:	b0 01                	mov    $0x1,%al
80101ca5:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101caa:	ee                   	out    %al,(%dx)
80101cab:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101cb0:	88 d8                	mov    %bl,%al
80101cb2:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101cb3:	89 d8                	mov    %ebx,%eax
80101cb5:	c1 f8 08             	sar    $0x8,%eax
80101cb8:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101cbd:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101cbe:	89 d8                	mov    %ebx,%eax
80101cc0:	c1 f8 10             	sar    $0x10,%eax
80101cc3:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101cc8:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101cc9:	8a 46 04             	mov    0x4(%esi),%al
80101ccc:	c1 e0 04             	shl    $0x4,%eax
80101ccf:	83 e0 10             	and    $0x10,%eax
80101cd2:	c1 fb 18             	sar    $0x18,%ebx
80101cd5:	83 e3 0f             	and    $0xf,%ebx
80101cd8:	09 d8                	or     %ebx,%eax
80101cda:	83 c8 e0             	or     $0xffffffe0,%eax
80101cdd:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101ce2:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101ce3:	f6 06 04             	testb  $0x4,(%esi)
80101ce6:	74 39                	je     80101d21 <idestart+0xae>
80101ce8:	b0 30                	mov    $0x30,%al
80101cea:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101cef:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101cf0:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101cf3:	b9 80 00 00 00       	mov    $0x80,%ecx
80101cf8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101cfd:	fc                   	cld    
80101cfe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101d00:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d03:	5b                   	pop    %ebx
80101d04:	5e                   	pop    %esi
80101d05:	5d                   	pop    %ebp
80101d06:	c3                   	ret    
    panic("idestart");
80101d07:	83 ec 0c             	sub    $0xc,%esp
80101d0a:	68 0b 68 10 80       	push   $0x8010680b
80101d0f:	e8 41 e6 ff ff       	call   80100355 <panic>
    panic("incorrect blockno");
80101d14:	83 ec 0c             	sub    $0xc,%esp
80101d17:	68 14 68 10 80       	push   $0x80106814
80101d1c:	e8 34 e6 ff ff       	call   80100355 <panic>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d21:	b0 20                	mov    $0x20,%al
80101d23:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d28:	ee                   	out    %al,(%dx)
}
80101d29:	eb d5                	jmp    80101d00 <idestart+0x8d>

80101d2b <ideinit>:
{
80101d2b:	f3 0f 1e fb          	endbr32 
80101d2f:	55                   	push   %ebp
80101d30:	89 e5                	mov    %esp,%ebp
80101d32:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101d35:	68 26 68 10 80       	push   $0x80106826
80101d3a:	68 80 a5 10 80       	push   $0x8010a580
80101d3f:	e8 bd 1d 00 00       	call   80103b01 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101d44:	83 c4 08             	add    $0x8,%esp
80101d47:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101d4c:	48                   	dec    %eax
80101d4d:	50                   	push   %eax
80101d4e:	6a 0e                	push   $0xe
80101d50:	e8 50 02 00 00       	call   80101fa5 <ioapicenable>
  idewait(0);
80101d55:	b8 00 00 00 00       	mov    $0x0,%eax
80101d5a:	e8 eb fe ff ff       	call   80101c4a <idewait>
80101d5f:	b0 f0                	mov    $0xf0,%al
80101d61:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d66:	ee                   	out    %al,(%dx)
  for(i=0; i<1000; i++){
80101d67:	83 c4 10             	add    $0x10,%esp
80101d6a:	b9 00 00 00 00       	mov    $0x0,%ecx
80101d6f:	eb 01                	jmp    80101d72 <ideinit+0x47>
80101d71:	41                   	inc    %ecx
80101d72:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101d78:	7f 14                	jg     80101d8e <ideinit+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d7a:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d7f:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101d80:	84 c0                	test   %al,%al
80101d82:	74 ed                	je     80101d71 <ideinit+0x46>
      havedisk1 = 1;
80101d84:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80101d8b:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d8e:	b0 e0                	mov    $0xe0,%al
80101d90:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d95:	ee                   	out    %al,(%dx)
}
80101d96:	c9                   	leave  
80101d97:	c3                   	ret    

80101d98 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101d98:	f3 0f 1e fb          	endbr32 
80101d9c:	55                   	push   %ebp
80101d9d:	89 e5                	mov    %esp,%ebp
80101d9f:	57                   	push   %edi
80101da0:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101da1:	83 ec 0c             	sub    $0xc,%esp
80101da4:	68 80 a5 10 80       	push   $0x8010a580
80101da9:	e8 9e 1e 00 00       	call   80103c4c <acquire>

  if((b = idequeue) == 0){
80101dae:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80101db4:	83 c4 10             	add    $0x10,%esp
80101db7:	85 db                	test   %ebx,%ebx
80101db9:	74 48                	je     80101e03 <ideintr+0x6b>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101dbb:	8b 43 58             	mov    0x58(%ebx),%eax
80101dbe:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101dc3:	f6 03 04             	testb  $0x4,(%ebx)
80101dc6:	74 4d                	je     80101e15 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80101dc8:	8b 03                	mov    (%ebx),%eax
80101dca:	83 c8 02             	or     $0x2,%eax
  b->flags &= ~B_DIRTY;
80101dcd:	83 e0 fb             	and    $0xfffffffb,%eax
80101dd0:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101dd2:	83 ec 0c             	sub    $0xc,%esp
80101dd5:	53                   	push   %ebx
80101dd6:	e8 b2 1a 00 00       	call   8010388d <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101ddb:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80101de0:	83 c4 10             	add    $0x10,%esp
80101de3:	85 c0                	test   %eax,%eax
80101de5:	74 05                	je     80101dec <ideintr+0x54>
    idestart(idequeue);
80101de7:	e8 87 fe ff ff       	call   80101c73 <idestart>

  release(&idelock);
80101dec:	83 ec 0c             	sub    $0xc,%esp
80101def:	68 80 a5 10 80       	push   $0x8010a580
80101df4:	e8 bc 1e 00 00       	call   80103cb5 <release>
80101df9:	83 c4 10             	add    $0x10,%esp
}
80101dfc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101dff:	5b                   	pop    %ebx
80101e00:	5f                   	pop    %edi
80101e01:	5d                   	pop    %ebp
80101e02:	c3                   	ret    
    release(&idelock);
80101e03:	83 ec 0c             	sub    $0xc,%esp
80101e06:	68 80 a5 10 80       	push   $0x8010a580
80101e0b:	e8 a5 1e 00 00       	call   80103cb5 <release>
    return;
80101e10:	83 c4 10             	add    $0x10,%esp
80101e13:	eb e7                	jmp    80101dfc <ideintr+0x64>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e15:	b8 01 00 00 00       	mov    $0x1,%eax
80101e1a:	e8 2b fe ff ff       	call   80101c4a <idewait>
80101e1f:	85 c0                	test   %eax,%eax
80101e21:	78 a5                	js     80101dc8 <ideintr+0x30>
    insl(0x1f0, b->data, BSIZE/4);
80101e23:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101e26:	b9 80 00 00 00       	mov    $0x80,%ecx
80101e2b:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101e30:	fc                   	cld    
80101e31:	f3 6d                	rep insl (%dx),%es:(%edi)
}
80101e33:	eb 93                	jmp    80101dc8 <ideintr+0x30>

80101e35 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101e35:	f3 0f 1e fb          	endbr32 
80101e39:	55                   	push   %ebp
80101e3a:	89 e5                	mov    %esp,%ebp
80101e3c:	53                   	push   %ebx
80101e3d:	83 ec 10             	sub    $0x10,%esp
80101e40:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101e43:	8d 43 0c             	lea    0xc(%ebx),%eax
80101e46:	50                   	push   %eax
80101e47:	e8 63 1c 00 00       	call   80103aaf <holdingsleep>
80101e4c:	83 c4 10             	add    $0x10,%esp
80101e4f:	85 c0                	test   %eax,%eax
80101e51:	74 37                	je     80101e8a <iderw+0x55>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101e53:	8b 03                	mov    (%ebx),%eax
80101e55:	83 e0 06             	and    $0x6,%eax
80101e58:	83 f8 02             	cmp    $0x2,%eax
80101e5b:	74 3a                	je     80101e97 <iderw+0x62>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101e5d:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101e61:	74 09                	je     80101e6c <iderw+0x37>
80101e63:	83 3d 60 a5 10 80 00 	cmpl   $0x0,0x8010a560
80101e6a:	74 38                	je     80101ea4 <iderw+0x6f>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101e6c:	83 ec 0c             	sub    $0xc,%esp
80101e6f:	68 80 a5 10 80       	push   $0x8010a580
80101e74:	e8 d3 1d 00 00       	call   80103c4c <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101e79:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101e80:	83 c4 10             	add    $0x10,%esp
80101e83:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80101e88:	eb 2a                	jmp    80101eb4 <iderw+0x7f>
    panic("iderw: buf not locked");
80101e8a:	83 ec 0c             	sub    $0xc,%esp
80101e8d:	68 2a 68 10 80       	push   $0x8010682a
80101e92:	e8 be e4 ff ff       	call   80100355 <panic>
    panic("iderw: nothing to do");
80101e97:	83 ec 0c             	sub    $0xc,%esp
80101e9a:	68 40 68 10 80       	push   $0x80106840
80101e9f:	e8 b1 e4 ff ff       	call   80100355 <panic>
    panic("iderw: ide disk 1 not present");
80101ea4:	83 ec 0c             	sub    $0xc,%esp
80101ea7:	68 55 68 10 80       	push   $0x80106855
80101eac:	e8 a4 e4 ff ff       	call   80100355 <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101eb1:	8d 50 58             	lea    0x58(%eax),%edx
80101eb4:	8b 02                	mov    (%edx),%eax
80101eb6:	85 c0                	test   %eax,%eax
80101eb8:	75 f7                	jne    80101eb1 <iderw+0x7c>
    ;
  *pp = b;
80101eba:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101ebc:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80101ec2:	75 1a                	jne    80101ede <iderw+0xa9>
    idestart(b);
80101ec4:	89 d8                	mov    %ebx,%eax
80101ec6:	e8 a8 fd ff ff       	call   80101c73 <idestart>
80101ecb:	eb 11                	jmp    80101ede <iderw+0xa9>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80101ecd:	83 ec 08             	sub    $0x8,%esp
80101ed0:	68 80 a5 10 80       	push   $0x8010a580
80101ed5:	53                   	push   %ebx
80101ed6:	e8 43 18 00 00       	call   8010371e <sleep>
80101edb:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101ede:	8b 03                	mov    (%ebx),%eax
80101ee0:	83 e0 06             	and    $0x6,%eax
80101ee3:	83 f8 02             	cmp    $0x2,%eax
80101ee6:	75 e5                	jne    80101ecd <iderw+0x98>
  }


  release(&idelock);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	68 80 a5 10 80       	push   $0x8010a580
80101ef0:	e8 c0 1d 00 00       	call   80103cb5 <release>
}
80101ef5:	83 c4 10             	add    $0x10,%esp
80101ef8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101efb:	c9                   	leave  
80101efc:	c3                   	ret    

80101efd <ioapicread>:
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80101efd:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80101f03:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
80101f05:	a1 34 26 11 80       	mov    0x80112634,%eax
80101f0a:	8b 40 10             	mov    0x10(%eax),%eax
}
80101f0d:	c3                   	ret    

80101f0e <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80101f0e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80101f14:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101f16:	a1 34 26 11 80       	mov    0x80112634,%eax
80101f1b:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f1e:	c3                   	ret    

80101f1f <ioapicinit>:

void
ioapicinit(void)
{
80101f1f:	f3 0f 1e fb          	endbr32 
80101f23:	55                   	push   %ebp
80101f24:	89 e5                	mov    %esp,%ebp
80101f26:	57                   	push   %edi
80101f27:	56                   	push   %esi
80101f28:	53                   	push   %ebx
80101f29:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101f2c:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80101f33:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101f36:	b8 01 00 00 00       	mov    $0x1,%eax
80101f3b:	e8 bd ff ff ff       	call   80101efd <ioapicread>
80101f40:	c1 e8 10             	shr    $0x10,%eax
80101f43:	0f b6 f8             	movzbl %al,%edi
  id = ioapicread(REG_ID) >> 24;
80101f46:	b8 00 00 00 00       	mov    $0x0,%eax
80101f4b:	e8 ad ff ff ff       	call   80101efd <ioapicread>
80101f50:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101f53:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
80101f5a:	39 c2                	cmp    %eax,%edx
80101f5c:	75 2d                	jne    80101f8b <ioapicinit+0x6c>
{
80101f5e:	bb 00 00 00 00       	mov    $0x0,%ebx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80101f63:	39 fb                	cmp    %edi,%ebx
80101f65:	7f 36                	jg     80101f9d <ioapicinit+0x7e>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101f67:	8d 53 20             	lea    0x20(%ebx),%edx
80101f6a:	81 ca 00 00 01 00    	or     $0x10000,%edx
80101f70:	8d 74 1b 10          	lea    0x10(%ebx,%ebx,1),%esi
80101f74:	89 f0                	mov    %esi,%eax
80101f76:	e8 93 ff ff ff       	call   80101f0e <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80101f7b:	8d 46 01             	lea    0x1(%esi),%eax
80101f7e:	ba 00 00 00 00       	mov    $0x0,%edx
80101f83:	e8 86 ff ff ff       	call   80101f0e <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80101f88:	43                   	inc    %ebx
80101f89:	eb d8                	jmp    80101f63 <ioapicinit+0x44>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80101f8b:	83 ec 0c             	sub    $0xc,%esp
80101f8e:	68 74 68 10 80       	push   $0x80106874
80101f93:	e8 65 e6 ff ff       	call   801005fd <cprintf>
80101f98:	83 c4 10             	add    $0x10,%esp
80101f9b:	eb c1                	jmp    80101f5e <ioapicinit+0x3f>
  }
}
80101f9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fa0:	5b                   	pop    %ebx
80101fa1:	5e                   	pop    %esi
80101fa2:	5f                   	pop    %edi
80101fa3:	5d                   	pop    %ebp
80101fa4:	c3                   	ret    

80101fa5 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80101fa5:	f3 0f 1e fb          	endbr32 
80101fa9:	55                   	push   %ebp
80101faa:	89 e5                	mov    %esp,%ebp
80101fac:	53                   	push   %ebx
80101fad:	83 ec 04             	sub    $0x4,%esp
80101fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80101fb3:	8d 50 20             	lea    0x20(%eax),%edx
80101fb6:	8d 5c 00 10          	lea    0x10(%eax,%eax,1),%ebx
80101fba:	89 d8                	mov    %ebx,%eax
80101fbc:	e8 4d ff ff ff       	call   80101f0e <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80101fc1:	8b 55 0c             	mov    0xc(%ebp),%edx
80101fc4:	c1 e2 18             	shl    $0x18,%edx
80101fc7:	8d 43 01             	lea    0x1(%ebx),%eax
80101fca:	e8 3f ff ff ff       	call   80101f0e <ioapicwrite>
}
80101fcf:	83 c4 04             	add    $0x4,%esp
80101fd2:	5b                   	pop    %ebx
80101fd3:	5d                   	pop    %ebp
80101fd4:	c3                   	ret    

80101fd5 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80101fd5:	f3 0f 1e fb          	endbr32 
80101fd9:	55                   	push   %ebp
80101fda:	89 e5                	mov    %esp,%ebp
80101fdc:	53                   	push   %ebx
80101fdd:	83 ec 04             	sub    $0x4,%esp
80101fe0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80101fe3:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80101fe9:	75 4c                	jne    80102037 <kfree+0x62>
80101feb:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
80101ff1:	72 44                	jb     80102037 <kfree+0x62>
80101ff3:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80101ff9:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80101ffe:	77 37                	ja     80102037 <kfree+0x62>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102000:	83 ec 04             	sub    $0x4,%esp
80102003:	68 00 10 00 00       	push   $0x1000
80102008:	6a 01                	push   $0x1
8010200a:	53                   	push   %ebx
8010200b:	e8 f0 1c 00 00       	call   80103d00 <memset>

  if(kmem.use_lock)
80102010:	83 c4 10             	add    $0x10,%esp
80102013:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
8010201a:	75 28                	jne    80102044 <kfree+0x6f>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
8010201c:	a1 78 26 11 80       	mov    0x80112678,%eax
80102021:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80102023:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102029:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
80102030:	75 24                	jne    80102056 <kfree+0x81>
    release(&kmem.lock);
}
80102032:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102035:	c9                   	leave  
80102036:	c3                   	ret    
    panic("kfree");
80102037:	83 ec 0c             	sub    $0xc,%esp
8010203a:	68 a6 68 10 80       	push   $0x801068a6
8010203f:	e8 11 e3 ff ff       	call   80100355 <panic>
    acquire(&kmem.lock);
80102044:	83 ec 0c             	sub    $0xc,%esp
80102047:	68 40 26 11 80       	push   $0x80112640
8010204c:	e8 fb 1b 00 00       	call   80103c4c <acquire>
80102051:	83 c4 10             	add    $0x10,%esp
80102054:	eb c6                	jmp    8010201c <kfree+0x47>
    release(&kmem.lock);
80102056:	83 ec 0c             	sub    $0xc,%esp
80102059:	68 40 26 11 80       	push   $0x80112640
8010205e:	e8 52 1c 00 00       	call   80103cb5 <release>
80102063:	83 c4 10             	add    $0x10,%esp
}
80102066:	eb ca                	jmp    80102032 <kfree+0x5d>

80102068 <freerange>:
{
80102068:	f3 0f 1e fb          	endbr32 
8010206c:	55                   	push   %ebp
8010206d:	89 e5                	mov    %esp,%ebp
8010206f:	56                   	push   %esi
80102070:	53                   	push   %ebx
80102071:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102074:	8b 45 08             	mov    0x8(%ebp),%eax
80102077:	05 ff 0f 00 00       	add    $0xfff,%eax
8010207c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102081:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi
80102087:	39 de                	cmp    %ebx,%esi
80102089:	77 10                	ja     8010209b <freerange+0x33>
    kfree(p);
8010208b:	83 ec 0c             	sub    $0xc,%esp
8010208e:	50                   	push   %eax
8010208f:	e8 41 ff ff ff       	call   80101fd5 <kfree>
80102094:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102097:	89 f0                	mov    %esi,%eax
80102099:	eb e6                	jmp    80102081 <freerange+0x19>
}
8010209b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010209e:	5b                   	pop    %ebx
8010209f:	5e                   	pop    %esi
801020a0:	5d                   	pop    %ebp
801020a1:	c3                   	ret    

801020a2 <kinit1>:
{
801020a2:	f3 0f 1e fb          	endbr32 
801020a6:	55                   	push   %ebp
801020a7:	89 e5                	mov    %esp,%ebp
801020a9:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
801020ac:	68 ac 68 10 80       	push   $0x801068ac
801020b1:	68 40 26 11 80       	push   $0x80112640
801020b6:	e8 46 1a 00 00       	call   80103b01 <initlock>
  kmem.use_lock = 0;
801020bb:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801020c2:	00 00 00 
  freerange(vstart, vend);
801020c5:	83 c4 08             	add    $0x8,%esp
801020c8:	ff 75 0c             	pushl  0xc(%ebp)
801020cb:	ff 75 08             	pushl  0x8(%ebp)
801020ce:	e8 95 ff ff ff       	call   80102068 <freerange>
}
801020d3:	83 c4 10             	add    $0x10,%esp
801020d6:	c9                   	leave  
801020d7:	c3                   	ret    

801020d8 <kinit2>:
{
801020d8:	f3 0f 1e fb          	endbr32 
801020dc:	55                   	push   %ebp
801020dd:	89 e5                	mov    %esp,%ebp
801020df:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
801020e2:	ff 75 0c             	pushl  0xc(%ebp)
801020e5:	ff 75 08             	pushl  0x8(%ebp)
801020e8:	e8 7b ff ff ff       	call   80102068 <freerange>
  kmem.use_lock = 1;
801020ed:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801020f4:	00 00 00 
}
801020f7:	83 c4 10             	add    $0x10,%esp
801020fa:	c9                   	leave  
801020fb:	c3                   	ret    

801020fc <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801020fc:	f3 0f 1e fb          	endbr32 
80102100:	55                   	push   %ebp
80102101:	89 e5                	mov    %esp,%ebp
80102103:	53                   	push   %ebx
80102104:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102107:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
8010210e:	75 21                	jne    80102131 <kalloc+0x35>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102110:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102116:	85 db                	test   %ebx,%ebx
80102118:	74 07                	je     80102121 <kalloc+0x25>
    kmem.freelist = r->next;
8010211a:	8b 03                	mov    (%ebx),%eax
8010211c:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
80102121:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
80102128:	75 19                	jne    80102143 <kalloc+0x47>
    release(&kmem.lock);
  return (char*)r;
}
8010212a:	89 d8                	mov    %ebx,%eax
8010212c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010212f:	c9                   	leave  
80102130:	c3                   	ret    
    acquire(&kmem.lock);
80102131:	83 ec 0c             	sub    $0xc,%esp
80102134:	68 40 26 11 80       	push   $0x80112640
80102139:	e8 0e 1b 00 00       	call   80103c4c <acquire>
8010213e:	83 c4 10             	add    $0x10,%esp
80102141:	eb cd                	jmp    80102110 <kalloc+0x14>
    release(&kmem.lock);
80102143:	83 ec 0c             	sub    $0xc,%esp
80102146:	68 40 26 11 80       	push   $0x80112640
8010214b:	e8 65 1b 00 00       	call   80103cb5 <release>
80102150:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102153:	eb d5                	jmp    8010212a <kalloc+0x2e>

80102155 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102155:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102159:	ba 64 00 00 00       	mov    $0x64,%edx
8010215e:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010215f:	a8 01                	test   $0x1,%al
80102161:	0f 84 ac 00 00 00    	je     80102213 <kbdgetc+0xbe>
80102167:	ba 60 00 00 00       	mov    $0x60,%edx
8010216c:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
8010216d:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102170:	3c e0                	cmp    $0xe0,%al
80102172:	74 5b                	je     801021cf <kbdgetc+0x7a>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102174:	84 c0                	test   %al,%al
80102176:	78 64                	js     801021dc <kbdgetc+0x87>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102178:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
8010217e:	f6 c1 40             	test   $0x40,%cl
80102181:	74 0f                	je     80102192 <kbdgetc+0x3d>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102183:	83 c8 80             	or     $0xffffff80,%eax
80102186:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
80102189:	83 e1 bf             	and    $0xffffffbf,%ecx
8010218c:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  }

  shift |= shiftcode[data];
80102192:	0f b6 8a e0 69 10 80 	movzbl -0x7fef9620(%edx),%ecx
80102199:	0b 0d b4 a5 10 80    	or     0x8010a5b4,%ecx
  shift ^= togglecode[data];
8010219f:	0f b6 82 e0 68 10 80 	movzbl -0x7fef9720(%edx),%eax
801021a6:	31 c1                	xor    %eax,%ecx
801021a8:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801021ae:	89 c8                	mov    %ecx,%eax
801021b0:	83 e0 03             	and    $0x3,%eax
801021b3:	8b 04 85 c0 68 10 80 	mov    -0x7fef9740(,%eax,4),%eax
801021ba:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801021be:	f6 c1 08             	test   $0x8,%cl
801021c1:	74 55                	je     80102218 <kbdgetc+0xc3>
    if('a' <= c && c <= 'z')
801021c3:	8d 50 9f             	lea    -0x61(%eax),%edx
801021c6:	83 fa 19             	cmp    $0x19,%edx
801021c9:	77 3c                	ja     80102207 <kbdgetc+0xb2>
      c += 'A' - 'a';
801021cb:	83 e8 20             	sub    $0x20,%eax
801021ce:	c3                   	ret    
    shift |= E0ESC;
801021cf:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801021d6:	b8 00 00 00 00       	mov    $0x0,%eax
801021db:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
801021dc:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
801021e2:	f6 c1 40             	test   $0x40,%cl
801021e5:	75 05                	jne    801021ec <kbdgetc+0x97>
801021e7:	89 c2                	mov    %eax,%edx
801021e9:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801021ec:	8a 82 e0 69 10 80    	mov    -0x7fef9620(%edx),%al
801021f2:	83 c8 40             	or     $0x40,%eax
801021f5:	0f b6 c0             	movzbl %al,%eax
801021f8:	f7 d0                	not    %eax
801021fa:	21 c8                	and    %ecx,%eax
801021fc:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
80102201:	b8 00 00 00 00       	mov    $0x0,%eax
80102206:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
80102207:	8d 50 bf             	lea    -0x41(%eax),%edx
8010220a:	83 fa 19             	cmp    $0x19,%edx
8010220d:	77 09                	ja     80102218 <kbdgetc+0xc3>
      c += 'a' - 'A';
8010220f:	83 c0 20             	add    $0x20,%eax
  }
  return c;
80102212:	c3                   	ret    
    return -1;
80102213:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102218:	c3                   	ret    

80102219 <kbdintr>:

void
kbdintr(void)
{
80102219:	f3 0f 1e fb          	endbr32 
8010221d:	55                   	push   %ebp
8010221e:	89 e5                	mov    %esp,%ebp
80102220:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102223:	68 55 21 10 80       	push   $0x80102155
80102228:	e8 f9 e4 ff ff       	call   80100726 <consoleintr>
}
8010222d:	83 c4 10             	add    $0x10,%esp
80102230:	c9                   	leave  
80102231:	c3                   	ret    

80102232 <lapicw>:

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102232:	8b 0d 7c 26 11 80    	mov    0x8011267c,%ecx
80102238:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010223b:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010223d:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102242:	8b 40 20             	mov    0x20(%eax),%eax
}
80102245:	c3                   	ret    

80102246 <cmos_read>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102246:	ba 70 00 00 00       	mov    $0x70,%edx
8010224b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010224c:	ba 71 00 00 00       	mov    $0x71,%edx
80102251:	ec                   	in     (%dx),%al
cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102252:	0f b6 c0             	movzbl %al,%eax
}
80102255:	c3                   	ret    

80102256 <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
80102256:	55                   	push   %ebp
80102257:	89 e5                	mov    %esp,%ebp
80102259:	53                   	push   %ebx
8010225a:	83 ec 04             	sub    $0x4,%esp
8010225d:	89 c3                	mov    %eax,%ebx
  r->second = cmos_read(SECS);
8010225f:	b8 00 00 00 00       	mov    $0x0,%eax
80102264:	e8 dd ff ff ff       	call   80102246 <cmos_read>
80102269:	89 03                	mov    %eax,(%ebx)
  r->minute = cmos_read(MINS);
8010226b:	b8 02 00 00 00       	mov    $0x2,%eax
80102270:	e8 d1 ff ff ff       	call   80102246 <cmos_read>
80102275:	89 43 04             	mov    %eax,0x4(%ebx)
  r->hour   = cmos_read(HOURS);
80102278:	b8 04 00 00 00       	mov    $0x4,%eax
8010227d:	e8 c4 ff ff ff       	call   80102246 <cmos_read>
80102282:	89 43 08             	mov    %eax,0x8(%ebx)
  r->day    = cmos_read(DAY);
80102285:	b8 07 00 00 00       	mov    $0x7,%eax
8010228a:	e8 b7 ff ff ff       	call   80102246 <cmos_read>
8010228f:	89 43 0c             	mov    %eax,0xc(%ebx)
  r->month  = cmos_read(MONTH);
80102292:	b8 08 00 00 00       	mov    $0x8,%eax
80102297:	e8 aa ff ff ff       	call   80102246 <cmos_read>
8010229c:	89 43 10             	mov    %eax,0x10(%ebx)
  r->year   = cmos_read(YEAR);
8010229f:	b8 09 00 00 00       	mov    $0x9,%eax
801022a4:	e8 9d ff ff ff       	call   80102246 <cmos_read>
801022a9:	89 43 14             	mov    %eax,0x14(%ebx)
}
801022ac:	83 c4 04             	add    $0x4,%esp
801022af:	5b                   	pop    %ebx
801022b0:	5d                   	pop    %ebp
801022b1:	c3                   	ret    

801022b2 <lapicinit>:
{
801022b2:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801022b6:	83 3d 7c 26 11 80 00 	cmpl   $0x0,0x8011267c
801022bd:	0f 84 fe 00 00 00    	je     801023c1 <lapicinit+0x10f>
{
801022c3:	55                   	push   %ebp
801022c4:	89 e5                	mov    %esp,%ebp
801022c6:	83 ec 08             	sub    $0x8,%esp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801022c9:	ba 3f 01 00 00       	mov    $0x13f,%edx
801022ce:	b8 3c 00 00 00       	mov    $0x3c,%eax
801022d3:	e8 5a ff ff ff       	call   80102232 <lapicw>
  lapicw(TDCR, X1);
801022d8:	ba 0b 00 00 00       	mov    $0xb,%edx
801022dd:	b8 f8 00 00 00       	mov    $0xf8,%eax
801022e2:	e8 4b ff ff ff       	call   80102232 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
801022e7:	ba 20 00 02 00       	mov    $0x20020,%edx
801022ec:	b8 c8 00 00 00       	mov    $0xc8,%eax
801022f1:	e8 3c ff ff ff       	call   80102232 <lapicw>
  lapicw(TICR, 10000000);
801022f6:	ba 80 96 98 00       	mov    $0x989680,%edx
801022fb:	b8 e0 00 00 00       	mov    $0xe0,%eax
80102300:	e8 2d ff ff ff       	call   80102232 <lapicw>
  lapicw(LINT0, MASKED);
80102305:	ba 00 00 01 00       	mov    $0x10000,%edx
8010230a:	b8 d4 00 00 00       	mov    $0xd4,%eax
8010230f:	e8 1e ff ff ff       	call   80102232 <lapicw>
  lapicw(LINT1, MASKED);
80102314:	ba 00 00 01 00       	mov    $0x10000,%edx
80102319:	b8 d8 00 00 00       	mov    $0xd8,%eax
8010231e:	e8 0f ff ff ff       	call   80102232 <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102323:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102328:	8b 40 30             	mov    0x30(%eax),%eax
8010232b:	c1 e8 10             	shr    $0x10,%eax
8010232e:	a8 fc                	test   $0xfc,%al
80102330:	75 7b                	jne    801023ad <lapicinit+0xfb>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102332:	ba 33 00 00 00       	mov    $0x33,%edx
80102337:	b8 dc 00 00 00       	mov    $0xdc,%eax
8010233c:	e8 f1 fe ff ff       	call   80102232 <lapicw>
  lapicw(ESR, 0);
80102341:	ba 00 00 00 00       	mov    $0x0,%edx
80102346:	b8 a0 00 00 00       	mov    $0xa0,%eax
8010234b:	e8 e2 fe ff ff       	call   80102232 <lapicw>
  lapicw(ESR, 0);
80102350:	ba 00 00 00 00       	mov    $0x0,%edx
80102355:	b8 a0 00 00 00       	mov    $0xa0,%eax
8010235a:	e8 d3 fe ff ff       	call   80102232 <lapicw>
  lapicw(EOI, 0);
8010235f:	ba 00 00 00 00       	mov    $0x0,%edx
80102364:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102369:	e8 c4 fe ff ff       	call   80102232 <lapicw>
  lapicw(ICRHI, 0);
8010236e:	ba 00 00 00 00       	mov    $0x0,%edx
80102373:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102378:	e8 b5 fe ff ff       	call   80102232 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
8010237d:	ba 00 85 08 00       	mov    $0x88500,%edx
80102382:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102387:	e8 a6 fe ff ff       	call   80102232 <lapicw>
  while(lapic[ICRLO] & DELIVS)
8010238c:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102391:	8b 80 00 03 00 00    	mov    0x300(%eax),%eax
80102397:	f6 c4 10             	test   $0x10,%ah
8010239a:	75 f0                	jne    8010238c <lapicinit+0xda>
  lapicw(TPR, 0);
8010239c:	ba 00 00 00 00       	mov    $0x0,%edx
801023a1:	b8 20 00 00 00       	mov    $0x20,%eax
801023a6:	e8 87 fe ff ff       	call   80102232 <lapicw>
}
801023ab:	c9                   	leave  
801023ac:	c3                   	ret    
    lapicw(PCINT, MASKED);
801023ad:	ba 00 00 01 00       	mov    $0x10000,%edx
801023b2:	b8 d0 00 00 00       	mov    $0xd0,%eax
801023b7:	e8 76 fe ff ff       	call   80102232 <lapicw>
801023bc:	e9 71 ff ff ff       	jmp    80102332 <lapicinit+0x80>
801023c1:	c3                   	ret    

801023c2 <lapicid>:
{
801023c2:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801023c6:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801023cb:	85 c0                	test   %eax,%eax
801023cd:	74 07                	je     801023d6 <lapicid+0x14>
  return lapic[ID] >> 24;
801023cf:	8b 40 20             	mov    0x20(%eax),%eax
801023d2:	c1 e8 18             	shr    $0x18,%eax
801023d5:	c3                   	ret    
    return 0;
801023d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801023db:	c3                   	ret    

801023dc <lapiceoi>:
{
801023dc:	f3 0f 1e fb          	endbr32 
  if(lapic)
801023e0:	83 3d 7c 26 11 80 00 	cmpl   $0x0,0x8011267c
801023e7:	74 17                	je     80102400 <lapiceoi+0x24>
{
801023e9:	55                   	push   %ebp
801023ea:	89 e5                	mov    %esp,%ebp
801023ec:	83 ec 08             	sub    $0x8,%esp
    lapicw(EOI, 0);
801023ef:	ba 00 00 00 00       	mov    $0x0,%edx
801023f4:	b8 2c 00 00 00       	mov    $0x2c,%eax
801023f9:	e8 34 fe ff ff       	call   80102232 <lapicw>
}
801023fe:	c9                   	leave  
801023ff:	c3                   	ret    
80102400:	c3                   	ret    

80102401 <microdelay>:
{
80102401:	f3 0f 1e fb          	endbr32 
}
80102405:	c3                   	ret    

80102406 <lapicstartap>:
{
80102406:	f3 0f 1e fb          	endbr32 
8010240a:	55                   	push   %ebp
8010240b:	89 e5                	mov    %esp,%ebp
8010240d:	57                   	push   %edi
8010240e:	56                   	push   %esi
8010240f:	53                   	push   %ebx
80102410:	83 ec 0c             	sub    $0xc,%esp
80102413:	8b 75 08             	mov    0x8(%ebp),%esi
80102416:	8b 7d 0c             	mov    0xc(%ebp),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102419:	b0 0f                	mov    $0xf,%al
8010241b:	ba 70 00 00 00       	mov    $0x70,%edx
80102420:	ee                   	out    %al,(%dx)
80102421:	b0 0a                	mov    $0xa,%al
80102423:	ba 71 00 00 00       	mov    $0x71,%edx
80102428:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
80102429:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
80102430:	00 00 
  wrv[1] = addr >> 4;
80102432:	89 f8                	mov    %edi,%eax
80102434:	c1 e8 04             	shr    $0x4,%eax
80102437:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
8010243d:	c1 e6 18             	shl    $0x18,%esi
80102440:	89 f2                	mov    %esi,%edx
80102442:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102447:	e8 e6 fd ff ff       	call   80102232 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010244c:	ba 00 c5 00 00       	mov    $0xc500,%edx
80102451:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102456:	e8 d7 fd ff ff       	call   80102232 <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
8010245b:	ba 00 85 00 00       	mov    $0x8500,%edx
80102460:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102465:	e8 c8 fd ff ff       	call   80102232 <lapicw>
  for(i = 0; i < 2; i++){
8010246a:	bb 00 00 00 00       	mov    $0x0,%ebx
8010246f:	eb 1f                	jmp    80102490 <lapicstartap+0x8a>
    lapicw(ICRHI, apicid<<24);
80102471:	89 f2                	mov    %esi,%edx
80102473:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102478:	e8 b5 fd ff ff       	call   80102232 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
8010247d:	89 fa                	mov    %edi,%edx
8010247f:	c1 ea 0c             	shr    $0xc,%edx
80102482:	80 ce 06             	or     $0x6,%dh
80102485:	b8 c0 00 00 00       	mov    $0xc0,%eax
8010248a:	e8 a3 fd ff ff       	call   80102232 <lapicw>
  for(i = 0; i < 2; i++){
8010248f:	43                   	inc    %ebx
80102490:	83 fb 01             	cmp    $0x1,%ebx
80102493:	7e dc                	jle    80102471 <lapicstartap+0x6b>
}
80102495:	83 c4 0c             	add    $0xc,%esp
80102498:	5b                   	pop    %ebx
80102499:	5e                   	pop    %esi
8010249a:	5f                   	pop    %edi
8010249b:	5d                   	pop    %ebp
8010249c:	c3                   	ret    

8010249d <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
8010249d:	f3 0f 1e fb          	endbr32 
801024a1:	55                   	push   %ebp
801024a2:	89 e5                	mov    %esp,%ebp
801024a4:	57                   	push   %edi
801024a5:	56                   	push   %esi
801024a6:	53                   	push   %ebx
801024a7:	83 ec 3c             	sub    $0x3c,%esp
801024aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801024ad:	b8 0b 00 00 00       	mov    $0xb,%eax
801024b2:	e8 8f fd ff ff       	call   80102246 <cmos_read>

  bcd = (sb & (1 << 2)) == 0;
801024b7:	83 e0 04             	and    $0x4,%eax
801024ba:	89 c7                	mov    %eax,%edi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
801024bc:	8d 45 d0             	lea    -0x30(%ebp),%eax
801024bf:	e8 92 fd ff ff       	call   80102256 <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801024c4:	b8 0a 00 00 00       	mov    $0xa,%eax
801024c9:	e8 78 fd ff ff       	call   80102246 <cmos_read>
801024ce:	a8 80                	test   $0x80,%al
801024d0:	75 ea                	jne    801024bc <cmostime+0x1f>
        continue;
    fill_rtcdate(&t2);
801024d2:	8d 75 b8             	lea    -0x48(%ebp),%esi
801024d5:	89 f0                	mov    %esi,%eax
801024d7:	e8 7a fd ff ff       	call   80102256 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801024dc:	83 ec 04             	sub    $0x4,%esp
801024df:	6a 18                	push   $0x18
801024e1:	56                   	push   %esi
801024e2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801024e5:	50                   	push   %eax
801024e6:	e8 60 18 00 00       	call   80103d4b <memcmp>
801024eb:	83 c4 10             	add    $0x10,%esp
801024ee:	85 c0                	test   %eax,%eax
801024f0:	75 ca                	jne    801024bc <cmostime+0x1f>
      break;
  }

  // convert
  if(bcd) {
801024f2:	85 ff                	test   %edi,%edi
801024f4:	75 7e                	jne    80102574 <cmostime+0xd7>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801024f6:	8b 55 d0             	mov    -0x30(%ebp),%edx
801024f9:	89 d0                	mov    %edx,%eax
801024fb:	c1 e8 04             	shr    $0x4,%eax
801024fe:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102501:	01 c0                	add    %eax,%eax
80102503:	83 e2 0f             	and    $0xf,%edx
80102506:	01 d0                	add    %edx,%eax
80102508:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
8010250b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010250e:	89 d0                	mov    %edx,%eax
80102510:	c1 e8 04             	shr    $0x4,%eax
80102513:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102516:	01 c0                	add    %eax,%eax
80102518:	83 e2 0f             	and    $0xf,%edx
8010251b:	01 d0                	add    %edx,%eax
8010251d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
80102520:	8b 55 d8             	mov    -0x28(%ebp),%edx
80102523:	89 d0                	mov    %edx,%eax
80102525:	c1 e8 04             	shr    $0x4,%eax
80102528:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010252b:	01 c0                	add    %eax,%eax
8010252d:	83 e2 0f             	and    $0xf,%edx
80102530:	01 d0                	add    %edx,%eax
80102532:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
80102535:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102538:	89 d0                	mov    %edx,%eax
8010253a:	c1 e8 04             	shr    $0x4,%eax
8010253d:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102540:	01 c0                	add    %eax,%eax
80102542:	83 e2 0f             	and    $0xf,%edx
80102545:	01 d0                	add    %edx,%eax
80102547:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
8010254a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010254d:	89 d0                	mov    %edx,%eax
8010254f:	c1 e8 04             	shr    $0x4,%eax
80102552:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102555:	01 c0                	add    %eax,%eax
80102557:	83 e2 0f             	and    $0xf,%edx
8010255a:	01 d0                	add    %edx,%eax
8010255c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
8010255f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102562:	89 d0                	mov    %edx,%eax
80102564:	c1 e8 04             	shr    $0x4,%eax
80102567:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010256a:	01 c0                	add    %eax,%eax
8010256c:	83 e2 0f             	and    $0xf,%edx
8010256f:	01 d0                	add    %edx,%eax
80102571:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
80102574:	8d 75 d0             	lea    -0x30(%ebp),%esi
80102577:	b9 06 00 00 00       	mov    $0x6,%ecx
8010257c:	89 df                	mov    %ebx,%edi
8010257e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
80102580:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102587:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010258a:	5b                   	pop    %ebx
8010258b:	5e                   	pop    %esi
8010258c:	5f                   	pop    %edi
8010258d:	5d                   	pop    %ebp
8010258e:	c3                   	ret    

8010258f <read_head>:
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010258f:	55                   	push   %ebp
80102590:	89 e5                	mov    %esp,%ebp
80102592:	53                   	push   %ebx
80102593:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102596:	ff 35 b4 26 11 80    	pushl  0x801126b4
8010259c:	ff 35 c4 26 11 80    	pushl  0x801126c4
801025a2:	e8 c7 db ff ff       	call   8010016e <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
801025a7:	8b 58 5c             	mov    0x5c(%eax),%ebx
801025aa:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
801025b0:	83 c4 10             	add    $0x10,%esp
801025b3:	ba 00 00 00 00       	mov    $0x0,%edx
801025b8:	39 d3                	cmp    %edx,%ebx
801025ba:	7e 0e                	jle    801025ca <read_head+0x3b>
    log.lh.block[i] = lh->block[i];
801025bc:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
801025c0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801025c7:	42                   	inc    %edx
801025c8:	eb ee                	jmp    801025b8 <read_head+0x29>
  }
  brelse(buf);
801025ca:	83 ec 0c             	sub    $0xc,%esp
801025cd:	50                   	push   %eax
801025ce:	e8 0c dc ff ff       	call   801001df <brelse>
}
801025d3:	83 c4 10             	add    $0x10,%esp
801025d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025d9:	c9                   	leave  
801025da:	c3                   	ret    

801025db <install_trans>:
{
801025db:	55                   	push   %ebp
801025dc:	89 e5                	mov    %esp,%ebp
801025de:	57                   	push   %edi
801025df:	56                   	push   %esi
801025e0:	53                   	push   %ebx
801025e1:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
801025e4:	be 00 00 00 00       	mov    $0x0,%esi
801025e9:	39 35 c8 26 11 80    	cmp    %esi,0x801126c8
801025ef:	7e 64                	jle    80102655 <install_trans+0x7a>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801025f1:	89 f0                	mov    %esi,%eax
801025f3:	03 05 b4 26 11 80    	add    0x801126b4,%eax
801025f9:	40                   	inc    %eax
801025fa:	83 ec 08             	sub    $0x8,%esp
801025fd:	50                   	push   %eax
801025fe:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102604:	e8 65 db ff ff       	call   8010016e <bread>
80102609:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010260b:	83 c4 08             	add    $0x8,%esp
8010260e:	ff 34 b5 cc 26 11 80 	pushl  -0x7feed934(,%esi,4)
80102615:	ff 35 c4 26 11 80    	pushl  0x801126c4
8010261b:	e8 4e db ff ff       	call   8010016e <bread>
80102620:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102622:	8d 57 5c             	lea    0x5c(%edi),%edx
80102625:	8d 40 5c             	lea    0x5c(%eax),%eax
80102628:	83 c4 0c             	add    $0xc,%esp
8010262b:	68 00 02 00 00       	push   $0x200
80102630:	52                   	push   %edx
80102631:	50                   	push   %eax
80102632:	e8 47 17 00 00       	call   80103d7e <memmove>
    bwrite(dbuf);  // write dst to disk
80102637:	89 1c 24             	mov    %ebx,(%esp)
8010263a:	e8 61 db ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
8010263f:	89 3c 24             	mov    %edi,(%esp)
80102642:	e8 98 db ff ff       	call   801001df <brelse>
    brelse(dbuf);
80102647:	89 1c 24             	mov    %ebx,(%esp)
8010264a:	e8 90 db ff ff       	call   801001df <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
8010264f:	46                   	inc    %esi
80102650:	83 c4 10             	add    $0x10,%esp
80102653:	eb 94                	jmp    801025e9 <install_trans+0xe>
}
80102655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102658:	5b                   	pop    %ebx
80102659:	5e                   	pop    %esi
8010265a:	5f                   	pop    %edi
8010265b:	5d                   	pop    %ebp
8010265c:	c3                   	ret    

8010265d <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
8010265d:	55                   	push   %ebp
8010265e:	89 e5                	mov    %esp,%ebp
80102660:	53                   	push   %ebx
80102661:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102664:	ff 35 b4 26 11 80    	pushl  0x801126b4
8010266a:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102670:	e8 f9 da ff ff       	call   8010016e <bread>
80102675:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102677:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
8010267d:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102680:	83 c4 10             	add    $0x10,%esp
80102683:	b8 00 00 00 00       	mov    $0x0,%eax
80102688:	39 c1                	cmp    %eax,%ecx
8010268a:	7e 0e                	jle    8010269a <write_head+0x3d>
    hb->block[i] = log.lh.block[i];
8010268c:	8b 14 85 cc 26 11 80 	mov    -0x7feed934(,%eax,4),%edx
80102693:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102697:	40                   	inc    %eax
80102698:	eb ee                	jmp    80102688 <write_head+0x2b>
  }
  bwrite(buf);
8010269a:	83 ec 0c             	sub    $0xc,%esp
8010269d:	53                   	push   %ebx
8010269e:	e8 fd da ff ff       	call   801001a0 <bwrite>
  brelse(buf);
801026a3:	89 1c 24             	mov    %ebx,(%esp)
801026a6:	e8 34 db ff ff       	call   801001df <brelse>
}
801026ab:	83 c4 10             	add    $0x10,%esp
801026ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026b1:	c9                   	leave  
801026b2:	c3                   	ret    

801026b3 <recover_from_log>:

static void
recover_from_log(void)
{
801026b3:	55                   	push   %ebp
801026b4:	89 e5                	mov    %esp,%ebp
801026b6:	83 ec 08             	sub    $0x8,%esp
  read_head();
801026b9:	e8 d1 fe ff ff       	call   8010258f <read_head>
  install_trans(); // if committed, copy from log to disk
801026be:	e8 18 ff ff ff       	call   801025db <install_trans>
  log.lh.n = 0;
801026c3:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
801026ca:	00 00 00 
  write_head(); // clear the log
801026cd:	e8 8b ff ff ff       	call   8010265d <write_head>
}
801026d2:	c9                   	leave  
801026d3:	c3                   	ret    

801026d4 <write_log>:
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
801026d4:	55                   	push   %ebp
801026d5:	89 e5                	mov    %esp,%ebp
801026d7:	57                   	push   %edi
801026d8:	56                   	push   %esi
801026d9:	53                   	push   %ebx
801026da:	83 ec 0c             	sub    $0xc,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801026dd:	be 00 00 00 00       	mov    $0x0,%esi
801026e2:	39 35 c8 26 11 80    	cmp    %esi,0x801126c8
801026e8:	7e 64                	jle    8010274e <write_log+0x7a>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801026ea:	89 f0                	mov    %esi,%eax
801026ec:	03 05 b4 26 11 80    	add    0x801126b4,%eax
801026f2:	40                   	inc    %eax
801026f3:	83 ec 08             	sub    $0x8,%esp
801026f6:	50                   	push   %eax
801026f7:	ff 35 c4 26 11 80    	pushl  0x801126c4
801026fd:	e8 6c da ff ff       	call   8010016e <bread>
80102702:	89 c3                	mov    %eax,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102704:	83 c4 08             	add    $0x8,%esp
80102707:	ff 34 b5 cc 26 11 80 	pushl  -0x7feed934(,%esi,4)
8010270e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102714:	e8 55 da ff ff       	call   8010016e <bread>
80102719:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
8010271b:	8d 50 5c             	lea    0x5c(%eax),%edx
8010271e:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102721:	83 c4 0c             	add    $0xc,%esp
80102724:	68 00 02 00 00       	push   $0x200
80102729:	52                   	push   %edx
8010272a:	50                   	push   %eax
8010272b:	e8 4e 16 00 00       	call   80103d7e <memmove>
    bwrite(to);  // write the log
80102730:	89 1c 24             	mov    %ebx,(%esp)
80102733:	e8 68 da ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102738:	89 3c 24             	mov    %edi,(%esp)
8010273b:	e8 9f da ff ff       	call   801001df <brelse>
    brelse(to);
80102740:	89 1c 24             	mov    %ebx,(%esp)
80102743:	e8 97 da ff ff       	call   801001df <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102748:	46                   	inc    %esi
80102749:	83 c4 10             	add    $0x10,%esp
8010274c:	eb 94                	jmp    801026e2 <write_log+0xe>
  }
}
8010274e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102751:	5b                   	pop    %ebx
80102752:	5e                   	pop    %esi
80102753:	5f                   	pop    %edi
80102754:	5d                   	pop    %ebp
80102755:	c3                   	ret    

80102756 <commit>:

static void
commit()
{
  if (log.lh.n > 0) {
80102756:	83 3d c8 26 11 80 00 	cmpl   $0x0,0x801126c8
8010275d:	7f 01                	jg     80102760 <commit+0xa>
8010275f:	c3                   	ret    
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	83 ec 08             	sub    $0x8,%esp
    write_log();     // Write modified blocks from cache to log
80102766:	e8 69 ff ff ff       	call   801026d4 <write_log>
    write_head();    // Write header to disk -- the real commit
8010276b:	e8 ed fe ff ff       	call   8010265d <write_head>
    install_trans(); // Now install writes to home locations
80102770:	e8 66 fe ff ff       	call   801025db <install_trans>
    log.lh.n = 0;
80102775:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
8010277c:	00 00 00 
    write_head();    // Erase the transaction from the log
8010277f:	e8 d9 fe ff ff       	call   8010265d <write_head>
  }
}
80102784:	c9                   	leave  
80102785:	c3                   	ret    

80102786 <initlog>:
{
80102786:	f3 0f 1e fb          	endbr32 
8010278a:	55                   	push   %ebp
8010278b:	89 e5                	mov    %esp,%ebp
8010278d:	53                   	push   %ebx
8010278e:	83 ec 2c             	sub    $0x2c,%esp
80102791:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102794:	68 e0 6a 10 80       	push   $0x80106ae0
80102799:	68 80 26 11 80       	push   $0x80112680
8010279e:	e8 5e 13 00 00       	call   80103b01 <initlock>
  readsb(dev, &sb);
801027a3:	83 c4 08             	add    $0x8,%esp
801027a6:	8d 45 dc             	lea    -0x24(%ebp),%eax
801027a9:	50                   	push   %eax
801027aa:	53                   	push   %ebx
801027ab:	e8 81 ea ff ff       	call   80101231 <readsb>
  log.start = sb.logstart;
801027b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801027b3:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
801027b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801027bb:	a3 b8 26 11 80       	mov    %eax,0x801126b8
  log.dev = dev;
801027c0:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  recover_from_log();
801027c6:	e8 e8 fe ff ff       	call   801026b3 <recover_from_log>
}
801027cb:	83 c4 10             	add    $0x10,%esp
801027ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027d1:	c9                   	leave  
801027d2:	c3                   	ret    

801027d3 <begin_op>:
{
801027d3:	f3 0f 1e fb          	endbr32 
801027d7:	55                   	push   %ebp
801027d8:	89 e5                	mov    %esp,%ebp
801027da:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801027dd:	68 80 26 11 80       	push   $0x80112680
801027e2:	e8 65 14 00 00       	call   80103c4c <acquire>
801027e7:	83 c4 10             	add    $0x10,%esp
801027ea:	eb 15                	jmp    80102801 <begin_op+0x2e>
      sleep(&log, &log.lock);
801027ec:	83 ec 08             	sub    $0x8,%esp
801027ef:	68 80 26 11 80       	push   $0x80112680
801027f4:	68 80 26 11 80       	push   $0x80112680
801027f9:	e8 20 0f 00 00       	call   8010371e <sleep>
801027fe:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102801:	83 3d c0 26 11 80 00 	cmpl   $0x0,0x801126c0
80102808:	75 e2                	jne    801027ec <begin_op+0x19>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010280a:	a1 bc 26 11 80       	mov    0x801126bc,%eax
8010280f:	8d 48 01             	lea    0x1(%eax),%ecx
80102812:	8d 54 80 05          	lea    0x5(%eax,%eax,4),%edx
80102816:	8d 04 12             	lea    (%edx,%edx,1),%eax
80102819:	03 05 c8 26 11 80    	add    0x801126c8,%eax
8010281f:	83 f8 1e             	cmp    $0x1e,%eax
80102822:	7e 17                	jle    8010283b <begin_op+0x68>
      sleep(&log, &log.lock);
80102824:	83 ec 08             	sub    $0x8,%esp
80102827:	68 80 26 11 80       	push   $0x80112680
8010282c:	68 80 26 11 80       	push   $0x80112680
80102831:	e8 e8 0e 00 00       	call   8010371e <sleep>
80102836:	83 c4 10             	add    $0x10,%esp
80102839:	eb c6                	jmp    80102801 <begin_op+0x2e>
      log.outstanding += 1;
8010283b:	89 0d bc 26 11 80    	mov    %ecx,0x801126bc
      release(&log.lock);
80102841:	83 ec 0c             	sub    $0xc,%esp
80102844:	68 80 26 11 80       	push   $0x80112680
80102849:	e8 67 14 00 00       	call   80103cb5 <release>
}
8010284e:	83 c4 10             	add    $0x10,%esp
80102851:	c9                   	leave  
80102852:	c3                   	ret    

80102853 <end_op>:
{
80102853:	f3 0f 1e fb          	endbr32 
80102857:	55                   	push   %ebp
80102858:	89 e5                	mov    %esp,%ebp
8010285a:	53                   	push   %ebx
8010285b:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
8010285e:	68 80 26 11 80       	push   $0x80112680
80102863:	e8 e4 13 00 00       	call   80103c4c <acquire>
  log.outstanding -= 1;
80102868:	a1 bc 26 11 80       	mov    0x801126bc,%eax
8010286d:	48                   	dec    %eax
8010286e:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102873:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
80102879:	83 c4 10             	add    $0x10,%esp
8010287c:	85 db                	test   %ebx,%ebx
8010287e:	75 2c                	jne    801028ac <end_op+0x59>
  if(log.outstanding == 0){
80102880:	85 c0                	test   %eax,%eax
80102882:	75 35                	jne    801028b9 <end_op+0x66>
    log.committing = 1;
80102884:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
8010288b:	00 00 00 
    do_commit = 1;
8010288e:	bb 01 00 00 00       	mov    $0x1,%ebx
  release(&log.lock);
80102893:	83 ec 0c             	sub    $0xc,%esp
80102896:	68 80 26 11 80       	push   $0x80112680
8010289b:	e8 15 14 00 00       	call   80103cb5 <release>
  if(do_commit){
801028a0:	83 c4 10             	add    $0x10,%esp
801028a3:	85 db                	test   %ebx,%ebx
801028a5:	75 24                	jne    801028cb <end_op+0x78>
}
801028a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028aa:	c9                   	leave  
801028ab:	c3                   	ret    
    panic("log.committing");
801028ac:	83 ec 0c             	sub    $0xc,%esp
801028af:	68 e4 6a 10 80       	push   $0x80106ae4
801028b4:	e8 9c da ff ff       	call   80100355 <panic>
    wakeup(&log);
801028b9:	83 ec 0c             	sub    $0xc,%esp
801028bc:	68 80 26 11 80       	push   $0x80112680
801028c1:	e8 c7 0f 00 00       	call   8010388d <wakeup>
801028c6:	83 c4 10             	add    $0x10,%esp
801028c9:	eb c8                	jmp    80102893 <end_op+0x40>
    commit();
801028cb:	e8 86 fe ff ff       	call   80102756 <commit>
    acquire(&log.lock);
801028d0:	83 ec 0c             	sub    $0xc,%esp
801028d3:	68 80 26 11 80       	push   $0x80112680
801028d8:	e8 6f 13 00 00       	call   80103c4c <acquire>
    log.committing = 0;
801028dd:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
801028e4:	00 00 00 
    wakeup(&log);
801028e7:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801028ee:	e8 9a 0f 00 00       	call   8010388d <wakeup>
    release(&log.lock);
801028f3:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801028fa:	e8 b6 13 00 00       	call   80103cb5 <release>
801028ff:	83 c4 10             	add    $0x10,%esp
}
80102902:	eb a3                	jmp    801028a7 <end_op+0x54>

80102904 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102904:	f3 0f 1e fb          	endbr32 
80102908:	55                   	push   %ebp
80102909:	89 e5                	mov    %esp,%ebp
8010290b:	53                   	push   %ebx
8010290c:	83 ec 04             	sub    $0x4,%esp
8010290f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102912:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102918:	83 fa 1d             	cmp    $0x1d,%edx
8010291b:	7f 41                	jg     8010295e <log_write+0x5a>
8010291d:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102922:	48                   	dec    %eax
80102923:	39 c2                	cmp    %eax,%edx
80102925:	7d 37                	jge    8010295e <log_write+0x5a>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102927:	83 3d bc 26 11 80 00 	cmpl   $0x0,0x801126bc
8010292e:	7e 3b                	jle    8010296b <log_write+0x67>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102930:	83 ec 0c             	sub    $0xc,%esp
80102933:	68 80 26 11 80       	push   $0x80112680
80102938:	e8 0f 13 00 00       	call   80103c4c <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010293d:	83 c4 10             	add    $0x10,%esp
80102940:	b8 00 00 00 00       	mov    $0x0,%eax
80102945:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
8010294b:	39 c2                	cmp    %eax,%edx
8010294d:	7e 29                	jle    80102978 <log_write+0x74>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010294f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80102952:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102959:	74 1d                	je     80102978 <log_write+0x74>
  for (i = 0; i < log.lh.n; i++) {
8010295b:	40                   	inc    %eax
8010295c:	eb e7                	jmp    80102945 <log_write+0x41>
    panic("too big a transaction");
8010295e:	83 ec 0c             	sub    $0xc,%esp
80102961:	68 f3 6a 10 80       	push   $0x80106af3
80102966:	e8 ea d9 ff ff       	call   80100355 <panic>
    panic("log_write outside of trans");
8010296b:	83 ec 0c             	sub    $0xc,%esp
8010296e:	68 09 6b 10 80       	push   $0x80106b09
80102973:	e8 dd d9 ff ff       	call   80100355 <panic>
      break;
  }
  log.lh.block[i] = b->blockno;
80102978:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010297b:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
80102982:	39 c2                	cmp    %eax,%edx
80102984:	74 18                	je     8010299e <log_write+0x9a>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102986:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102989:	83 ec 0c             	sub    $0xc,%esp
8010298c:	68 80 26 11 80       	push   $0x80112680
80102991:	e8 1f 13 00 00       	call   80103cb5 <release>
}
80102996:	83 c4 10             	add    $0x10,%esp
80102999:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010299c:	c9                   	leave  
8010299d:	c3                   	ret    
    log.lh.n++;
8010299e:	42                   	inc    %edx
8010299f:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
801029a5:	eb df                	jmp    80102986 <log_write+0x82>

801029a7 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801029a7:	55                   	push   %ebp
801029a8:	89 e5                	mov    %esp,%ebp
801029aa:	53                   	push   %ebx
801029ab:	83 ec 08             	sub    $0x8,%esp

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801029ae:	68 8e 00 00 00       	push   $0x8e
801029b3:	68 8c a4 10 80       	push   $0x8010a48c
801029b8:	68 00 70 00 80       	push   $0x80007000
801029bd:	e8 bc 13 00 00       	call   80103d7e <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801029c2:	83 c4 10             	add    $0x10,%esp
801029c5:	bb 80 27 11 80       	mov    $0x80112780,%ebx
801029ca:	eb 47                	jmp    80102a13 <startothers+0x6c>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801029cc:	e8 2b f7 ff ff       	call   801020fc <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801029d1:	05 00 10 00 00       	add    $0x1000,%eax
801029d6:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
801029db:	c7 05 f8 6f 00 80 7b 	movl   $0x80102a7b,0x80006ff8
801029e2:	2a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801029e5:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801029ec:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
801029ef:	83 ec 08             	sub    $0x8,%esp
801029f2:	68 00 70 00 00       	push   $0x7000
801029f7:	0f b6 03             	movzbl (%ebx),%eax
801029fa:	50                   	push   %eax
801029fb:	e8 06 fa ff ff       	call   80102406 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102a00:	83 c4 10             	add    $0x10,%esp
80102a03:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102a09:	85 c0                	test   %eax,%eax
80102a0b:	74 f6                	je     80102a03 <startothers+0x5c>
  for(c = cpus; c < cpus+ncpu; c++){
80102a0d:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102a13:	8b 15 00 2d 11 80    	mov    0x80112d00,%edx
80102a19:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102a1c:	01 c0                	add    %eax,%eax
80102a1e:	01 d0                	add    %edx,%eax
80102a20:	c1 e0 04             	shl    $0x4,%eax
80102a23:	05 80 27 11 80       	add    $0x80112780,%eax
80102a28:	39 d8                	cmp    %ebx,%eax
80102a2a:	76 0b                	jbe    80102a37 <startothers+0x90>
    if(c == mycpu())  // We've started already.
80102a2c:	e8 84 07 00 00       	call   801031b5 <mycpu>
80102a31:	39 c3                	cmp    %eax,%ebx
80102a33:	74 d8                	je     80102a0d <startothers+0x66>
80102a35:	eb 95                	jmp    801029cc <startothers+0x25>
      ;
  }
}
80102a37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a3a:	c9                   	leave  
80102a3b:	c3                   	ret    

80102a3c <mpmain>:
{
80102a3c:	55                   	push   %ebp
80102a3d:	89 e5                	mov    %esp,%ebp
80102a3f:	53                   	push   %ebx
80102a40:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102a43:	e8 d4 07 00 00       	call   8010321c <cpuid>
80102a48:	89 c3                	mov    %eax,%ebx
80102a4a:	e8 cd 07 00 00       	call   8010321c <cpuid>
80102a4f:	83 ec 04             	sub    $0x4,%esp
80102a52:	53                   	push   %ebx
80102a53:	50                   	push   %eax
80102a54:	68 24 6b 10 80       	push   $0x80106b24
80102a59:	e8 9f db ff ff       	call   801005fd <cprintf>
  idtinit();       // load idt register
80102a5e:	e8 fb 24 00 00       	call   80104f5e <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102a63:	e8 4d 07 00 00       	call   801031b5 <mycpu>
80102a68:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102a6a:	b8 01 00 00 00       	mov    $0x1,%eax
80102a6f:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102a76:	e8 5f 0a 00 00       	call   801034da <scheduler>

80102a7b <mpenter>:
{
80102a7b:	f3 0f 1e fb          	endbr32 
80102a7f:	55                   	push   %ebp
80102a80:	89 e5                	mov    %esp,%ebp
80102a82:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102a85:	e8 05 35 00 00       	call   80105f8f <switchkvm>
  seginit();
80102a8a:	e8 87 33 00 00       	call   80105e16 <seginit>
  lapicinit();
80102a8f:	e8 1e f8 ff ff       	call   801022b2 <lapicinit>
  mpmain();
80102a94:	e8 a3 ff ff ff       	call   80102a3c <mpmain>

80102a99 <main>:
{
80102a99:	f3 0f 1e fb          	endbr32 
80102a9d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102aa1:	83 e4 f0             	and    $0xfffffff0,%esp
80102aa4:	ff 71 fc             	pushl  -0x4(%ecx)
80102aa7:	55                   	push   %ebp
80102aa8:	89 e5                	mov    %esp,%ebp
80102aaa:	51                   	push   %ecx
80102aab:	83 ec 0c             	sub    $0xc,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102aae:	68 00 00 40 80       	push   $0x80400000
80102ab3:	68 a8 54 11 80       	push   $0x801154a8
80102ab8:	e8 e5 f5 ff ff       	call   801020a2 <kinit1>
  kvmalloc();      // kernel page table
80102abd:	e8 72 39 00 00       	call   80106434 <kvmalloc>
  mpinit();        // detect other processors
80102ac2:	e8 b8 01 00 00       	call   80102c7f <mpinit>
  lapicinit();     // interrupt controller
80102ac7:	e8 e6 f7 ff ff       	call   801022b2 <lapicinit>
  seginit();       // segment descriptors
80102acc:	e8 45 33 00 00       	call   80105e16 <seginit>
  picinit();       // disable pic
80102ad1:	e8 7d 02 00 00       	call   80102d53 <picinit>
  ioapicinit();    // another interrupt controller
80102ad6:	e8 44 f4 ff ff       	call   80101f1f <ioapicinit>
  consoleinit();   // console hardware
80102adb:	e8 97 dd ff ff       	call   80100877 <consoleinit>
  uartinit();      // serial port
80102ae0:	e8 2b 27 00 00       	call   80105210 <uartinit>
  pinit();         // process table
80102ae5:	e8 ad 06 00 00       	call   80103197 <pinit>
  tvinit();        // trap vectors
80102aea:	e8 bf 23 00 00       	call   80104eae <tvinit>
  binit();         // buffer cache
80102aef:	e8 fe d5 ff ff       	call   801000f2 <binit>
  fileinit();      // file table
80102af4:	e8 0a e1 ff ff       	call   80100c03 <fileinit>
  ideinit();       // disk 
80102af9:	e8 2d f2 ff ff       	call   80101d2b <ideinit>
  startothers();   // start other processors
80102afe:	e8 a4 fe ff ff       	call   801029a7 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102b03:	83 c4 08             	add    $0x8,%esp
80102b06:	68 00 00 00 8e       	push   $0x8e000000
80102b0b:	68 00 00 40 80       	push   $0x80400000
80102b10:	e8 c3 f5 ff ff       	call   801020d8 <kinit2>
  userinit();      // first user process
80102b15:	e8 5f 07 00 00       	call   80103279 <userinit>
  mpmain();        // finish this processor's setup
80102b1a:	e8 1d ff ff ff       	call   80102a3c <mpmain>

80102b1f <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80102b1f:	55                   	push   %ebp
80102b20:	89 e5                	mov    %esp,%ebp
80102b22:	56                   	push   %esi
80102b23:	53                   	push   %ebx
80102b24:	89 c6                	mov    %eax,%esi
  int i, sum;

  sum = 0;
80102b26:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i=0; i<len; i++)
80102b2b:	b9 00 00 00 00       	mov    $0x0,%ecx
80102b30:	39 d1                	cmp    %edx,%ecx
80102b32:	7d 09                	jge    80102b3d <sum+0x1e>
    sum += addr[i];
80102b34:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
80102b38:	01 d8                	add    %ebx,%eax
  for(i=0; i<len; i++)
80102b3a:	41                   	inc    %ecx
80102b3b:	eb f3                	jmp    80102b30 <sum+0x11>
  return sum;
}
80102b3d:	5b                   	pop    %ebx
80102b3e:	5e                   	pop    %esi
80102b3f:	5d                   	pop    %ebp
80102b40:	c3                   	ret    

80102b41 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102b41:	55                   	push   %ebp
80102b42:	89 e5                	mov    %esp,%ebp
80102b44:	56                   	push   %esi
80102b45:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80102b46:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102b4c:	89 f3                	mov    %esi,%ebx
  e = addr+len;
80102b4e:	01 d6                	add    %edx,%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102b50:	eb 03                	jmp    80102b55 <mpsearch1+0x14>
80102b52:	83 c3 10             	add    $0x10,%ebx
80102b55:	39 f3                	cmp    %esi,%ebx
80102b57:	73 29                	jae    80102b82 <mpsearch1+0x41>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102b59:	83 ec 04             	sub    $0x4,%esp
80102b5c:	6a 04                	push   $0x4
80102b5e:	68 38 6b 10 80       	push   $0x80106b38
80102b63:	53                   	push   %ebx
80102b64:	e8 e2 11 00 00       	call   80103d4b <memcmp>
80102b69:	83 c4 10             	add    $0x10,%esp
80102b6c:	85 c0                	test   %eax,%eax
80102b6e:	75 e2                	jne    80102b52 <mpsearch1+0x11>
80102b70:	ba 10 00 00 00       	mov    $0x10,%edx
80102b75:	89 d8                	mov    %ebx,%eax
80102b77:	e8 a3 ff ff ff       	call   80102b1f <sum>
80102b7c:	84 c0                	test   %al,%al
80102b7e:	75 d2                	jne    80102b52 <mpsearch1+0x11>
80102b80:	eb 05                	jmp    80102b87 <mpsearch1+0x46>
      return (struct mp*)p;
  return 0;
80102b82:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102b87:	89 d8                	mov    %ebx,%eax
80102b89:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b8c:	5b                   	pop    %ebx
80102b8d:	5e                   	pop    %esi
80102b8e:	5d                   	pop    %ebp
80102b8f:	c3                   	ret    

80102b90 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	83 ec 08             	sub    $0x8,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102b96:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102b9d:	c1 e0 08             	shl    $0x8,%eax
80102ba0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102ba7:	09 d0                	or     %edx,%eax
80102ba9:	c1 e0 04             	shl    $0x4,%eax
80102bac:	74 1f                	je     80102bcd <mpsearch+0x3d>
    if((mp = mpsearch1(p, 1024)))
80102bae:	ba 00 04 00 00       	mov    $0x400,%edx
80102bb3:	e8 89 ff ff ff       	call   80102b41 <mpsearch1>
80102bb8:	85 c0                	test   %eax,%eax
80102bba:	75 0f                	jne    80102bcb <mpsearch+0x3b>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102bbc:	ba 00 00 01 00       	mov    $0x10000,%edx
80102bc1:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102bc6:	e8 76 ff ff ff       	call   80102b41 <mpsearch1>
}
80102bcb:	c9                   	leave  
80102bcc:	c3                   	ret    
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102bcd:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102bd4:	c1 e0 08             	shl    $0x8,%eax
80102bd7:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102bde:	09 d0                	or     %edx,%eax
80102be0:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102be3:	2d 00 04 00 00       	sub    $0x400,%eax
80102be8:	ba 00 04 00 00       	mov    $0x400,%edx
80102bed:	e8 4f ff ff ff       	call   80102b41 <mpsearch1>
80102bf2:	85 c0                	test   %eax,%eax
80102bf4:	75 d5                	jne    80102bcb <mpsearch+0x3b>
80102bf6:	eb c4                	jmp    80102bbc <mpsearch+0x2c>

80102bf8 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80102bf8:	55                   	push   %ebp
80102bf9:	89 e5                	mov    %esp,%ebp
80102bfb:	57                   	push   %edi
80102bfc:	56                   	push   %esi
80102bfd:	53                   	push   %ebx
80102bfe:	83 ec 1c             	sub    $0x1c,%esp
80102c01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102c04:	e8 87 ff ff ff       	call   80102b90 <mpsearch>
80102c09:	89 c3                	mov    %eax,%ebx
80102c0b:	85 c0                	test   %eax,%eax
80102c0d:	74 53                	je     80102c62 <mpconfig+0x6a>
80102c0f:	8b 70 04             	mov    0x4(%eax),%esi
80102c12:	85 f6                	test   %esi,%esi
80102c14:	74 50                	je     80102c66 <mpconfig+0x6e>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102c16:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
  if(memcmp(conf, "PCMP", 4) != 0)
80102c1c:	83 ec 04             	sub    $0x4,%esp
80102c1f:	6a 04                	push   $0x4
80102c21:	68 3d 6b 10 80       	push   $0x80106b3d
80102c26:	57                   	push   %edi
80102c27:	e8 1f 11 00 00       	call   80103d4b <memcmp>
80102c2c:	83 c4 10             	add    $0x10,%esp
80102c2f:	85 c0                	test   %eax,%eax
80102c31:	75 37                	jne    80102c6a <mpconfig+0x72>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102c33:	8a 86 06 00 00 80    	mov    -0x7ffffffa(%esi),%al
80102c39:	3c 01                	cmp    $0x1,%al
80102c3b:	74 04                	je     80102c41 <mpconfig+0x49>
80102c3d:	3c 04                	cmp    $0x4,%al
80102c3f:	75 30                	jne    80102c71 <mpconfig+0x79>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102c41:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80102c48:	89 f8                	mov    %edi,%eax
80102c4a:	e8 d0 fe ff ff       	call   80102b1f <sum>
80102c4f:	84 c0                	test   %al,%al
80102c51:	75 25                	jne    80102c78 <mpconfig+0x80>
    return 0;
  *pmp = mp;
80102c53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102c56:	89 18                	mov    %ebx,(%eax)
  return conf;
}
80102c58:	89 f8                	mov    %edi,%eax
80102c5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c5d:	5b                   	pop    %ebx
80102c5e:	5e                   	pop    %esi
80102c5f:	5f                   	pop    %edi
80102c60:	5d                   	pop    %ebp
80102c61:	c3                   	ret    
    return 0;
80102c62:	89 c7                	mov    %eax,%edi
80102c64:	eb f2                	jmp    80102c58 <mpconfig+0x60>
80102c66:	89 f7                	mov    %esi,%edi
80102c68:	eb ee                	jmp    80102c58 <mpconfig+0x60>
    return 0;
80102c6a:	bf 00 00 00 00       	mov    $0x0,%edi
80102c6f:	eb e7                	jmp    80102c58 <mpconfig+0x60>
    return 0;
80102c71:	bf 00 00 00 00       	mov    $0x0,%edi
80102c76:	eb e0                	jmp    80102c58 <mpconfig+0x60>
    return 0;
80102c78:	bf 00 00 00 00       	mov    $0x0,%edi
80102c7d:	eb d9                	jmp    80102c58 <mpconfig+0x60>

80102c7f <mpinit>:

void
mpinit(void)
{
80102c7f:	f3 0f 1e fb          	endbr32 
80102c83:	55                   	push   %ebp
80102c84:	89 e5                	mov    %esp,%ebp
80102c86:	57                   	push   %edi
80102c87:	56                   	push   %esi
80102c88:	53                   	push   %ebx
80102c89:	83 ec 1c             	sub    $0x1c,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102c8c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80102c8f:	e8 64 ff ff ff       	call   80102bf8 <mpconfig>
80102c94:	85 c0                	test   %eax,%eax
80102c96:	74 19                	je     80102cb1 <mpinit+0x32>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102c98:	8b 50 24             	mov    0x24(%eax),%edx
80102c9b:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102ca1:	8d 50 2c             	lea    0x2c(%eax),%edx
80102ca4:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102ca8:	01 c1                	add    %eax,%ecx
  ismp = 1;
80102caa:	bf 01 00 00 00       	mov    $0x1,%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102caf:	eb 20                	jmp    80102cd1 <mpinit+0x52>
    panic("Expect to run on an SMP");
80102cb1:	83 ec 0c             	sub    $0xc,%esp
80102cb4:	68 42 6b 10 80       	push   $0x80106b42
80102cb9:	e8 97 d6 ff ff       	call   80100355 <panic>
    switch(*p){
80102cbe:	bf 00 00 00 00       	mov    $0x0,%edi
80102cc3:	eb 0c                	jmp    80102cd1 <mpinit+0x52>
80102cc5:	83 e8 03             	sub    $0x3,%eax
80102cc8:	3c 01                	cmp    $0x1,%al
80102cca:	76 19                	jbe    80102ce5 <mpinit+0x66>
80102ccc:	bf 00 00 00 00       	mov    $0x0,%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102cd1:	39 ca                	cmp    %ecx,%edx
80102cd3:	73 4a                	jae    80102d1f <mpinit+0xa0>
    switch(*p){
80102cd5:	8a 02                	mov    (%edx),%al
80102cd7:	3c 02                	cmp    $0x2,%al
80102cd9:	74 37                	je     80102d12 <mpinit+0x93>
80102cdb:	77 e8                	ja     80102cc5 <mpinit+0x46>
80102cdd:	84 c0                	test   %al,%al
80102cdf:	74 09                	je     80102cea <mpinit+0x6b>
80102ce1:	3c 01                	cmp    $0x1,%al
80102ce3:	75 d9                	jne    80102cbe <mpinit+0x3f>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102ce5:	83 c2 08             	add    $0x8,%edx
      continue;
80102ce8:	eb e7                	jmp    80102cd1 <mpinit+0x52>
      if(ncpu < NCPU) {
80102cea:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80102cef:	83 f8 07             	cmp    $0x7,%eax
80102cf2:	7f 19                	jg     80102d0d <mpinit+0x8e>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102cf4:	8d 34 80             	lea    (%eax,%eax,4),%esi
80102cf7:	01 f6                	add    %esi,%esi
80102cf9:	01 c6                	add    %eax,%esi
80102cfb:	c1 e6 04             	shl    $0x4,%esi
80102cfe:	8a 5a 01             	mov    0x1(%edx),%bl
80102d01:	88 9e 80 27 11 80    	mov    %bl,-0x7feed880(%esi)
        ncpu++;
80102d07:	40                   	inc    %eax
80102d08:	a3 00 2d 11 80       	mov    %eax,0x80112d00
      p += sizeof(struct mpproc);
80102d0d:	83 c2 14             	add    $0x14,%edx
      continue;
80102d10:	eb bf                	jmp    80102cd1 <mpinit+0x52>
      ioapicid = ioapic->apicno;
80102d12:	8a 42 01             	mov    0x1(%edx),%al
80102d15:	a2 60 27 11 80       	mov    %al,0x80112760
      p += sizeof(struct mpioapic);
80102d1a:	83 c2 08             	add    $0x8,%edx
      continue;
80102d1d:	eb b2                	jmp    80102cd1 <mpinit+0x52>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102d1f:	85 ff                	test   %edi,%edi
80102d21:	74 23                	je     80102d46 <mpinit+0xc7>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102d23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102d26:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102d2a:	74 12                	je     80102d3e <mpinit+0xbf>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d2c:	b0 70                	mov    $0x70,%al
80102d2e:	ba 22 00 00 00       	mov    $0x22,%edx
80102d33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d34:	ba 23 00 00 00       	mov    $0x23,%edx
80102d39:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102d3a:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d3d:	ee                   	out    %al,(%dx)
  }
}
80102d3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d41:	5b                   	pop    %ebx
80102d42:	5e                   	pop    %esi
80102d43:	5f                   	pop    %edi
80102d44:	5d                   	pop    %ebp
80102d45:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102d46:	83 ec 0c             	sub    $0xc,%esp
80102d49:	68 5c 6b 10 80       	push   $0x80106b5c
80102d4e:	e8 02 d6 ff ff       	call   80100355 <panic>

80102d53 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80102d53:	f3 0f 1e fb          	endbr32 
80102d57:	b0 ff                	mov    $0xff,%al
80102d59:	ba 21 00 00 00       	mov    $0x21,%edx
80102d5e:	ee                   	out    %al,(%dx)
80102d5f:	ba a1 00 00 00       	mov    $0xa1,%edx
80102d64:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102d65:	c3                   	ret    

80102d66 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102d66:	f3 0f 1e fb          	endbr32 
80102d6a:	55                   	push   %ebp
80102d6b:	89 e5                	mov    %esp,%ebp
80102d6d:	57                   	push   %edi
80102d6e:	56                   	push   %esi
80102d6f:	53                   	push   %ebx
80102d70:	83 ec 0c             	sub    $0xc,%esp
80102d73:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102d76:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102d79:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102d7f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102d85:	e8 97 de ff ff       	call   80100c21 <filealloc>
80102d8a:	89 03                	mov    %eax,(%ebx)
80102d8c:	85 c0                	test   %eax,%eax
80102d8e:	0f 84 88 00 00 00    	je     80102e1c <pipealloc+0xb6>
80102d94:	e8 88 de ff ff       	call   80100c21 <filealloc>
80102d99:	89 06                	mov    %eax,(%esi)
80102d9b:	85 c0                	test   %eax,%eax
80102d9d:	74 7d                	je     80102e1c <pipealloc+0xb6>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102d9f:	e8 58 f3 ff ff       	call   801020fc <kalloc>
80102da4:	89 c7                	mov    %eax,%edi
80102da6:	85 c0                	test   %eax,%eax
80102da8:	74 72                	je     80102e1c <pipealloc+0xb6>
    goto bad;
  p->readopen = 1;
80102daa:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102db1:	00 00 00 
  p->writeopen = 1;
80102db4:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102dbb:	00 00 00 
  p->nwrite = 0;
80102dbe:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102dc5:	00 00 00 
  p->nread = 0;
80102dc8:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102dcf:	00 00 00 
  initlock(&p->lock, "pipe");
80102dd2:	83 ec 08             	sub    $0x8,%esp
80102dd5:	68 7b 6b 10 80       	push   $0x80106b7b
80102dda:	50                   	push   %eax
80102ddb:	e8 21 0d 00 00       	call   80103b01 <initlock>
  (*f0)->type = FD_PIPE;
80102de0:	8b 03                	mov    (%ebx),%eax
80102de2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102de8:	8b 03                	mov    (%ebx),%eax
80102dea:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102dee:	8b 03                	mov    (%ebx),%eax
80102df0:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102df4:	8b 03                	mov    (%ebx),%eax
80102df6:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102df9:	8b 06                	mov    (%esi),%eax
80102dfb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102e01:	8b 06                	mov    (%esi),%eax
80102e03:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102e07:	8b 06                	mov    (%esi),%eax
80102e09:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102e0d:	8b 06                	mov    (%esi),%eax
80102e0f:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102e12:	83 c4 10             	add    $0x10,%esp
80102e15:	b8 00 00 00 00       	mov    $0x0,%eax
80102e1a:	eb 29                	jmp    80102e45 <pipealloc+0xdf>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102e1c:	8b 03                	mov    (%ebx),%eax
80102e1e:	85 c0                	test   %eax,%eax
80102e20:	74 0c                	je     80102e2e <pipealloc+0xc8>
    fileclose(*f0);
80102e22:	83 ec 0c             	sub    $0xc,%esp
80102e25:	50                   	push   %eax
80102e26:	e8 a2 de ff ff       	call   80100ccd <fileclose>
80102e2b:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102e2e:	8b 06                	mov    (%esi),%eax
80102e30:	85 c0                	test   %eax,%eax
80102e32:	74 19                	je     80102e4d <pipealloc+0xe7>
    fileclose(*f1);
80102e34:	83 ec 0c             	sub    $0xc,%esp
80102e37:	50                   	push   %eax
80102e38:	e8 90 de ff ff       	call   80100ccd <fileclose>
80102e3d:	83 c4 10             	add    $0x10,%esp
  return -1;
80102e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e48:	5b                   	pop    %ebx
80102e49:	5e                   	pop    %esi
80102e4a:	5f                   	pop    %edi
80102e4b:	5d                   	pop    %ebp
80102e4c:	c3                   	ret    
  return -1;
80102e4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102e52:	eb f1                	jmp    80102e45 <pipealloc+0xdf>

80102e54 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102e54:	f3 0f 1e fb          	endbr32 
80102e58:	55                   	push   %ebp
80102e59:	89 e5                	mov    %esp,%ebp
80102e5b:	53                   	push   %ebx
80102e5c:	83 ec 10             	sub    $0x10,%esp
80102e5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102e62:	53                   	push   %ebx
80102e63:	e8 e4 0d 00 00       	call   80103c4c <acquire>
  if(writable){
80102e68:	83 c4 10             	add    $0x10,%esp
80102e6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102e6f:	74 3f                	je     80102eb0 <pipeclose+0x5c>
    p->writeopen = 0;
80102e71:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102e78:	00 00 00 
    wakeup(&p->nread);
80102e7b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e81:	83 ec 0c             	sub    $0xc,%esp
80102e84:	50                   	push   %eax
80102e85:	e8 03 0a 00 00       	call   8010388d <wakeup>
80102e8a:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102e8d:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102e94:	75 09                	jne    80102e9f <pipeclose+0x4b>
80102e96:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102e9d:	74 2f                	je     80102ece <pipeclose+0x7a>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102e9f:	83 ec 0c             	sub    $0xc,%esp
80102ea2:	53                   	push   %ebx
80102ea3:	e8 0d 0e 00 00       	call   80103cb5 <release>
80102ea8:	83 c4 10             	add    $0x10,%esp
}
80102eab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102eae:	c9                   	leave  
80102eaf:	c3                   	ret    
    p->readopen = 0;
80102eb0:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102eb7:	00 00 00 
    wakeup(&p->nwrite);
80102eba:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102ec0:	83 ec 0c             	sub    $0xc,%esp
80102ec3:	50                   	push   %eax
80102ec4:	e8 c4 09 00 00       	call   8010388d <wakeup>
80102ec9:	83 c4 10             	add    $0x10,%esp
80102ecc:	eb bf                	jmp    80102e8d <pipeclose+0x39>
    release(&p->lock);
80102ece:	83 ec 0c             	sub    $0xc,%esp
80102ed1:	53                   	push   %ebx
80102ed2:	e8 de 0d 00 00       	call   80103cb5 <release>
    kfree((char*)p);
80102ed7:	89 1c 24             	mov    %ebx,(%esp)
80102eda:	e8 f6 f0 ff ff       	call   80101fd5 <kfree>
80102edf:	83 c4 10             	add    $0x10,%esp
80102ee2:	eb c7                	jmp    80102eab <pipeclose+0x57>

80102ee4 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102ee4:	f3 0f 1e fb          	endbr32 
80102ee8:	55                   	push   %ebp
80102ee9:	89 e5                	mov    %esp,%ebp
80102eeb:	57                   	push   %edi
80102eec:	56                   	push   %esi
80102eed:	53                   	push   %ebx
80102eee:	83 ec 28             	sub    $0x28,%esp
80102ef1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102ef4:	89 de                	mov    %ebx,%esi
80102ef6:	53                   	push   %ebx
80102ef7:	e8 50 0d 00 00       	call   80103c4c <acquire>
  for(i = 0; i < n; i++){
80102efc:	83 c4 10             	add    $0x10,%esp
80102eff:	bf 00 00 00 00       	mov    $0x0,%edi
80102f04:	3b 7d 10             	cmp    0x10(%ebp),%edi
80102f07:	7c 41                	jl     80102f4a <pipewrite+0x66>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80102f09:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f0f:	83 ec 0c             	sub    $0xc,%esp
80102f12:	50                   	push   %eax
80102f13:	e8 75 09 00 00       	call   8010388d <wakeup>
  release(&p->lock);
80102f18:	89 1c 24             	mov    %ebx,(%esp)
80102f1b:	e8 95 0d 00 00       	call   80103cb5 <release>
  return n;
80102f20:	83 c4 10             	add    $0x10,%esp
80102f23:	8b 45 10             	mov    0x10(%ebp),%eax
80102f26:	eb 5c                	jmp    80102f84 <pipewrite+0xa0>
      wakeup(&p->nread);
80102f28:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f2e:	83 ec 0c             	sub    $0xc,%esp
80102f31:	50                   	push   %eax
80102f32:	e8 56 09 00 00       	call   8010388d <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102f37:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f3d:	83 c4 08             	add    $0x8,%esp
80102f40:	56                   	push   %esi
80102f41:	50                   	push   %eax
80102f42:	e8 d7 07 00 00       	call   8010371e <sleep>
80102f47:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102f4a:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102f50:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102f56:	05 00 02 00 00       	add    $0x200,%eax
80102f5b:	39 c2                	cmp    %eax,%edx
80102f5d:	75 2d                	jne    80102f8c <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80102f5f:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102f66:	74 0b                	je     80102f73 <pipewrite+0x8f>
80102f68:	e8 e4 02 00 00       	call   80103251 <myproc>
80102f6d:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102f71:	74 b5                	je     80102f28 <pipewrite+0x44>
        release(&p->lock);
80102f73:	83 ec 0c             	sub    $0xc,%esp
80102f76:	53                   	push   %ebx
80102f77:	e8 39 0d 00 00       	call   80103cb5 <release>
        return -1;
80102f7c:	83 c4 10             	add    $0x10,%esp
80102f7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102f84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f87:	5b                   	pop    %ebx
80102f88:	5e                   	pop    %esi
80102f89:	5f                   	pop    %edi
80102f8a:	5d                   	pop    %ebp
80102f8b:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80102f8c:	8d 42 01             	lea    0x1(%edx),%eax
80102f8f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80102f95:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102f9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f9e:	8a 04 38             	mov    (%eax,%edi,1),%al
80102fa1:	88 45 e7             	mov    %al,-0x19(%ebp)
80102fa4:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80102fa8:	47                   	inc    %edi
80102fa9:	e9 56 ff ff ff       	jmp    80102f04 <pipewrite+0x20>

80102fae <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80102fae:	f3 0f 1e fb          	endbr32 
80102fb2:	55                   	push   %ebp
80102fb3:	89 e5                	mov    %esp,%ebp
80102fb5:	57                   	push   %edi
80102fb6:	56                   	push   %esi
80102fb7:	53                   	push   %ebx
80102fb8:	83 ec 18             	sub    $0x18,%esp
80102fbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102fbe:	89 df                	mov    %ebx,%edi
80102fc0:	53                   	push   %ebx
80102fc1:	e8 86 0c 00 00       	call   80103c4c <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102fc6:	83 c4 10             	add    $0x10,%esp
80102fc9:	eb 13                	jmp    80102fde <piperead+0x30>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80102fcb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102fd1:	83 ec 08             	sub    $0x8,%esp
80102fd4:	57                   	push   %edi
80102fd5:	50                   	push   %eax
80102fd6:	e8 43 07 00 00       	call   8010371e <sleep>
80102fdb:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102fde:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80102fe4:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80102fea:	75 28                	jne    80103014 <piperead+0x66>
80102fec:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
80102ff2:	85 f6                	test   %esi,%esi
80102ff4:	74 23                	je     80103019 <piperead+0x6b>
    if(myproc()->killed){
80102ff6:	e8 56 02 00 00       	call   80103251 <myproc>
80102ffb:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102fff:	74 ca                	je     80102fcb <piperead+0x1d>
      release(&p->lock);
80103001:	83 ec 0c             	sub    $0xc,%esp
80103004:	53                   	push   %ebx
80103005:	e8 ab 0c 00 00       	call   80103cb5 <release>
      return -1;
8010300a:	83 c4 10             	add    $0x10,%esp
8010300d:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103012:	eb 4d                	jmp    80103061 <piperead+0xb3>
80103014:	be 00 00 00 00       	mov    $0x0,%esi
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103019:	3b 75 10             	cmp    0x10(%ebp),%esi
8010301c:	7d 29                	jge    80103047 <piperead+0x99>
    if(p->nread == p->nwrite)
8010301e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103024:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
8010302a:	74 1b                	je     80103047 <piperead+0x99>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010302c:	8d 50 01             	lea    0x1(%eax),%edx
8010302f:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
80103035:	25 ff 01 00 00       	and    $0x1ff,%eax
8010303a:	8a 44 03 34          	mov    0x34(%ebx,%eax,1),%al
8010303e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103041:	88 04 31             	mov    %al,(%ecx,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103044:	46                   	inc    %esi
80103045:	eb d2                	jmp    80103019 <piperead+0x6b>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103047:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010304d:	83 ec 0c             	sub    $0xc,%esp
80103050:	50                   	push   %eax
80103051:	e8 37 08 00 00       	call   8010388d <wakeup>
  release(&p->lock);
80103056:	89 1c 24             	mov    %ebx,(%esp)
80103059:	e8 57 0c 00 00       	call   80103cb5 <release>
  return i;
8010305e:	83 c4 10             	add    $0x10,%esp
}
80103061:	89 f0                	mov    %esi,%eax
80103063:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103066:	5b                   	pop    %ebx
80103067:	5e                   	pop    %esi
80103068:	5f                   	pop    %edi
80103069:	5d                   	pop    %ebp
8010306a:	c3                   	ret    

8010306b <wakeup1>:
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010306b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103070:	eb 0a                	jmp    8010307c <wakeup1+0x11>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
80103072:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103079:	83 c2 7c             	add    $0x7c,%edx
8010307c:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103082:	73 0d                	jae    80103091 <wakeup1+0x26>
    if(p->state == SLEEPING && p->chan == chan)
80103084:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103088:	75 ef                	jne    80103079 <wakeup1+0xe>
8010308a:	39 42 20             	cmp    %eax,0x20(%edx)
8010308d:	75 ea                	jne    80103079 <wakeup1+0xe>
8010308f:	eb e1                	jmp    80103072 <wakeup1+0x7>
}
80103091:	c3                   	ret    

80103092 <allocproc>:
{
80103092:	55                   	push   %ebp
80103093:	89 e5                	mov    %esp,%ebp
80103095:	53                   	push   %ebx
80103096:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103099:	68 20 2d 11 80       	push   $0x80112d20
8010309e:	e8 a9 0b 00 00       	call   80103c4c <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801030a3:	83 c4 10             	add    $0x10,%esp
801030a6:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801030ab:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801030b1:	73 7b                	jae    8010312e <allocproc+0x9c>
    if(p->state == UNUSED)
801030b3:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
801030b7:	74 05                	je     801030be <allocproc+0x2c>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801030b9:	83 c3 7c             	add    $0x7c,%ebx
801030bc:	eb ed                	jmp    801030ab <allocproc+0x19>
  p->state = EMBRYO;
801030be:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801030c5:	a1 04 a0 10 80       	mov    0x8010a004,%eax
801030ca:	8d 50 01             	lea    0x1(%eax),%edx
801030cd:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
801030d3:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801030d6:	83 ec 0c             	sub    $0xc,%esp
801030d9:	68 20 2d 11 80       	push   $0x80112d20
801030de:	e8 d2 0b 00 00       	call   80103cb5 <release>
  if((p->kstack = kalloc()) == 0){
801030e3:	e8 14 f0 ff ff       	call   801020fc <kalloc>
801030e8:	89 43 08             	mov    %eax,0x8(%ebx)
801030eb:	83 c4 10             	add    $0x10,%esp
801030ee:	85 c0                	test   %eax,%eax
801030f0:	74 53                	je     80103145 <allocproc+0xb3>
  sp -= sizeof *p->tf;
801030f2:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp;
801030f8:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801030fb:	c7 80 b0 0f 00 00 a3 	movl   $0x80104ea3,0xfb0(%eax)
80103102:	4e 10 80 
  sp -= sizeof *p->context;
80103105:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
8010310a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010310d:	83 ec 04             	sub    $0x4,%esp
80103110:	6a 14                	push   $0x14
80103112:	6a 00                	push   $0x0
80103114:	50                   	push   %eax
80103115:	e8 e6 0b 00 00       	call   80103d00 <memset>
  p->context->eip = (uint)forkret;
8010311a:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010311d:	c7 40 10 50 31 10 80 	movl   $0x80103150,0x10(%eax)
  return p;
80103124:	83 c4 10             	add    $0x10,%esp
}
80103127:	89 d8                	mov    %ebx,%eax
80103129:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010312c:	c9                   	leave  
8010312d:	c3                   	ret    
  release(&ptable.lock);
8010312e:	83 ec 0c             	sub    $0xc,%esp
80103131:	68 20 2d 11 80       	push   $0x80112d20
80103136:	e8 7a 0b 00 00       	call   80103cb5 <release>
  return 0;
8010313b:	83 c4 10             	add    $0x10,%esp
8010313e:	bb 00 00 00 00       	mov    $0x0,%ebx
80103143:	eb e2                	jmp    80103127 <allocproc+0x95>
    p->state = UNUSED;
80103145:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010314c:	89 c3                	mov    %eax,%ebx
8010314e:	eb d7                	jmp    80103127 <allocproc+0x95>

80103150 <forkret>:
{
80103150:	f3 0f 1e fb          	endbr32 
80103154:	55                   	push   %ebp
80103155:	89 e5                	mov    %esp,%ebp
80103157:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
8010315a:	68 20 2d 11 80       	push   $0x80112d20
8010315f:	e8 51 0b 00 00       	call   80103cb5 <release>
  if (first) {
80103164:	83 c4 10             	add    $0x10,%esp
80103167:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
8010316e:	75 02                	jne    80103172 <forkret+0x22>
}
80103170:	c9                   	leave  
80103171:	c3                   	ret    
    first = 0;
80103172:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103179:	00 00 00 
    iinit(ROOTDEV);
8010317c:	83 ec 0c             	sub    $0xc,%esp
8010317f:	6a 01                	push   $0x1
80103181:	e8 68 e1 ff ff       	call   801012ee <iinit>
    initlog(ROOTDEV);
80103186:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010318d:	e8 f4 f5 ff ff       	call   80102786 <initlog>
80103192:	83 c4 10             	add    $0x10,%esp
}
80103195:	eb d9                	jmp    80103170 <forkret+0x20>

80103197 <pinit>:
{
80103197:	f3 0f 1e fb          	endbr32 
8010319b:	55                   	push   %ebp
8010319c:	89 e5                	mov    %esp,%ebp
8010319e:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801031a1:	68 80 6b 10 80       	push   $0x80106b80
801031a6:	68 20 2d 11 80       	push   $0x80112d20
801031ab:	e8 51 09 00 00       	call   80103b01 <initlock>
}
801031b0:	83 c4 10             	add    $0x10,%esp
801031b3:	c9                   	leave  
801031b4:	c3                   	ret    

801031b5 <mycpu>:
{
801031b5:	f3 0f 1e fb          	endbr32 
801031b9:	55                   	push   %ebp
801031ba:	89 e5                	mov    %esp,%ebp
801031bc:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801031bf:	9c                   	pushf  
801031c0:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801031c1:	f6 c4 02             	test   $0x2,%ah
801031c4:	75 2a                	jne    801031f0 <mycpu+0x3b>
  apicid = lapicid();
801031c6:	e8 f7 f1 ff ff       	call   801023c2 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801031cb:	b9 00 00 00 00       	mov    $0x0,%ecx
801031d0:	39 0d 00 2d 11 80    	cmp    %ecx,0x80112d00
801031d6:	7e 37                	jle    8010320f <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801031d8:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
801031db:	01 d2                	add    %edx,%edx
801031dd:	01 ca                	add    %ecx,%edx
801031df:	c1 e2 04             	shl    $0x4,%edx
801031e2:	0f b6 92 80 27 11 80 	movzbl -0x7feed880(%edx),%edx
801031e9:	39 c2                	cmp    %eax,%edx
801031eb:	74 10                	je     801031fd <mycpu+0x48>
  for (i = 0; i < ncpu; ++i) {
801031ed:	41                   	inc    %ecx
801031ee:	eb e0                	jmp    801031d0 <mycpu+0x1b>
    panic("mycpu called with interrupts enabled\n");
801031f0:	83 ec 0c             	sub    $0xc,%esp
801031f3:	68 64 6c 10 80       	push   $0x80106c64
801031f8:	e8 58 d1 ff ff       	call   80100355 <panic>
      return &cpus[i];
801031fd:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
80103200:	01 c0                	add    %eax,%eax
80103202:	01 c8                	add    %ecx,%eax
80103204:	c1 e0 04             	shl    $0x4,%eax
80103207:	8d 80 80 27 11 80    	lea    -0x7feed880(%eax),%eax
}
8010320d:	c9                   	leave  
8010320e:	c3                   	ret    
  panic("unknown apicid\n");
8010320f:	83 ec 0c             	sub    $0xc,%esp
80103212:	68 87 6b 10 80       	push   $0x80106b87
80103217:	e8 39 d1 ff ff       	call   80100355 <panic>

8010321c <cpuid>:
cpuid() {
8010321c:	f3 0f 1e fb          	endbr32 
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103226:	e8 8a ff ff ff       	call   801031b5 <mycpu>
8010322b:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103230:	c1 f8 04             	sar    $0x4,%eax
80103233:	8d 0c c0             	lea    (%eax,%eax,8),%ecx
80103236:	89 ca                	mov    %ecx,%edx
80103238:	c1 e2 05             	shl    $0x5,%edx
8010323b:	29 ca                	sub    %ecx,%edx
8010323d:	8d 14 90             	lea    (%eax,%edx,4),%edx
80103240:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
80103243:	89 ca                	mov    %ecx,%edx
80103245:	c1 e2 0f             	shl    $0xf,%edx
80103248:	29 ca                	sub    %ecx,%edx
8010324a:	8d 04 90             	lea    (%eax,%edx,4),%eax
8010324d:	f7 d8                	neg    %eax
}
8010324f:	c9                   	leave  
80103250:	c3                   	ret    

80103251 <myproc>:
myproc(void) {
80103251:	f3 0f 1e fb          	endbr32 
80103255:	55                   	push   %ebp
80103256:	89 e5                	mov    %esp,%ebp
80103258:	53                   	push   %ebx
80103259:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010325c:	e8 03 09 00 00       	call   80103b64 <pushcli>
  c = mycpu();
80103261:	e8 4f ff ff ff       	call   801031b5 <mycpu>
  p = c->proc;
80103266:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010326c:	e8 33 09 00 00       	call   80103ba4 <popcli>
}
80103271:	89 d8                	mov    %ebx,%eax
80103273:	83 c4 04             	add    $0x4,%esp
80103276:	5b                   	pop    %ebx
80103277:	5d                   	pop    %ebp
80103278:	c3                   	ret    

80103279 <userinit>:
{
80103279:	f3 0f 1e fb          	endbr32 
8010327d:	55                   	push   %ebp
8010327e:	89 e5                	mov    %esp,%ebp
80103280:	53                   	push   %ebx
80103281:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103284:	e8 09 fe ff ff       	call   80103092 <allocproc>
80103289:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010328b:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103290:	e8 2b 31 00 00       	call   801063c0 <setupkvm>
80103295:	89 43 04             	mov    %eax,0x4(%ebx)
80103298:	85 c0                	test   %eax,%eax
8010329a:	0f 84 b6 00 00 00    	je     80103356 <userinit+0xdd>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801032a0:	83 ec 04             	sub    $0x4,%esp
801032a3:	68 2c 00 00 00       	push   $0x2c
801032a8:	68 60 a4 10 80       	push   $0x8010a460
801032ad:	50                   	push   %eax
801032ae:	e8 07 2e 00 00       	call   801060ba <inituvm>
  p->sz = PGSIZE;
801032b3:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801032b9:	8b 43 18             	mov    0x18(%ebx),%eax
801032bc:	83 c4 0c             	add    $0xc,%esp
801032bf:	6a 4c                	push   $0x4c
801032c1:	6a 00                	push   $0x0
801032c3:	50                   	push   %eax
801032c4:	e8 37 0a 00 00       	call   80103d00 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801032c9:	8b 43 18             	mov    0x18(%ebx),%eax
801032cc:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801032d2:	8b 43 18             	mov    0x18(%ebx),%eax
801032d5:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801032db:	8b 43 18             	mov    0x18(%ebx),%eax
801032de:	8b 50 2c             	mov    0x2c(%eax),%edx
801032e1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801032e5:	8b 43 18             	mov    0x18(%ebx),%eax
801032e8:	8b 50 2c             	mov    0x2c(%eax),%edx
801032eb:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801032ef:	8b 43 18             	mov    0x18(%ebx),%eax
801032f2:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801032f9:	8b 43 18             	mov    0x18(%ebx),%eax
801032fc:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103303:	8b 43 18             	mov    0x18(%ebx),%eax
80103306:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010330d:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103310:	83 c4 0c             	add    $0xc,%esp
80103313:	6a 10                	push   $0x10
80103315:	68 b0 6b 10 80       	push   $0x80106bb0
8010331a:	50                   	push   %eax
8010331b:	e8 4c 0b 00 00       	call   80103e6c <safestrcpy>
  p->cwd = namei("/");
80103320:	c7 04 24 b9 6b 10 80 	movl   $0x80106bb9,(%esp)
80103327:	e8 e6 e8 ff ff       	call   80101c12 <namei>
8010332c:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010332f:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103336:	e8 11 09 00 00       	call   80103c4c <acquire>
  p->state = RUNNABLE;
8010333b:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103342:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103349:	e8 67 09 00 00       	call   80103cb5 <release>
}
8010334e:	83 c4 10             	add    $0x10,%esp
80103351:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103354:	c9                   	leave  
80103355:	c3                   	ret    
    panic("userinit: out of memory?");
80103356:	83 ec 0c             	sub    $0xc,%esp
80103359:	68 97 6b 10 80       	push   $0x80106b97
8010335e:	e8 f2 cf ff ff       	call   80100355 <panic>

80103363 <growproc>:
{
80103363:	f3 0f 1e fb          	endbr32 
80103367:	55                   	push   %ebp
80103368:	89 e5                	mov    %esp,%ebp
8010336a:	56                   	push   %esi
8010336b:	53                   	push   %ebx
8010336c:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010336f:	e8 dd fe ff ff       	call   80103251 <myproc>
80103374:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103376:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103378:	85 f6                	test   %esi,%esi
8010337a:	7f 1b                	jg     80103397 <growproc+0x34>
  } else if(n < 0){
8010337c:	78 36                	js     801033b4 <growproc+0x51>
  curproc->sz = sz;
8010337e:	89 03                	mov    %eax,(%ebx)
  lcr3(V2P(curproc->pgdir));  // Invalidate TLB.
80103380:	8b 43 04             	mov    0x4(%ebx),%eax
80103383:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80103388:	0f 22 d8             	mov    %eax,%cr3
  return 0;
8010338b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103390:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103393:	5b                   	pop    %ebx
80103394:	5e                   	pop    %esi
80103395:	5d                   	pop    %ebp
80103396:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103397:	83 ec 04             	sub    $0x4,%esp
8010339a:	01 c6                	add    %eax,%esi
8010339c:	56                   	push   %esi
8010339d:	50                   	push   %eax
8010339e:	ff 73 04             	pushl  0x4(%ebx)
801033a1:	e8 b3 2e 00 00       	call   80106259 <allocuvm>
801033a6:	83 c4 10             	add    $0x10,%esp
801033a9:	85 c0                	test   %eax,%eax
801033ab:	75 d1                	jne    8010337e <growproc+0x1b>
      return -1;
801033ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033b2:	eb dc                	jmp    80103390 <growproc+0x2d>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801033b4:	83 ec 04             	sub    $0x4,%esp
801033b7:	01 c6                	add    %eax,%esi
801033b9:	56                   	push   %esi
801033ba:	50                   	push   %eax
801033bb:	ff 73 04             	pushl  0x4(%ebx)
801033be:	e8 02 2e 00 00       	call   801061c5 <deallocuvm>
801033c3:	83 c4 10             	add    $0x10,%esp
801033c6:	85 c0                	test   %eax,%eax
801033c8:	75 b4                	jne    8010337e <growproc+0x1b>
      return -1;
801033ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033cf:	eb bf                	jmp    80103390 <growproc+0x2d>

801033d1 <fork>:
{
801033d1:	f3 0f 1e fb          	endbr32 
801033d5:	55                   	push   %ebp
801033d6:	89 e5                	mov    %esp,%ebp
801033d8:	57                   	push   %edi
801033d9:	56                   	push   %esi
801033da:	53                   	push   %ebx
801033db:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
801033de:	e8 6e fe ff ff       	call   80103251 <myproc>
801033e3:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
801033e5:	e8 a8 fc ff ff       	call   80103092 <allocproc>
801033ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801033ed:	85 c0                	test   %eax,%eax
801033ef:	0f 84 de 00 00 00    	je     801034d3 <fork+0x102>
801033f5:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801033f7:	83 ec 08             	sub    $0x8,%esp
801033fa:	ff 33                	pushl  (%ebx)
801033fc:	ff 73 04             	pushl  0x4(%ebx)
801033ff:	e8 7b 30 00 00       	call   8010647f <copyuvm>
80103404:	89 47 04             	mov    %eax,0x4(%edi)
80103407:	83 c4 10             	add    $0x10,%esp
8010340a:	85 c0                	test   %eax,%eax
8010340c:	74 2a                	je     80103438 <fork+0x67>
  np->sz = curproc->sz;
8010340e:	8b 03                	mov    (%ebx),%eax
80103410:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103413:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103415:	89 c8                	mov    %ecx,%eax
80103417:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010341a:	8b 73 18             	mov    0x18(%ebx),%esi
8010341d:	8b 79 18             	mov    0x18(%ecx),%edi
80103420:	b9 13 00 00 00       	mov    $0x13,%ecx
80103425:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103427:	8b 40 18             	mov    0x18(%eax),%eax
8010342a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103431:	be 00 00 00 00       	mov    $0x0,%esi
80103436:	eb 3a                	jmp    80103472 <fork+0xa1>
    kfree(np->kstack);
80103438:	83 ec 0c             	sub    $0xc,%esp
8010343b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010343e:	ff 73 08             	pushl  0x8(%ebx)
80103441:	e8 8f eb ff ff       	call   80101fd5 <kfree>
    np->kstack = 0;
80103446:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
8010344d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103454:	83 c4 10             	add    $0x10,%esp
80103457:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010345c:	eb 6b                	jmp    801034c9 <fork+0xf8>
      np->ofile[i] = filedup(curproc->ofile[i]);
8010345e:	83 ec 0c             	sub    $0xc,%esp
80103461:	50                   	push   %eax
80103462:	e8 1f d8 ff ff       	call   80100c86 <filedup>
80103467:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010346a:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
8010346e:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
80103471:	46                   	inc    %esi
80103472:	83 fe 0f             	cmp    $0xf,%esi
80103475:	7f 0a                	jg     80103481 <fork+0xb0>
    if(curproc->ofile[i])
80103477:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010347b:	85 c0                	test   %eax,%eax
8010347d:	75 df                	jne    8010345e <fork+0x8d>
8010347f:	eb f0                	jmp    80103471 <fork+0xa0>
  np->cwd = idup(curproc->cwd);
80103481:	83 ec 0c             	sub    $0xc,%esp
80103484:	ff 73 68             	pushl  0x68(%ebx)
80103487:	e8 c8 e0 ff ff       	call   80101554 <idup>
8010348c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010348f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103492:	83 c3 6c             	add    $0x6c,%ebx
80103495:	8d 47 6c             	lea    0x6c(%edi),%eax
80103498:	83 c4 0c             	add    $0xc,%esp
8010349b:	6a 10                	push   $0x10
8010349d:	53                   	push   %ebx
8010349e:	50                   	push   %eax
8010349f:	e8 c8 09 00 00       	call   80103e6c <safestrcpy>
  pid = np->pid;
801034a4:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801034a7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034ae:	e8 99 07 00 00       	call   80103c4c <acquire>
  np->state = RUNNABLE;
801034b3:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801034ba:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034c1:	e8 ef 07 00 00       	call   80103cb5 <release>
  return pid;
801034c6:	83 c4 10             	add    $0x10,%esp
}
801034c9:	89 d8                	mov    %ebx,%eax
801034cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801034ce:	5b                   	pop    %ebx
801034cf:	5e                   	pop    %esi
801034d0:	5f                   	pop    %edi
801034d1:	5d                   	pop    %ebp
801034d2:	c3                   	ret    
    return -1;
801034d3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801034d8:	eb ef                	jmp    801034c9 <fork+0xf8>

801034da <scheduler>:
{
801034da:	f3 0f 1e fb          	endbr32 
801034de:	55                   	push   %ebp
801034df:	89 e5                	mov    %esp,%ebp
801034e1:	56                   	push   %esi
801034e2:	53                   	push   %ebx
  struct cpu *c = mycpu();
801034e3:	e8 cd fc ff ff       	call   801031b5 <mycpu>
801034e8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801034ea:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801034f1:	00 00 00 
801034f4:	eb 5a                	jmp    80103550 <scheduler+0x76>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801034f6:	83 c3 7c             	add    $0x7c,%ebx
801034f9:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801034ff:	73 3f                	jae    80103540 <scheduler+0x66>
      if(p->state != RUNNABLE)
80103501:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103505:	75 ef                	jne    801034f6 <scheduler+0x1c>
      c->proc = p;
80103507:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010350d:	83 ec 0c             	sub    $0xc,%esp
80103510:	53                   	push   %ebx
80103511:	e8 8b 2a 00 00       	call   80105fa1 <switchuvm>
      p->state = RUNNING;
80103516:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
8010351d:	83 c4 08             	add    $0x8,%esp
80103520:	ff 73 1c             	pushl  0x1c(%ebx)
80103523:	8d 46 04             	lea    0x4(%esi),%eax
80103526:	50                   	push   %eax
80103527:	e8 96 09 00 00       	call   80103ec2 <swtch>
      switchkvm();
8010352c:	e8 5e 2a 00 00       	call   80105f8f <switchkvm>
      c->proc = 0;
80103531:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103538:	00 00 00 
8010353b:	83 c4 10             	add    $0x10,%esp
8010353e:	eb b6                	jmp    801034f6 <scheduler+0x1c>
    release(&ptable.lock);
80103540:	83 ec 0c             	sub    $0xc,%esp
80103543:	68 20 2d 11 80       	push   $0x80112d20
80103548:	e8 68 07 00 00       	call   80103cb5 <release>
    sti();
8010354d:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
80103550:	fb                   	sti    
    acquire(&ptable.lock);
80103551:	83 ec 0c             	sub    $0xc,%esp
80103554:	68 20 2d 11 80       	push   $0x80112d20
80103559:	e8 ee 06 00 00       	call   80103c4c <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010355e:	83 c4 10             	add    $0x10,%esp
80103561:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103566:	eb 91                	jmp    801034f9 <scheduler+0x1f>

80103568 <sched>:
{
80103568:	f3 0f 1e fb          	endbr32 
8010356c:	55                   	push   %ebp
8010356d:	89 e5                	mov    %esp,%ebp
8010356f:	56                   	push   %esi
80103570:	53                   	push   %ebx
  struct proc *p = myproc();
80103571:	e8 db fc ff ff       	call   80103251 <myproc>
80103576:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103578:	83 ec 0c             	sub    $0xc,%esp
8010357b:	68 20 2d 11 80       	push   $0x80112d20
80103580:	e8 83 06 00 00       	call   80103c08 <holding>
80103585:	83 c4 10             	add    $0x10,%esp
80103588:	85 c0                	test   %eax,%eax
8010358a:	74 4f                	je     801035db <sched+0x73>
  if(mycpu()->ncli != 1)
8010358c:	e8 24 fc ff ff       	call   801031b5 <mycpu>
80103591:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103598:	75 4e                	jne    801035e8 <sched+0x80>
  if(p->state == RUNNING)
8010359a:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
8010359e:	74 55                	je     801035f5 <sched+0x8d>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801035a0:	9c                   	pushf  
801035a1:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801035a2:	f6 c4 02             	test   $0x2,%ah
801035a5:	75 5b                	jne    80103602 <sched+0x9a>
  intena = mycpu()->intena;
801035a7:	e8 09 fc ff ff       	call   801031b5 <mycpu>
801035ac:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801035b2:	e8 fe fb ff ff       	call   801031b5 <mycpu>
801035b7:	83 ec 08             	sub    $0x8,%esp
801035ba:	ff 70 04             	pushl  0x4(%eax)
801035bd:	83 c3 1c             	add    $0x1c,%ebx
801035c0:	53                   	push   %ebx
801035c1:	e8 fc 08 00 00       	call   80103ec2 <swtch>
  mycpu()->intena = intena;
801035c6:	e8 ea fb ff ff       	call   801031b5 <mycpu>
801035cb:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801035d1:	83 c4 10             	add    $0x10,%esp
801035d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035d7:	5b                   	pop    %ebx
801035d8:	5e                   	pop    %esi
801035d9:	5d                   	pop    %ebp
801035da:	c3                   	ret    
    panic("sched ptable.lock");
801035db:	83 ec 0c             	sub    $0xc,%esp
801035de:	68 bb 6b 10 80       	push   $0x80106bbb
801035e3:	e8 6d cd ff ff       	call   80100355 <panic>
    panic("sched locks");
801035e8:	83 ec 0c             	sub    $0xc,%esp
801035eb:	68 cd 6b 10 80       	push   $0x80106bcd
801035f0:	e8 60 cd ff ff       	call   80100355 <panic>
    panic("sched running");
801035f5:	83 ec 0c             	sub    $0xc,%esp
801035f8:	68 d9 6b 10 80       	push   $0x80106bd9
801035fd:	e8 53 cd ff ff       	call   80100355 <panic>
    panic("sched interruptible");
80103602:	83 ec 0c             	sub    $0xc,%esp
80103605:	68 e7 6b 10 80       	push   $0x80106be7
8010360a:	e8 46 cd ff ff       	call   80100355 <panic>

8010360f <exit>:
{
8010360f:	f3 0f 1e fb          	endbr32 
80103613:	55                   	push   %ebp
80103614:	89 e5                	mov    %esp,%ebp
80103616:	56                   	push   %esi
80103617:	53                   	push   %ebx
  struct proc *curproc = myproc();
80103618:	e8 34 fc ff ff       	call   80103251 <myproc>
  if(curproc == initproc)
8010361d:	39 05 b8 a5 10 80    	cmp    %eax,0x8010a5b8
80103623:	74 09                	je     8010362e <exit+0x1f>
80103625:	89 c6                	mov    %eax,%esi
  for(fd = 0; fd < NOFILE; fd++){
80103627:	bb 00 00 00 00       	mov    $0x0,%ebx
8010362c:	eb 22                	jmp    80103650 <exit+0x41>
    panic("init exiting");
8010362e:	83 ec 0c             	sub    $0xc,%esp
80103631:	68 fb 6b 10 80       	push   $0x80106bfb
80103636:	e8 1a cd ff ff       	call   80100355 <panic>
      fileclose(curproc->ofile[fd]);
8010363b:	83 ec 0c             	sub    $0xc,%esp
8010363e:	50                   	push   %eax
8010363f:	e8 89 d6 ff ff       	call   80100ccd <fileclose>
      curproc->ofile[fd] = 0;
80103644:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
8010364b:	00 
8010364c:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
8010364f:	43                   	inc    %ebx
80103650:	83 fb 0f             	cmp    $0xf,%ebx
80103653:	7f 0a                	jg     8010365f <exit+0x50>
    if(curproc->ofile[fd]){
80103655:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
80103659:	85 c0                	test   %eax,%eax
8010365b:	75 de                	jne    8010363b <exit+0x2c>
8010365d:	eb f0                	jmp    8010364f <exit+0x40>
  begin_op();
8010365f:	e8 6f f1 ff ff       	call   801027d3 <begin_op>
  iput(curproc->cwd);
80103664:	83 ec 0c             	sub    $0xc,%esp
80103667:	ff 76 68             	pushl  0x68(%esi)
8010366a:	e8 24 e0 ff ff       	call   80101693 <iput>
  end_op();
8010366f:	e8 df f1 ff ff       	call   80102853 <end_op>
  curproc->cwd = 0;
80103674:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010367b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103682:	e8 c5 05 00 00       	call   80103c4c <acquire>
  wakeup1(curproc->parent);
80103687:	8b 46 14             	mov    0x14(%esi),%eax
8010368a:	e8 dc f9 ff ff       	call   8010306b <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010368f:	83 c4 10             	add    $0x10,%esp
80103692:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103697:	eb 03                	jmp    8010369c <exit+0x8d>
80103699:	83 c3 7c             	add    $0x7c,%ebx
8010369c:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801036a2:	73 1a                	jae    801036be <exit+0xaf>
    if(p->parent == curproc){
801036a4:	39 73 14             	cmp    %esi,0x14(%ebx)
801036a7:	75 f0                	jne    80103699 <exit+0x8a>
      p->parent = initproc;
801036a9:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
801036ae:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
801036b1:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801036b5:	75 e2                	jne    80103699 <exit+0x8a>
        wakeup1(initproc);
801036b7:	e8 af f9 ff ff       	call   8010306b <wakeup1>
801036bc:	eb db                	jmp    80103699 <exit+0x8a>
  deallocuvm(curproc->pgdir, KERNBASE, 0);
801036be:	83 ec 04             	sub    $0x4,%esp
801036c1:	6a 00                	push   $0x0
801036c3:	68 00 00 00 80       	push   $0x80000000
801036c8:	ff 76 04             	pushl  0x4(%esi)
801036cb:	e8 f5 2a 00 00       	call   801061c5 <deallocuvm>
  curproc->state = ZOMBIE;
801036d0:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801036d7:	e8 8c fe ff ff       	call   80103568 <sched>
  panic("zombie exit");
801036dc:	c7 04 24 08 6c 10 80 	movl   $0x80106c08,(%esp)
801036e3:	e8 6d cc ff ff       	call   80100355 <panic>

801036e8 <yield>:
{
801036e8:	f3 0f 1e fb          	endbr32 
801036ec:	55                   	push   %ebp
801036ed:	89 e5                	mov    %esp,%ebp
801036ef:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801036f2:	68 20 2d 11 80       	push   $0x80112d20
801036f7:	e8 50 05 00 00       	call   80103c4c <acquire>
  myproc()->state = RUNNABLE;
801036fc:	e8 50 fb ff ff       	call   80103251 <myproc>
80103701:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103708:	e8 5b fe ff ff       	call   80103568 <sched>
  release(&ptable.lock);
8010370d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103714:	e8 9c 05 00 00       	call   80103cb5 <release>
}
80103719:	83 c4 10             	add    $0x10,%esp
8010371c:	c9                   	leave  
8010371d:	c3                   	ret    

8010371e <sleep>:
{
8010371e:	f3 0f 1e fb          	endbr32 
80103722:	55                   	push   %ebp
80103723:	89 e5                	mov    %esp,%ebp
80103725:	56                   	push   %esi
80103726:	53                   	push   %ebx
80103727:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
8010372a:	e8 22 fb ff ff       	call   80103251 <myproc>
  if(p == 0)
8010372f:	85 c0                	test   %eax,%eax
80103731:	74 66                	je     80103799 <sleep+0x7b>
80103733:	89 c3                	mov    %eax,%ebx
  if(lk == 0)
80103735:	85 f6                	test   %esi,%esi
80103737:	74 6d                	je     801037a6 <sleep+0x88>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103739:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
8010373f:	74 18                	je     80103759 <sleep+0x3b>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103741:	83 ec 0c             	sub    $0xc,%esp
80103744:	68 20 2d 11 80       	push   $0x80112d20
80103749:	e8 fe 04 00 00       	call   80103c4c <acquire>
    release(lk);
8010374e:	89 34 24             	mov    %esi,(%esp)
80103751:	e8 5f 05 00 00       	call   80103cb5 <release>
80103756:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
80103759:	8b 45 08             	mov    0x8(%ebp),%eax
8010375c:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
8010375f:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103766:	e8 fd fd ff ff       	call   80103568 <sched>
  p->chan = 0;
8010376b:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
80103772:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103778:	74 18                	je     80103792 <sleep+0x74>
    release(&ptable.lock);
8010377a:	83 ec 0c             	sub    $0xc,%esp
8010377d:	68 20 2d 11 80       	push   $0x80112d20
80103782:	e8 2e 05 00 00       	call   80103cb5 <release>
    acquire(lk);
80103787:	89 34 24             	mov    %esi,(%esp)
8010378a:	e8 bd 04 00 00       	call   80103c4c <acquire>
8010378f:	83 c4 10             	add    $0x10,%esp
}
80103792:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103795:	5b                   	pop    %ebx
80103796:	5e                   	pop    %esi
80103797:	5d                   	pop    %ebp
80103798:	c3                   	ret    
    panic("sleep");
80103799:	83 ec 0c             	sub    $0xc,%esp
8010379c:	68 14 6c 10 80       	push   $0x80106c14
801037a1:	e8 af cb ff ff       	call   80100355 <panic>
    panic("sleep without lk");
801037a6:	83 ec 0c             	sub    $0xc,%esp
801037a9:	68 1a 6c 10 80       	push   $0x80106c1a
801037ae:	e8 a2 cb ff ff       	call   80100355 <panic>

801037b3 <wait>:
{
801037b3:	f3 0f 1e fb          	endbr32 
801037b7:	55                   	push   %ebp
801037b8:	89 e5                	mov    %esp,%ebp
801037ba:	56                   	push   %esi
801037bb:	53                   	push   %ebx
  struct proc *curproc = myproc();
801037bc:	e8 90 fa ff ff       	call   80103251 <myproc>
801037c1:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
801037c3:	83 ec 0c             	sub    $0xc,%esp
801037c6:	68 20 2d 11 80       	push   $0x80112d20
801037cb:	e8 7c 04 00 00       	call   80103c4c <acquire>
801037d0:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801037d3:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801037d8:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801037dd:	eb 5d                	jmp    8010383c <wait+0x89>
        pid = p->pid;
801037df:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801037e2:	83 ec 0c             	sub    $0xc,%esp
801037e5:	ff 73 08             	pushl  0x8(%ebx)
801037e8:	e8 e8 e7 ff ff       	call   80101fd5 <kfree>
        p->kstack = 0;
801037ed:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir, 0); // User zone deleted before
801037f4:	83 c4 08             	add    $0x8,%esp
801037f7:	6a 00                	push   $0x0
801037f9:	ff 73 04             	pushl  0x4(%ebx)
801037fc:	e8 45 2b 00 00       	call   80106346 <freevm>
        p->pid = 0;
80103801:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103808:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010380f:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103813:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010381a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103821:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103828:	e8 88 04 00 00       	call   80103cb5 <release>
        return pid;
8010382d:	83 c4 10             	add    $0x10,%esp
}
80103830:	89 f0                	mov    %esi,%eax
80103832:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103835:	5b                   	pop    %ebx
80103836:	5e                   	pop    %esi
80103837:	5d                   	pop    %ebp
80103838:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103839:	83 c3 7c             	add    $0x7c,%ebx
8010383c:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103842:	73 12                	jae    80103856 <wait+0xa3>
      if(p->parent != curproc)
80103844:	39 73 14             	cmp    %esi,0x14(%ebx)
80103847:	75 f0                	jne    80103839 <wait+0x86>
      if(p->state == ZOMBIE){
80103849:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010384d:	74 90                	je     801037df <wait+0x2c>
      havekids = 1;
8010384f:	b8 01 00 00 00       	mov    $0x1,%eax
80103854:	eb e3                	jmp    80103839 <wait+0x86>
    if(!havekids || curproc->killed){
80103856:	85 c0                	test   %eax,%eax
80103858:	74 06                	je     80103860 <wait+0xad>
8010385a:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
8010385e:	74 17                	je     80103877 <wait+0xc4>
      release(&ptable.lock);
80103860:	83 ec 0c             	sub    $0xc,%esp
80103863:	68 20 2d 11 80       	push   $0x80112d20
80103868:	e8 48 04 00 00       	call   80103cb5 <release>
      return -1;
8010386d:	83 c4 10             	add    $0x10,%esp
80103870:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103875:	eb b9                	jmp    80103830 <wait+0x7d>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103877:	83 ec 08             	sub    $0x8,%esp
8010387a:	68 20 2d 11 80       	push   $0x80112d20
8010387f:	56                   	push   %esi
80103880:	e8 99 fe ff ff       	call   8010371e <sleep>
    havekids = 0;
80103885:	83 c4 10             	add    $0x10,%esp
80103888:	e9 46 ff ff ff       	jmp    801037d3 <wait+0x20>

8010388d <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010388d:	f3 0f 1e fb          	endbr32 
80103891:	55                   	push   %ebp
80103892:	89 e5                	mov    %esp,%ebp
80103894:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
80103897:	68 20 2d 11 80       	push   $0x80112d20
8010389c:	e8 ab 03 00 00       	call   80103c4c <acquire>
  wakeup1(chan);
801038a1:	8b 45 08             	mov    0x8(%ebp),%eax
801038a4:	e8 c2 f7 ff ff       	call   8010306b <wakeup1>
  release(&ptable.lock);
801038a9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801038b0:	e8 00 04 00 00       	call   80103cb5 <release>
}
801038b5:	83 c4 10             	add    $0x10,%esp
801038b8:	c9                   	leave  
801038b9:	c3                   	ret    

801038ba <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801038ba:	f3 0f 1e fb          	endbr32 
801038be:	55                   	push   %ebp
801038bf:	89 e5                	mov    %esp,%ebp
801038c1:	53                   	push   %ebx
801038c2:	83 ec 10             	sub    $0x10,%esp
801038c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801038c8:	68 20 2d 11 80       	push   $0x80112d20
801038cd:	e8 7a 03 00 00       	call   80103c4c <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038d2:	83 c4 10             	add    $0x10,%esp
801038d5:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801038da:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801038df:	73 3a                	jae    8010391b <kill+0x61>
    if(p->pid == pid){
801038e1:	39 58 10             	cmp    %ebx,0x10(%eax)
801038e4:	74 05                	je     801038eb <kill+0x31>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038e6:	83 c0 7c             	add    $0x7c,%eax
801038e9:	eb ef                	jmp    801038da <kill+0x20>
      p->killed = 1;
801038eb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801038f2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801038f6:	74 1a                	je     80103912 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
801038f8:	83 ec 0c             	sub    $0xc,%esp
801038fb:	68 20 2d 11 80       	push   $0x80112d20
80103900:	e8 b0 03 00 00       	call   80103cb5 <release>
      return 0;
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
8010390d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103910:	c9                   	leave  
80103911:	c3                   	ret    
        p->state = RUNNABLE;
80103912:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103919:	eb dd                	jmp    801038f8 <kill+0x3e>
  release(&ptable.lock);
8010391b:	83 ec 0c             	sub    $0xc,%esp
8010391e:	68 20 2d 11 80       	push   $0x80112d20
80103923:	e8 8d 03 00 00       	call   80103cb5 <release>
  return -1;
80103928:	83 c4 10             	add    $0x10,%esp
8010392b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103930:	eb db                	jmp    8010390d <kill+0x53>

80103932 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103932:	f3 0f 1e fb          	endbr32 
80103936:	55                   	push   %ebp
80103937:	89 e5                	mov    %esp,%ebp
80103939:	56                   	push   %esi
8010393a:	53                   	push   %ebx
8010393b:	83 ec 30             	sub    $0x30,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010393e:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103943:	eb 33                	jmp    80103978 <procdump+0x46>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
80103945:	b8 2b 6c 10 80       	mov    $0x80106c2b,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
8010394a:	8d 53 6c             	lea    0x6c(%ebx),%edx
8010394d:	52                   	push   %edx
8010394e:	50                   	push   %eax
8010394f:	ff 73 10             	pushl  0x10(%ebx)
80103952:	68 2f 6c 10 80       	push   $0x80106c2f
80103957:	e8 a1 cc ff ff       	call   801005fd <cprintf>
    if(p->state == SLEEPING){
8010395c:	83 c4 10             	add    $0x10,%esp
8010395f:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103963:	74 39                	je     8010399e <procdump+0x6c>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103965:	83 ec 0c             	sub    $0xc,%esp
80103968:	68 9f 6f 10 80       	push   $0x80106f9f
8010396d:	e8 8b cc ff ff       	call   801005fd <cprintf>
80103972:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103975:	83 c3 7c             	add    $0x7c,%ebx
80103978:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
8010397e:	73 5f                	jae    801039df <procdump+0xad>
    if(p->state == UNUSED)
80103980:	8b 43 0c             	mov    0xc(%ebx),%eax
80103983:	85 c0                	test   %eax,%eax
80103985:	74 ee                	je     80103975 <procdump+0x43>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103987:	83 f8 05             	cmp    $0x5,%eax
8010398a:	77 b9                	ja     80103945 <procdump+0x13>
8010398c:	8b 04 85 8c 6c 10 80 	mov    -0x7fef9374(,%eax,4),%eax
80103993:	85 c0                	test   %eax,%eax
80103995:	75 b3                	jne    8010394a <procdump+0x18>
      state = "???";
80103997:	b8 2b 6c 10 80       	mov    $0x80106c2b,%eax
8010399c:	eb ac                	jmp    8010394a <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010399e:	8b 43 1c             	mov    0x1c(%ebx),%eax
801039a1:	8b 40 0c             	mov    0xc(%eax),%eax
801039a4:	83 c0 08             	add    $0x8,%eax
801039a7:	83 ec 08             	sub    $0x8,%esp
801039aa:	8d 55 d0             	lea    -0x30(%ebp),%edx
801039ad:	52                   	push   %edx
801039ae:	50                   	push   %eax
801039af:	e8 6c 01 00 00       	call   80103b20 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801039b4:	83 c4 10             	add    $0x10,%esp
801039b7:	be 00 00 00 00       	mov    $0x0,%esi
801039bc:	eb 12                	jmp    801039d0 <procdump+0x9e>
        cprintf(" %p", pc[i]);
801039be:	83 ec 08             	sub    $0x8,%esp
801039c1:	50                   	push   %eax
801039c2:	68 81 66 10 80       	push   $0x80106681
801039c7:	e8 31 cc ff ff       	call   801005fd <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801039cc:	46                   	inc    %esi
801039cd:	83 c4 10             	add    $0x10,%esp
801039d0:	83 fe 09             	cmp    $0x9,%esi
801039d3:	7f 90                	jg     80103965 <procdump+0x33>
801039d5:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
801039d9:	85 c0                	test   %eax,%eax
801039db:	75 e1                	jne    801039be <procdump+0x8c>
801039dd:	eb 86                	jmp    80103965 <procdump+0x33>
  }
}
801039df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039e2:	5b                   	pop    %ebx
801039e3:	5e                   	pop    %esi
801039e4:	5d                   	pop    %ebp
801039e5:	c3                   	ret    

801039e6 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801039e6:	f3 0f 1e fb          	endbr32 
801039ea:	55                   	push   %ebp
801039eb:	89 e5                	mov    %esp,%ebp
801039ed:	53                   	push   %ebx
801039ee:	83 ec 0c             	sub    $0xc,%esp
801039f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801039f4:	68 a4 6c 10 80       	push   $0x80106ca4
801039f9:	8d 43 04             	lea    0x4(%ebx),%eax
801039fc:	50                   	push   %eax
801039fd:	e8 ff 00 00 00       	call   80103b01 <initlock>
  lk->name = name;
80103a02:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a05:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103a08:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103a0e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103a15:	83 c4 10             	add    $0x10,%esp
80103a18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a1b:	c9                   	leave  
80103a1c:	c3                   	ret    

80103a1d <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103a1d:	f3 0f 1e fb          	endbr32 
80103a21:	55                   	push   %ebp
80103a22:	89 e5                	mov    %esp,%ebp
80103a24:	56                   	push   %esi
80103a25:	53                   	push   %ebx
80103a26:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103a29:	8d 73 04             	lea    0x4(%ebx),%esi
80103a2c:	83 ec 0c             	sub    $0xc,%esp
80103a2f:	56                   	push   %esi
80103a30:	e8 17 02 00 00       	call   80103c4c <acquire>
  while (lk->locked) {
80103a35:	83 c4 10             	add    $0x10,%esp
80103a38:	83 3b 00             	cmpl   $0x0,(%ebx)
80103a3b:	74 0f                	je     80103a4c <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80103a3d:	83 ec 08             	sub    $0x8,%esp
80103a40:	56                   	push   %esi
80103a41:	53                   	push   %ebx
80103a42:	e8 d7 fc ff ff       	call   8010371e <sleep>
80103a47:	83 c4 10             	add    $0x10,%esp
80103a4a:	eb ec                	jmp    80103a38 <acquiresleep+0x1b>
  }
  lk->locked = 1;
80103a4c:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103a52:	e8 fa f7 ff ff       	call   80103251 <myproc>
80103a57:	8b 40 10             	mov    0x10(%eax),%eax
80103a5a:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103a5d:	83 ec 0c             	sub    $0xc,%esp
80103a60:	56                   	push   %esi
80103a61:	e8 4f 02 00 00       	call   80103cb5 <release>
}
80103a66:	83 c4 10             	add    $0x10,%esp
80103a69:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a6c:	5b                   	pop    %ebx
80103a6d:	5e                   	pop    %esi
80103a6e:	5d                   	pop    %ebp
80103a6f:	c3                   	ret    

80103a70 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103a70:	f3 0f 1e fb          	endbr32 
80103a74:	55                   	push   %ebp
80103a75:	89 e5                	mov    %esp,%ebp
80103a77:	56                   	push   %esi
80103a78:	53                   	push   %ebx
80103a79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103a7c:	8d 73 04             	lea    0x4(%ebx),%esi
80103a7f:	83 ec 0c             	sub    $0xc,%esp
80103a82:	56                   	push   %esi
80103a83:	e8 c4 01 00 00       	call   80103c4c <acquire>
  lk->locked = 0;
80103a88:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103a8e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103a95:	89 1c 24             	mov    %ebx,(%esp)
80103a98:	e8 f0 fd ff ff       	call   8010388d <wakeup>
  release(&lk->lk);
80103a9d:	89 34 24             	mov    %esi,(%esp)
80103aa0:	e8 10 02 00 00       	call   80103cb5 <release>
}
80103aa5:	83 c4 10             	add    $0x10,%esp
80103aa8:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103aab:	5b                   	pop    %ebx
80103aac:	5e                   	pop    %esi
80103aad:	5d                   	pop    %ebp
80103aae:	c3                   	ret    

80103aaf <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103aaf:	f3 0f 1e fb          	endbr32 
80103ab3:	55                   	push   %ebp
80103ab4:	89 e5                	mov    %esp,%ebp
80103ab6:	56                   	push   %esi
80103ab7:	53                   	push   %ebx
80103ab8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103abb:	8d 73 04             	lea    0x4(%ebx),%esi
80103abe:	83 ec 0c             	sub    $0xc,%esp
80103ac1:	56                   	push   %esi
80103ac2:	e8 85 01 00 00       	call   80103c4c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103ac7:	83 c4 10             	add    $0x10,%esp
80103aca:	83 3b 00             	cmpl   $0x0,(%ebx)
80103acd:	75 17                	jne    80103ae6 <holdingsleep+0x37>
80103acf:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
80103ad4:	83 ec 0c             	sub    $0xc,%esp
80103ad7:	56                   	push   %esi
80103ad8:	e8 d8 01 00 00       	call   80103cb5 <release>
  return r;
}
80103add:	89 d8                	mov    %ebx,%eax
80103adf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ae2:	5b                   	pop    %ebx
80103ae3:	5e                   	pop    %esi
80103ae4:	5d                   	pop    %ebp
80103ae5:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103ae6:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103ae9:	e8 63 f7 ff ff       	call   80103251 <myproc>
80103aee:	3b 58 10             	cmp    0x10(%eax),%ebx
80103af1:	74 07                	je     80103afa <holdingsleep+0x4b>
80103af3:	bb 00 00 00 00       	mov    $0x0,%ebx
80103af8:	eb da                	jmp    80103ad4 <holdingsleep+0x25>
80103afa:	bb 01 00 00 00       	mov    $0x1,%ebx
80103aff:	eb d3                	jmp    80103ad4 <holdingsleep+0x25>

80103b01 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103b01:	f3 0f 1e fb          	endbr32 
80103b05:	55                   	push   %ebp
80103b06:	89 e5                	mov    %esp,%ebp
80103b08:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103b0b:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b0e:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103b11:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103b17:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103b1e:	5d                   	pop    %ebp
80103b1f:	c3                   	ret    

80103b20 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103b20:	f3 0f 1e fb          	endbr32 
80103b24:	55                   	push   %ebp
80103b25:	89 e5                	mov    %esp,%ebp
80103b27:	53                   	push   %ebx
80103b28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103b2b:	8b 45 08             	mov    0x8(%ebp),%eax
80103b2e:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103b31:	b8 00 00 00 00       	mov    $0x0,%eax
80103b36:	83 f8 09             	cmp    $0x9,%eax
80103b39:	7f 21                	jg     80103b5c <getcallerpcs+0x3c>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103b3b:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103b41:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103b47:	77 13                	ja     80103b5c <getcallerpcs+0x3c>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103b49:	8b 5a 04             	mov    0x4(%edx),%ebx
80103b4c:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103b4f:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103b51:	40                   	inc    %eax
80103b52:	eb e2                	jmp    80103b36 <getcallerpcs+0x16>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103b54:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103b5b:	40                   	inc    %eax
80103b5c:	83 f8 09             	cmp    $0x9,%eax
80103b5f:	7e f3                	jle    80103b54 <getcallerpcs+0x34>
}
80103b61:	5b                   	pop    %ebx
80103b62:	5d                   	pop    %ebp
80103b63:	c3                   	ret    

80103b64 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103b64:	f3 0f 1e fb          	endbr32 
80103b68:	55                   	push   %ebp
80103b69:	89 e5                	mov    %esp,%ebp
80103b6b:	53                   	push   %ebx
80103b6c:	83 ec 04             	sub    $0x4,%esp
80103b6f:	9c                   	pushf  
80103b70:	5b                   	pop    %ebx
  asm volatile("cli");
80103b71:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103b72:	e8 3e f6 ff ff       	call   801031b5 <mycpu>
80103b77:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103b7e:	74 11                	je     80103b91 <pushcli+0x2d>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103b80:	e8 30 f6 ff ff       	call   801031b5 <mycpu>
80103b85:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80103b8b:	83 c4 04             	add    $0x4,%esp
80103b8e:	5b                   	pop    %ebx
80103b8f:	5d                   	pop    %ebp
80103b90:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103b91:	e8 1f f6 ff ff       	call   801031b5 <mycpu>
80103b96:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103b9c:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103ba2:	eb dc                	jmp    80103b80 <pushcli+0x1c>

80103ba4 <popcli>:

void
popcli(void)
{
80103ba4:	f3 0f 1e fb          	endbr32 
80103ba8:	55                   	push   %ebp
80103ba9:	89 e5                	mov    %esp,%ebp
80103bab:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103bae:	9c                   	pushf  
80103baf:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103bb0:	f6 c4 02             	test   $0x2,%ah
80103bb3:	75 28                	jne    80103bdd <popcli+0x39>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103bb5:	e8 fb f5 ff ff       	call   801031b5 <mycpu>
80103bba:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103bc0:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103bc3:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103bc9:	85 d2                	test   %edx,%edx
80103bcb:	78 1d                	js     80103bea <popcli+0x46>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103bcd:	e8 e3 f5 ff ff       	call   801031b5 <mycpu>
80103bd2:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103bd9:	74 1c                	je     80103bf7 <popcli+0x53>
    sti();
}
80103bdb:	c9                   	leave  
80103bdc:	c3                   	ret    
    panic("popcli - interruptible");
80103bdd:	83 ec 0c             	sub    $0xc,%esp
80103be0:	68 af 6c 10 80       	push   $0x80106caf
80103be5:	e8 6b c7 ff ff       	call   80100355 <panic>
    panic("popcli");
80103bea:	83 ec 0c             	sub    $0xc,%esp
80103bed:	68 c6 6c 10 80       	push   $0x80106cc6
80103bf2:	e8 5e c7 ff ff       	call   80100355 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103bf7:	e8 b9 f5 ff ff       	call   801031b5 <mycpu>
80103bfc:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103c03:	74 d6                	je     80103bdb <popcli+0x37>
  asm volatile("sti");
80103c05:	fb                   	sti    
}
80103c06:	eb d3                	jmp    80103bdb <popcli+0x37>

80103c08 <holding>:
{
80103c08:	f3 0f 1e fb          	endbr32 
80103c0c:	55                   	push   %ebp
80103c0d:	89 e5                	mov    %esp,%ebp
80103c0f:	53                   	push   %ebx
80103c10:	83 ec 04             	sub    $0x4,%esp
80103c13:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103c16:	e8 49 ff ff ff       	call   80103b64 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103c1b:	83 3b 00             	cmpl   $0x0,(%ebx)
80103c1e:	75 12                	jne    80103c32 <holding+0x2a>
80103c20:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103c25:	e8 7a ff ff ff       	call   80103ba4 <popcli>
}
80103c2a:	89 d8                	mov    %ebx,%eax
80103c2c:	83 c4 04             	add    $0x4,%esp
80103c2f:	5b                   	pop    %ebx
80103c30:	5d                   	pop    %ebp
80103c31:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103c32:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103c35:	e8 7b f5 ff ff       	call   801031b5 <mycpu>
80103c3a:	39 c3                	cmp    %eax,%ebx
80103c3c:	74 07                	je     80103c45 <holding+0x3d>
80103c3e:	bb 00 00 00 00       	mov    $0x0,%ebx
80103c43:	eb e0                	jmp    80103c25 <holding+0x1d>
80103c45:	bb 01 00 00 00       	mov    $0x1,%ebx
80103c4a:	eb d9                	jmp    80103c25 <holding+0x1d>

80103c4c <acquire>:
{
80103c4c:	f3 0f 1e fb          	endbr32 
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	53                   	push   %ebx
80103c54:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103c57:	e8 08 ff ff ff       	call   80103b64 <pushcli>
  if(holding(lk))
80103c5c:	83 ec 0c             	sub    $0xc,%esp
80103c5f:	ff 75 08             	pushl  0x8(%ebp)
80103c62:	e8 a1 ff ff ff       	call   80103c08 <holding>
80103c67:	83 c4 10             	add    $0x10,%esp
80103c6a:	85 c0                	test   %eax,%eax
80103c6c:	75 3a                	jne    80103ca8 <acquire+0x5c>
  while(xchg(&lk->locked, 1) != 0)
80103c6e:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103c71:	b8 01 00 00 00       	mov    $0x1,%eax
80103c76:	f0 87 02             	lock xchg %eax,(%edx)
80103c79:	85 c0                	test   %eax,%eax
80103c7b:	75 f1                	jne    80103c6e <acquire+0x22>
  __sync_synchronize();
80103c7d:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103c82:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103c85:	e8 2b f5 ff ff       	call   801031b5 <mycpu>
80103c8a:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103c8d:	8b 45 08             	mov    0x8(%ebp),%eax
80103c90:	83 c0 0c             	add    $0xc,%eax
80103c93:	83 ec 08             	sub    $0x8,%esp
80103c96:	50                   	push   %eax
80103c97:	8d 45 08             	lea    0x8(%ebp),%eax
80103c9a:	50                   	push   %eax
80103c9b:	e8 80 fe ff ff       	call   80103b20 <getcallerpcs>
}
80103ca0:	83 c4 10             	add    $0x10,%esp
80103ca3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ca6:	c9                   	leave  
80103ca7:	c3                   	ret    
    panic("acquire");
80103ca8:	83 ec 0c             	sub    $0xc,%esp
80103cab:	68 cd 6c 10 80       	push   $0x80106ccd
80103cb0:	e8 a0 c6 ff ff       	call   80100355 <panic>

80103cb5 <release>:
{
80103cb5:	f3 0f 1e fb          	endbr32 
80103cb9:	55                   	push   %ebp
80103cba:	89 e5                	mov    %esp,%ebp
80103cbc:	53                   	push   %ebx
80103cbd:	83 ec 10             	sub    $0x10,%esp
80103cc0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103cc3:	53                   	push   %ebx
80103cc4:	e8 3f ff ff ff       	call   80103c08 <holding>
80103cc9:	83 c4 10             	add    $0x10,%esp
80103ccc:	85 c0                	test   %eax,%eax
80103cce:	74 23                	je     80103cf3 <release+0x3e>
  lk->pcs[0] = 0;
80103cd0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103cd7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103cde:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103ce3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103ce9:	e8 b6 fe ff ff       	call   80103ba4 <popcli>
}
80103cee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cf1:	c9                   	leave  
80103cf2:	c3                   	ret    
    panic("release");
80103cf3:	83 ec 0c             	sub    $0xc,%esp
80103cf6:	68 d5 6c 10 80       	push   $0x80106cd5
80103cfb:	e8 55 c6 ff ff       	call   80100355 <panic>

80103d00 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103d00:	f3 0f 1e fb          	endbr32 
80103d04:	55                   	push   %ebp
80103d05:	89 e5                	mov    %esp,%ebp
80103d07:	57                   	push   %edi
80103d08:	53                   	push   %ebx
80103d09:	8b 55 08             	mov    0x8(%ebp),%edx
80103d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80103d0f:	f6 c2 03             	test   $0x3,%dl
80103d12:	75 29                	jne    80103d3d <memset+0x3d>
80103d14:	f6 45 10 03          	testb  $0x3,0x10(%ebp)
80103d18:	75 23                	jne    80103d3d <memset+0x3d>
    c &= 0xFF;
80103d1a:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103d1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103d20:	c1 e9 02             	shr    $0x2,%ecx
80103d23:	c1 e0 18             	shl    $0x18,%eax
80103d26:	89 fb                	mov    %edi,%ebx
80103d28:	c1 e3 10             	shl    $0x10,%ebx
80103d2b:	09 d8                	or     %ebx,%eax
80103d2d:	89 fb                	mov    %edi,%ebx
80103d2f:	c1 e3 08             	shl    $0x8,%ebx
80103d32:	09 d8                	or     %ebx,%eax
80103d34:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103d36:	89 d7                	mov    %edx,%edi
80103d38:	fc                   	cld    
80103d39:	f3 ab                	rep stos %eax,%es:(%edi)
}
80103d3b:	eb 08                	jmp    80103d45 <memset+0x45>
  asm volatile("cld; rep stosb" :
80103d3d:	89 d7                	mov    %edx,%edi
80103d3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103d42:	fc                   	cld    
80103d43:	f3 aa                	rep stos %al,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80103d45:	89 d0                	mov    %edx,%eax
80103d47:	5b                   	pop    %ebx
80103d48:	5f                   	pop    %edi
80103d49:	5d                   	pop    %ebp
80103d4a:	c3                   	ret    

80103d4b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103d4b:	f3 0f 1e fb          	endbr32 
80103d4f:	55                   	push   %ebp
80103d50:	89 e5                	mov    %esp,%ebp
80103d52:	56                   	push   %esi
80103d53:	53                   	push   %ebx
80103d54:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103d57:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d5a:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103d5d:	8d 70 ff             	lea    -0x1(%eax),%esi
80103d60:	85 c0                	test   %eax,%eax
80103d62:	74 16                	je     80103d7a <memcmp+0x2f>
    if(*s1 != *s2)
80103d64:	8a 01                	mov    (%ecx),%al
80103d66:	8a 1a                	mov    (%edx),%bl
80103d68:	38 d8                	cmp    %bl,%al
80103d6a:	75 06                	jne    80103d72 <memcmp+0x27>
      return *s1 - *s2;
    s1++, s2++;
80103d6c:	41                   	inc    %ecx
80103d6d:	42                   	inc    %edx
  while(n-- > 0){
80103d6e:	89 f0                	mov    %esi,%eax
80103d70:	eb eb                	jmp    80103d5d <memcmp+0x12>
      return *s1 - *s2;
80103d72:	0f b6 c0             	movzbl %al,%eax
80103d75:	0f b6 db             	movzbl %bl,%ebx
80103d78:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80103d7a:	5b                   	pop    %ebx
80103d7b:	5e                   	pop    %esi
80103d7c:	5d                   	pop    %ebp
80103d7d:	c3                   	ret    

80103d7e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103d7e:	f3 0f 1e fb          	endbr32 
80103d82:	55                   	push   %ebp
80103d83:	89 e5                	mov    %esp,%ebp
80103d85:	56                   	push   %esi
80103d86:	53                   	push   %ebx
80103d87:	8b 75 08             	mov    0x8(%ebp),%esi
80103d8a:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d8d:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103d90:	39 f2                	cmp    %esi,%edx
80103d92:	73 34                	jae    80103dc8 <memmove+0x4a>
80103d94:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103d97:	39 f1                	cmp    %esi,%ecx
80103d99:	76 31                	jbe    80103dcc <memmove+0x4e>
    s += n;
    d += n;
80103d9b:	8d 14 06             	lea    (%esi,%eax,1),%edx
    while(n-- > 0)
80103d9e:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103da1:	85 c0                	test   %eax,%eax
80103da3:	74 1d                	je     80103dc2 <memmove+0x44>
      *--d = *--s;
80103da5:	49                   	dec    %ecx
80103da6:	4a                   	dec    %edx
80103da7:	8a 01                	mov    (%ecx),%al
80103da9:	88 02                	mov    %al,(%edx)
    while(n-- > 0)
80103dab:	89 d8                	mov    %ebx,%eax
80103dad:	eb ef                	jmp    80103d9e <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;
80103daf:	8a 02                	mov    (%edx),%al
80103db1:	88 01                	mov    %al,(%ecx)
80103db3:	8d 49 01             	lea    0x1(%ecx),%ecx
80103db6:	8d 52 01             	lea    0x1(%edx),%edx
    while(n-- > 0)
80103db9:	89 d8                	mov    %ebx,%eax
80103dbb:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103dbe:	85 c0                	test   %eax,%eax
80103dc0:	75 ed                	jne    80103daf <memmove+0x31>

  return dst;
}
80103dc2:	89 f0                	mov    %esi,%eax
80103dc4:	5b                   	pop    %ebx
80103dc5:	5e                   	pop    %esi
80103dc6:	5d                   	pop    %ebp
80103dc7:	c3                   	ret    
80103dc8:	89 f1                	mov    %esi,%ecx
80103dca:	eb ef                	jmp    80103dbb <memmove+0x3d>
80103dcc:	89 f1                	mov    %esi,%ecx
80103dce:	eb eb                	jmp    80103dbb <memmove+0x3d>

80103dd0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80103dd0:	f3 0f 1e fb          	endbr32 
80103dd4:	55                   	push   %ebp
80103dd5:	89 e5                	mov    %esp,%ebp
80103dd7:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80103dda:	ff 75 10             	pushl  0x10(%ebp)
80103ddd:	ff 75 0c             	pushl  0xc(%ebp)
80103de0:	ff 75 08             	pushl  0x8(%ebp)
80103de3:	e8 96 ff ff ff       	call   80103d7e <memmove>
}
80103de8:	c9                   	leave  
80103de9:	c3                   	ret    

80103dea <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80103dea:	f3 0f 1e fb          	endbr32 
80103dee:	55                   	push   %ebp
80103def:	89 e5                	mov    %esp,%ebp
80103df1:	53                   	push   %ebx
80103df2:	8b 55 08             	mov    0x8(%ebp),%edx
80103df5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103df8:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80103dfb:	eb 03                	jmp    80103e00 <strncmp+0x16>
    n--, p++, q++;
80103dfd:	48                   	dec    %eax
80103dfe:	42                   	inc    %edx
80103dff:	41                   	inc    %ecx
  while(n > 0 && *p && *p == *q)
80103e00:	85 c0                	test   %eax,%eax
80103e02:	74 0a                	je     80103e0e <strncmp+0x24>
80103e04:	8a 1a                	mov    (%edx),%bl
80103e06:	84 db                	test   %bl,%bl
80103e08:	74 04                	je     80103e0e <strncmp+0x24>
80103e0a:	3a 19                	cmp    (%ecx),%bl
80103e0c:	74 ef                	je     80103dfd <strncmp+0x13>
  if(n == 0)
80103e0e:	85 c0                	test   %eax,%eax
80103e10:	74 0b                	je     80103e1d <strncmp+0x33>
    return 0;
  return (uchar)*p - (uchar)*q;
80103e12:	0f b6 02             	movzbl (%edx),%eax
80103e15:	0f b6 11             	movzbl (%ecx),%edx
80103e18:	29 d0                	sub    %edx,%eax
}
80103e1a:	5b                   	pop    %ebx
80103e1b:	5d                   	pop    %ebp
80103e1c:	c3                   	ret    
    return 0;
80103e1d:	b8 00 00 00 00       	mov    $0x0,%eax
80103e22:	eb f6                	jmp    80103e1a <strncmp+0x30>

80103e24 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80103e24:	f3 0f 1e fb          	endbr32 
80103e28:	55                   	push   %ebp
80103e29:	89 e5                	mov    %esp,%ebp
80103e2b:	57                   	push   %edi
80103e2c:	56                   	push   %esi
80103e2d:	53                   	push   %ebx
80103e2e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103e34:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80103e37:	89 c1                	mov    %eax,%ecx
80103e39:	eb 04                	jmp    80103e3f <strncpy+0x1b>
80103e3b:	89 fb                	mov    %edi,%ebx
80103e3d:	89 f1                	mov    %esi,%ecx
80103e3f:	89 d6                	mov    %edx,%esi
80103e41:	4a                   	dec    %edx
80103e42:	85 f6                	test   %esi,%esi
80103e44:	7e 1a                	jle    80103e60 <strncpy+0x3c>
80103e46:	8d 7b 01             	lea    0x1(%ebx),%edi
80103e49:	8d 71 01             	lea    0x1(%ecx),%esi
80103e4c:	8a 1b                	mov    (%ebx),%bl
80103e4e:	88 19                	mov    %bl,(%ecx)
80103e50:	84 db                	test   %bl,%bl
80103e52:	75 e7                	jne    80103e3b <strncpy+0x17>
80103e54:	89 f1                	mov    %esi,%ecx
80103e56:	eb 08                	jmp    80103e60 <strncpy+0x3c>
    ;
  while(n-- > 0)
    *s++ = 0;
80103e58:	c6 01 00             	movb   $0x0,(%ecx)
  while(n-- > 0)
80103e5b:	89 da                	mov    %ebx,%edx
    *s++ = 0;
80103e5d:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
80103e60:	8d 5a ff             	lea    -0x1(%edx),%ebx
80103e63:	85 d2                	test   %edx,%edx
80103e65:	7f f1                	jg     80103e58 <strncpy+0x34>
  return os;
}
80103e67:	5b                   	pop    %ebx
80103e68:	5e                   	pop    %esi
80103e69:	5f                   	pop    %edi
80103e6a:	5d                   	pop    %ebp
80103e6b:	c3                   	ret    

80103e6c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80103e6c:	f3 0f 1e fb          	endbr32 
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	57                   	push   %edi
80103e74:	56                   	push   %esi
80103e75:	53                   	push   %ebx
80103e76:	8b 45 08             	mov    0x8(%ebp),%eax
80103e79:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103e7c:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80103e7f:	85 d2                	test   %edx,%edx
80103e81:	7e 20                	jle    80103ea3 <safestrcpy+0x37>
80103e83:	89 c1                	mov    %eax,%ecx
80103e85:	eb 04                	jmp    80103e8b <safestrcpy+0x1f>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80103e87:	89 fb                	mov    %edi,%ebx
80103e89:	89 f1                	mov    %esi,%ecx
80103e8b:	4a                   	dec    %edx
80103e8c:	85 d2                	test   %edx,%edx
80103e8e:	7e 10                	jle    80103ea0 <safestrcpy+0x34>
80103e90:	8d 7b 01             	lea    0x1(%ebx),%edi
80103e93:	8d 71 01             	lea    0x1(%ecx),%esi
80103e96:	8a 1b                	mov    (%ebx),%bl
80103e98:	88 19                	mov    %bl,(%ecx)
80103e9a:	84 db                	test   %bl,%bl
80103e9c:	75 e9                	jne    80103e87 <safestrcpy+0x1b>
80103e9e:	89 f1                	mov    %esi,%ecx
    ;
  *s = 0;
80103ea0:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80103ea3:	5b                   	pop    %ebx
80103ea4:	5e                   	pop    %esi
80103ea5:	5f                   	pop    %edi
80103ea6:	5d                   	pop    %ebp
80103ea7:	c3                   	ret    

80103ea8 <strlen>:

int
strlen(const char *s)
{
80103ea8:	f3 0f 1e fb          	endbr32 
80103eac:	55                   	push   %ebp
80103ead:	89 e5                	mov    %esp,%ebp
80103eaf:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80103eb2:	b8 00 00 00 00       	mov    $0x0,%eax
80103eb7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80103ebb:	74 03                	je     80103ec0 <strlen+0x18>
80103ebd:	40                   	inc    %eax
80103ebe:	eb f7                	jmp    80103eb7 <strlen+0xf>
    ;
  return n;
}
80103ec0:	5d                   	pop    %ebp
80103ec1:	c3                   	ret    

80103ec2 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80103ec2:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80103ec6:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80103eca:	55                   	push   %ebp
  pushl %ebx
80103ecb:	53                   	push   %ebx
  pushl %esi
80103ecc:	56                   	push   %esi
  pushl %edi
80103ecd:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80103ece:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80103ed0:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80103ed2:	5f                   	pop    %edi
  popl %esi
80103ed3:	5e                   	pop    %esi
  popl %ebx
80103ed4:	5b                   	pop    %ebx
  popl %ebp
80103ed5:	5d                   	pop    %ebp
  ret
80103ed6:	c3                   	ret    

80103ed7 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80103ed7:	f3 0f 1e fb          	endbr32 
80103edb:	55                   	push   %ebp
80103edc:	89 e5                	mov    %esp,%ebp
80103ede:	53                   	push   %ebx
80103edf:	83 ec 04             	sub    $0x4,%esp
80103ee2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80103ee5:	e8 67 f3 ff ff       	call   80103251 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80103eea:	8b 00                	mov    (%eax),%eax
80103eec:	39 d8                	cmp    %ebx,%eax
80103eee:	76 19                	jbe    80103f09 <fetchint+0x32>
80103ef0:	8d 53 04             	lea    0x4(%ebx),%edx
80103ef3:	39 d0                	cmp    %edx,%eax
80103ef5:	72 19                	jb     80103f10 <fetchint+0x39>
    return -1;
  *ip = *(int*)(addr);
80103ef7:	8b 13                	mov    (%ebx),%edx
80103ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
80103efc:	89 10                	mov    %edx,(%eax)
  return 0;
80103efe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103f03:	83 c4 04             	add    $0x4,%esp
80103f06:	5b                   	pop    %ebx
80103f07:	5d                   	pop    %ebp
80103f08:	c3                   	ret    
    return -1;
80103f09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f0e:	eb f3                	jmp    80103f03 <fetchint+0x2c>
80103f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f15:	eb ec                	jmp    80103f03 <fetchint+0x2c>

80103f17 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80103f17:	f3 0f 1e fb          	endbr32 
80103f1b:	55                   	push   %ebp
80103f1c:	89 e5                	mov    %esp,%ebp
80103f1e:	53                   	push   %ebx
80103f1f:	83 ec 04             	sub    $0x4,%esp
80103f22:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80103f25:	e8 27 f3 ff ff       	call   80103251 <myproc>

  if(addr >= curproc->sz)
80103f2a:	39 18                	cmp    %ebx,(%eax)
80103f2c:	76 24                	jbe    80103f52 <fetchstr+0x3b>
    return -1;
  *pp = (char*)addr;
80103f2e:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f31:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80103f33:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80103f35:	89 d8                	mov    %ebx,%eax
80103f37:	39 d0                	cmp    %edx,%eax
80103f39:	73 0c                	jae    80103f47 <fetchstr+0x30>
    if(*s == 0)
80103f3b:	80 38 00             	cmpb   $0x0,(%eax)
80103f3e:	74 03                	je     80103f43 <fetchstr+0x2c>
  for(s = *pp; s < ep; s++){
80103f40:	40                   	inc    %eax
80103f41:	eb f4                	jmp    80103f37 <fetchstr+0x20>
      return s - *pp;
80103f43:	29 d8                	sub    %ebx,%eax
80103f45:	eb 05                	jmp    80103f4c <fetchstr+0x35>
  }
  return -1;
80103f47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f4c:	83 c4 04             	add    $0x4,%esp
80103f4f:	5b                   	pop    %ebx
80103f50:	5d                   	pop    %ebp
80103f51:	c3                   	ret    
    return -1;
80103f52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f57:	eb f3                	jmp    80103f4c <fetchstr+0x35>

80103f59 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80103f59:	f3 0f 1e fb          	endbr32 
80103f5d:	55                   	push   %ebp
80103f5e:	89 e5                	mov    %esp,%ebp
80103f60:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80103f63:	e8 e9 f2 ff ff       	call   80103251 <myproc>
80103f68:	8b 50 18             	mov    0x18(%eax),%edx
80103f6b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f6e:	c1 e0 02             	shl    $0x2,%eax
80103f71:	03 42 44             	add    0x44(%edx),%eax
80103f74:	83 ec 08             	sub    $0x8,%esp
80103f77:	ff 75 0c             	pushl  0xc(%ebp)
80103f7a:	83 c0 04             	add    $0x4,%eax
80103f7d:	50                   	push   %eax
80103f7e:	e8 54 ff ff ff       	call   80103ed7 <fetchint>
}
80103f83:	c9                   	leave  
80103f84:	c3                   	ret    

80103f85 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, void **pp, int size)
{
80103f85:	f3 0f 1e fb          	endbr32 
80103f89:	55                   	push   %ebp
80103f8a:	89 e5                	mov    %esp,%ebp
80103f8c:	56                   	push   %esi
80103f8d:	53                   	push   %ebx
80103f8e:	83 ec 10             	sub    $0x10,%esp
80103f91:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80103f94:	e8 b8 f2 ff ff       	call   80103251 <myproc>
80103f99:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80103f9b:	83 ec 08             	sub    $0x8,%esp
80103f9e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80103fa1:	50                   	push   %eax
80103fa2:	ff 75 08             	pushl  0x8(%ebp)
80103fa5:	e8 af ff ff ff       	call   80103f59 <argint>
80103faa:	83 c4 10             	add    $0x10,%esp
80103fad:	85 c0                	test   %eax,%eax
80103faf:	78 24                	js     80103fd5 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80103fb1:	85 db                	test   %ebx,%ebx
80103fb3:	78 27                	js     80103fdc <argptr+0x57>
80103fb5:	8b 16                	mov    (%esi),%edx
80103fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fba:	39 c2                	cmp    %eax,%edx
80103fbc:	76 25                	jbe    80103fe3 <argptr+0x5e>
80103fbe:	01 c3                	add    %eax,%ebx
80103fc0:	39 da                	cmp    %ebx,%edx
80103fc2:	72 26                	jb     80103fea <argptr+0x65>
    return -1;
  *pp = (void*)i;
80103fc4:	8b 55 0c             	mov    0xc(%ebp),%edx
80103fc7:	89 02                	mov    %eax,(%edx)
  return 0;
80103fc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103fce:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fd1:	5b                   	pop    %ebx
80103fd2:	5e                   	pop    %esi
80103fd3:	5d                   	pop    %ebp
80103fd4:	c3                   	ret    
    return -1;
80103fd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fda:	eb f2                	jmp    80103fce <argptr+0x49>
    return -1;
80103fdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fe1:	eb eb                	jmp    80103fce <argptr+0x49>
80103fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fe8:	eb e4                	jmp    80103fce <argptr+0x49>
80103fea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fef:	eb dd                	jmp    80103fce <argptr+0x49>

80103ff1 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80103ff1:	f3 0f 1e fb          	endbr32 
80103ff5:	55                   	push   %ebp
80103ff6:	89 e5                	mov    %esp,%ebp
80103ff8:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80103ffb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80103ffe:	50                   	push   %eax
80103fff:	ff 75 08             	pushl  0x8(%ebp)
80104002:	e8 52 ff ff ff       	call   80103f59 <argint>
80104007:	83 c4 10             	add    $0x10,%esp
8010400a:	85 c0                	test   %eax,%eax
8010400c:	78 13                	js     80104021 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010400e:	83 ec 08             	sub    $0x8,%esp
80104011:	ff 75 0c             	pushl  0xc(%ebp)
80104014:	ff 75 f4             	pushl  -0xc(%ebp)
80104017:	e8 fb fe ff ff       	call   80103f17 <fetchstr>
8010401c:	83 c4 10             	add    $0x10,%esp
}
8010401f:	c9                   	leave  
80104020:	c3                   	ret    
    return -1;
80104021:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104026:	eb f7                	jmp    8010401f <argstr+0x2e>

80104028 <syscall>:
[SYS_dup2]    sys_dup2,
};

void
syscall(void)
{
80104028:	f3 0f 1e fb          	endbr32 
8010402c:	55                   	push   %ebp
8010402d:	89 e5                	mov    %esp,%ebp
8010402f:	53                   	push   %ebx
80104030:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104033:	e8 19 f2 ff ff       	call   80103251 <myproc>
80104038:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010403a:	8b 40 18             	mov    0x18(%eax),%eax
8010403d:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104040:	8d 50 ff             	lea    -0x1(%eax),%edx
80104043:	83 fa 16             	cmp    $0x16,%edx
80104046:	77 17                	ja     8010405f <syscall+0x37>
80104048:	8b 14 85 00 6d 10 80 	mov    -0x7fef9300(,%eax,4),%edx
8010404f:	85 d2                	test   %edx,%edx
80104051:	74 0c                	je     8010405f <syscall+0x37>
    curproc->tf->eax = syscalls[num]();
80104053:	ff d2                	call   *%edx
80104055:	89 c2                	mov    %eax,%edx
80104057:	8b 43 18             	mov    0x18(%ebx),%eax
8010405a:	89 50 1c             	mov    %edx,0x1c(%eax)
8010405d:	eb 1f                	jmp    8010407e <syscall+0x56>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
8010405f:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
80104062:	50                   	push   %eax
80104063:	52                   	push   %edx
80104064:	ff 73 10             	pushl  0x10(%ebx)
80104067:	68 dd 6c 10 80       	push   $0x80106cdd
8010406c:	e8 8c c5 ff ff       	call   801005fd <cprintf>
    curproc->tf->eax = -1;
80104071:	8b 43 18             	mov    0x18(%ebx),%eax
80104074:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
8010407b:	83 c4 10             	add    $0x10,%esp
  }
}
8010407e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104081:	c9                   	leave  
80104082:	c3                   	ret    

80104083 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80104083:	55                   	push   %ebp
80104084:	89 e5                	mov    %esp,%ebp
80104086:	56                   	push   %esi
80104087:	53                   	push   %ebx
80104088:	83 ec 18             	sub    $0x18,%esp
8010408b:	89 d6                	mov    %edx,%esi
8010408d:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010408f:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104092:	52                   	push   %edx
80104093:	50                   	push   %eax
80104094:	e8 c0 fe ff ff       	call   80103f59 <argint>
80104099:	83 c4 10             	add    $0x10,%esp
8010409c:	85 c0                	test   %eax,%eax
8010409e:	78 35                	js     801040d5 <argfd+0x52>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801040a0:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801040a4:	77 28                	ja     801040ce <argfd+0x4b>
801040a6:	e8 a6 f1 ff ff       	call   80103251 <myproc>
801040ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040ae:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801040b2:	85 c0                	test   %eax,%eax
801040b4:	74 18                	je     801040ce <argfd+0x4b>
    return -1;
  if(pfd)
801040b6:	85 f6                	test   %esi,%esi
801040b8:	74 02                	je     801040bc <argfd+0x39>
    *pfd = fd;
801040ba:	89 16                	mov    %edx,(%esi)
  if(pf)
801040bc:	85 db                	test   %ebx,%ebx
801040be:	74 1c                	je     801040dc <argfd+0x59>
    *pf = f;
801040c0:	89 03                	mov    %eax,(%ebx)
  return 0;
801040c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801040c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040ca:	5b                   	pop    %ebx
801040cb:	5e                   	pop    %esi
801040cc:	5d                   	pop    %ebp
801040cd:	c3                   	ret    
    return -1;
801040ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040d3:	eb f2                	jmp    801040c7 <argfd+0x44>
    return -1;
801040d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040da:	eb eb                	jmp    801040c7 <argfd+0x44>
  return 0;
801040dc:	b8 00 00 00 00       	mov    $0x0,%eax
801040e1:	eb e4                	jmp    801040c7 <argfd+0x44>

801040e3 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801040e3:	55                   	push   %ebp
801040e4:	89 e5                	mov    %esp,%ebp
801040e6:	53                   	push   %ebx
801040e7:	83 ec 04             	sub    $0x4,%esp
801040ea:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
801040ec:	e8 60 f1 ff ff       	call   80103251 <myproc>
801040f1:	89 c2                	mov    %eax,%edx

  for(fd = 0; fd < NOFILE; fd++){
801040f3:	b8 00 00 00 00       	mov    $0x0,%eax
801040f8:	83 f8 0f             	cmp    $0xf,%eax
801040fb:	7f 10                	jg     8010410d <fdalloc+0x2a>
    if(curproc->ofile[fd] == 0){
801040fd:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
80104102:	74 03                	je     80104107 <fdalloc+0x24>
  for(fd = 0; fd < NOFILE; fd++){
80104104:	40                   	inc    %eax
80104105:	eb f1                	jmp    801040f8 <fdalloc+0x15>
      curproc->ofile[fd] = f;
80104107:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
8010410b:	eb 05                	jmp    80104112 <fdalloc+0x2f>
    }
  }
  return -1;
8010410d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104112:	83 c4 04             	add    $0x4,%esp
80104115:	5b                   	pop    %ebx
80104116:	5d                   	pop    %ebp
80104117:	c3                   	ret    

80104118 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80104118:	55                   	push   %ebp
80104119:	89 e5                	mov    %esp,%ebp
8010411b:	56                   	push   %esi
8010411c:	53                   	push   %ebx
8010411d:	83 ec 10             	sub    $0x10,%esp
80104120:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104122:	b8 20 00 00 00       	mov    $0x20,%eax
80104127:	89 c6                	mov    %eax,%esi
80104129:	39 43 58             	cmp    %eax,0x58(%ebx)
8010412c:	76 2e                	jbe    8010415c <isdirempty+0x44>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010412e:	6a 10                	push   $0x10
80104130:	50                   	push   %eax
80104131:	8d 45 e8             	lea    -0x18(%ebp),%eax
80104134:	50                   	push   %eax
80104135:	53                   	push   %ebx
80104136:	e8 4c d6 ff ff       	call   80101787 <readi>
8010413b:	83 c4 10             	add    $0x10,%esp
8010413e:	83 f8 10             	cmp    $0x10,%eax
80104141:	75 0c                	jne    8010414f <isdirempty+0x37>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104143:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
80104148:	75 1e                	jne    80104168 <isdirempty+0x50>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010414a:	8d 46 10             	lea    0x10(%esi),%eax
8010414d:	eb d8                	jmp    80104127 <isdirempty+0xf>
      panic("isdirempty: readi");
8010414f:	83 ec 0c             	sub    $0xc,%esp
80104152:	68 60 6d 10 80       	push   $0x80106d60
80104157:	e8 f9 c1 ff ff       	call   80100355 <panic>
      return 0;
  }
  return 1;
8010415c:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104161:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104164:	5b                   	pop    %ebx
80104165:	5e                   	pop    %esi
80104166:	5d                   	pop    %ebp
80104167:	c3                   	ret    
      return 0;
80104168:	b8 00 00 00 00       	mov    $0x0,%eax
8010416d:	eb f2                	jmp    80104161 <isdirempty+0x49>

8010416f <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
8010416f:	55                   	push   %ebp
80104170:	89 e5                	mov    %esp,%ebp
80104172:	57                   	push   %edi
80104173:	56                   	push   %esi
80104174:	53                   	push   %ebx
80104175:	83 ec 44             	sub    $0x44,%esp
80104178:	89 d7                	mov    %edx,%edi
8010417a:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
8010417d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104180:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104183:	8d 55 d6             	lea    -0x2a(%ebp),%edx
80104186:	52                   	push   %edx
80104187:	50                   	push   %eax
80104188:	e8 a1 da ff ff       	call   80101c2e <nameiparent>
8010418d:	89 c6                	mov    %eax,%esi
8010418f:	83 c4 10             	add    $0x10,%esp
80104192:	85 c0                	test   %eax,%eax
80104194:	0f 84 32 01 00 00    	je     801042cc <create+0x15d>
    return 0;
  ilock(dp);
8010419a:	83 ec 0c             	sub    $0xc,%esp
8010419d:	50                   	push   %eax
8010419e:	e8 e3 d3 ff ff       	call   80101586 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801041a3:	83 c4 0c             	add    $0xc,%esp
801041a6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801041a9:	50                   	push   %eax
801041aa:	8d 45 d6             	lea    -0x2a(%ebp),%eax
801041ad:	50                   	push   %eax
801041ae:	56                   	push   %esi
801041af:	e8 28 d8 ff ff       	call   801019dc <dirlookup>
801041b4:	89 c3                	mov    %eax,%ebx
801041b6:	83 c4 10             	add    $0x10,%esp
801041b9:	85 c0                	test   %eax,%eax
801041bb:	74 3c                	je     801041f9 <create+0x8a>
    iunlockput(dp);
801041bd:	83 ec 0c             	sub    $0xc,%esp
801041c0:	56                   	push   %esi
801041c1:	e8 6f d5 ff ff       	call   80101735 <iunlockput>
    ilock(ip);
801041c6:	89 1c 24             	mov    %ebx,(%esp)
801041c9:	e8 b8 d3 ff ff       	call   80101586 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801041ce:	83 c4 10             	add    $0x10,%esp
801041d1:	66 83 ff 02          	cmp    $0x2,%di
801041d5:	75 07                	jne    801041de <create+0x6f>
801041d7:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
801041dc:	74 11                	je     801041ef <create+0x80>
      return ip;
    iunlockput(ip);
801041de:	83 ec 0c             	sub    $0xc,%esp
801041e1:	53                   	push   %ebx
801041e2:	e8 4e d5 ff ff       	call   80101735 <iunlockput>
    return 0;
801041e7:	83 c4 10             	add    $0x10,%esp
801041ea:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801041ef:	89 d8                	mov    %ebx,%eax
801041f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041f4:	5b                   	pop    %ebx
801041f5:	5e                   	pop    %esi
801041f6:	5f                   	pop    %edi
801041f7:	5d                   	pop    %ebp
801041f8:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
801041f9:	83 ec 08             	sub    $0x8,%esp
801041fc:	0f bf c7             	movswl %di,%eax
801041ff:	50                   	push   %eax
80104200:	ff 36                	pushl  (%esi)
80104202:	e8 7b d1 ff ff       	call   80101382 <ialloc>
80104207:	89 c3                	mov    %eax,%ebx
80104209:	83 c4 10             	add    $0x10,%esp
8010420c:	85 c0                	test   %eax,%eax
8010420e:	74 53                	je     80104263 <create+0xf4>
  ilock(ip);
80104210:	83 ec 0c             	sub    $0xc,%esp
80104213:	50                   	push   %eax
80104214:	e8 6d d3 ff ff       	call   80101586 <ilock>
  ip->major = major;
80104219:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010421c:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104220:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104223:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104227:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
8010422d:	89 1c 24             	mov    %ebx,(%esp)
80104230:	e8 f0 d1 ff ff       	call   80101425 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104235:	83 c4 10             	add    $0x10,%esp
80104238:	66 83 ff 01          	cmp    $0x1,%di
8010423c:	74 32                	je     80104270 <create+0x101>
  if(dirlink(dp, name, ip->inum) < 0)
8010423e:	83 ec 04             	sub    $0x4,%esp
80104241:	ff 73 04             	pushl  0x4(%ebx)
80104244:	8d 45 d6             	lea    -0x2a(%ebp),%eax
80104247:	50                   	push   %eax
80104248:	56                   	push   %esi
80104249:	e8 0f d9 ff ff       	call   80101b5d <dirlink>
8010424e:	83 c4 10             	add    $0x10,%esp
80104251:	85 c0                	test   %eax,%eax
80104253:	78 6a                	js     801042bf <create+0x150>
  iunlockput(dp);
80104255:	83 ec 0c             	sub    $0xc,%esp
80104258:	56                   	push   %esi
80104259:	e8 d7 d4 ff ff       	call   80101735 <iunlockput>
  return ip;
8010425e:	83 c4 10             	add    $0x10,%esp
80104261:	eb 8c                	jmp    801041ef <create+0x80>
    panic("create: ialloc");
80104263:	83 ec 0c             	sub    $0xc,%esp
80104266:	68 72 6d 10 80       	push   $0x80106d72
8010426b:	e8 e5 c0 ff ff       	call   80100355 <panic>
    dp->nlink++;  // for ".."
80104270:	66 8b 46 56          	mov    0x56(%esi),%ax
80104274:	40                   	inc    %eax
80104275:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
80104279:	83 ec 0c             	sub    $0xc,%esp
8010427c:	56                   	push   %esi
8010427d:	e8 a3 d1 ff ff       	call   80101425 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104282:	83 c4 0c             	add    $0xc,%esp
80104285:	ff 73 04             	pushl  0x4(%ebx)
80104288:	68 82 6d 10 80       	push   $0x80106d82
8010428d:	53                   	push   %ebx
8010428e:	e8 ca d8 ff ff       	call   80101b5d <dirlink>
80104293:	83 c4 10             	add    $0x10,%esp
80104296:	85 c0                	test   %eax,%eax
80104298:	78 18                	js     801042b2 <create+0x143>
8010429a:	83 ec 04             	sub    $0x4,%esp
8010429d:	ff 76 04             	pushl  0x4(%esi)
801042a0:	68 81 6d 10 80       	push   $0x80106d81
801042a5:	53                   	push   %ebx
801042a6:	e8 b2 d8 ff ff       	call   80101b5d <dirlink>
801042ab:	83 c4 10             	add    $0x10,%esp
801042ae:	85 c0                	test   %eax,%eax
801042b0:	79 8c                	jns    8010423e <create+0xcf>
      panic("create dots");
801042b2:	83 ec 0c             	sub    $0xc,%esp
801042b5:	68 84 6d 10 80       	push   $0x80106d84
801042ba:	e8 96 c0 ff ff       	call   80100355 <panic>
    panic("create: dirlink");
801042bf:	83 ec 0c             	sub    $0xc,%esp
801042c2:	68 90 6d 10 80       	push   $0x80106d90
801042c7:	e8 89 c0 ff ff       	call   80100355 <panic>
    return 0;
801042cc:	89 c3                	mov    %eax,%ebx
801042ce:	e9 1c ff ff ff       	jmp    801041ef <create+0x80>

801042d3 <sys_dup>:
{
801042d3:	f3 0f 1e fb          	endbr32 
801042d7:	55                   	push   %ebp
801042d8:	89 e5                	mov    %esp,%ebp
801042da:	53                   	push   %ebx
801042db:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
801042de:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801042e1:	ba 00 00 00 00       	mov    $0x0,%edx
801042e6:	b8 00 00 00 00       	mov    $0x0,%eax
801042eb:	e8 93 fd ff ff       	call   80104083 <argfd>
801042f0:	85 c0                	test   %eax,%eax
801042f2:	78 23                	js     80104317 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
801042f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f7:	e8 e7 fd ff ff       	call   801040e3 <fdalloc>
801042fc:	89 c3                	mov    %eax,%ebx
801042fe:	85 c0                	test   %eax,%eax
80104300:	78 1c                	js     8010431e <sys_dup+0x4b>
  filedup(f);
80104302:	83 ec 0c             	sub    $0xc,%esp
80104305:	ff 75 f4             	pushl  -0xc(%ebp)
80104308:	e8 79 c9 ff ff       	call   80100c86 <filedup>
  return fd;
8010430d:	83 c4 10             	add    $0x10,%esp
}
80104310:	89 d8                	mov    %ebx,%eax
80104312:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104315:	c9                   	leave  
80104316:	c3                   	ret    
    return -1;
80104317:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010431c:	eb f2                	jmp    80104310 <sys_dup+0x3d>
    return -1;
8010431e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104323:	eb eb                	jmp    80104310 <sys_dup+0x3d>

80104325 <sys_dup2>:
sys_dup2(void){
80104325:	f3 0f 1e fb          	endbr32 
80104329:	55                   	push   %ebp
8010432a:	89 e5                	mov    %esp,%ebp
8010432c:	53                   	push   %ebx
8010432d:	83 ec 14             	sub    $0x14,%esp
  struct proc *curproc = myproc(); 
80104330:	e8 1c ef ff ff       	call   80103251 <myproc>
80104335:	89 c3                	mov    %eax,%ebx
  if(argfd(0, &oldfd, &oldf) < 0) // Obtenemos el descriptor de fichero y el fichero (file *) a partir del argumento 0.
80104337:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010433a:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010433d:	b8 00 00 00 00       	mov    $0x0,%eax
80104342:	e8 3c fd ff ff       	call   80104083 <argfd>
80104347:	85 c0                	test   %eax,%eax
80104349:	78 5f                	js     801043aa <sys_dup2+0x85>
  if(argint(1, &newfd)<0) // Obtenemos el nuevo descriptor de fichero a partir del argumento 1.
8010434b:	83 ec 08             	sub    $0x8,%esp
8010434e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104351:	50                   	push   %eax
80104352:	6a 01                	push   $0x1
80104354:	e8 00 fc ff ff       	call   80103f59 <argint>
80104359:	83 c4 10             	add    $0x10,%esp
8010435c:	85 c0                	test   %eax,%eax
8010435e:	78 51                	js     801043b1 <sys_dup2+0x8c>
  if(oldfd == newfd) // Si los descriptores de fichero son iguales, no es necesario duplicar.
80104360:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104363:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104366:	39 c2                	cmp    %eax,%edx
80104368:	74 3b                	je     801043a5 <sys_dup2+0x80>
  if(oldfd < 0 || oldfd >= NOFILE || newfd < 0 || newfd >= NOFILE) // Comprobamos que los descriptores de fichero están dentro de los límites válidos.
8010436a:	83 fa 0f             	cmp    $0xf,%edx
8010436d:	77 49                	ja     801043b8 <sys_dup2+0x93>
8010436f:	85 c0                	test   %eax,%eax
80104371:	78 4c                	js     801043bf <sys_dup2+0x9a>
80104373:	83 f8 0f             	cmp    $0xf,%eax
80104376:	7f 4e                	jg     801043c6 <sys_dup2+0xa1>
  newf=curproc->ofile[newfd]; // Obtenemos el fichero (file *) correspondiente al nuevo descriptor.
80104378:	8b 44 83 28          	mov    0x28(%ebx,%eax,4),%eax
  if(newf!=NULL) //Si el nuevo descriptor de fichero está en uso, cierra el fichero.
8010437c:	85 c0                	test   %eax,%eax
8010437e:	74 0c                	je     8010438c <sys_dup2+0x67>
    fileclose(newf);
80104380:	83 ec 0c             	sub    $0xc,%esp
80104383:	50                   	push   %eax
80104384:	e8 44 c9 ff ff       	call   80100ccd <fileclose>
80104389:	83 c4 10             	add    $0x10,%esp
  curproc->ofile[newfd] = oldf; // Asignamos el fichero del descriptor antiguo al nuevo descriptor.
8010438c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010438f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104392:	89 44 93 28          	mov    %eax,0x28(%ebx,%edx,4)
  filedup(oldf); // Incrementa el contador de referencias del fichero.
80104396:	83 ec 0c             	sub    $0xc,%esp
80104399:	50                   	push   %eax
8010439a:	e8 e7 c8 ff ff       	call   80100c86 <filedup>
  return newfd;
8010439f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801043a2:	83 c4 10             	add    $0x10,%esp
}
801043a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043a8:	c9                   	leave  
801043a9:	c3                   	ret    
    return -1;
801043aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043af:	eb f4                	jmp    801043a5 <sys_dup2+0x80>
    return -1;
801043b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043b6:	eb ed                	jmp    801043a5 <sys_dup2+0x80>
    return -1;
801043b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043bd:	eb e6                	jmp    801043a5 <sys_dup2+0x80>
801043bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043c4:	eb df                	jmp    801043a5 <sys_dup2+0x80>
801043c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043cb:	eb d8                	jmp    801043a5 <sys_dup2+0x80>

801043cd <sys_read>:
{
801043cd:	f3 0f 1e fb          	endbr32 
801043d1:	55                   	push   %ebp
801043d2:	89 e5                	mov    %esp,%ebp
801043d4:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void**)&p, n) < 0)
801043d7:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801043da:	ba 00 00 00 00       	mov    $0x0,%edx
801043df:	b8 00 00 00 00       	mov    $0x0,%eax
801043e4:	e8 9a fc ff ff       	call   80104083 <argfd>
801043e9:	85 c0                	test   %eax,%eax
801043eb:	78 43                	js     80104430 <sys_read+0x63>
801043ed:	83 ec 08             	sub    $0x8,%esp
801043f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801043f3:	50                   	push   %eax
801043f4:	6a 02                	push   $0x2
801043f6:	e8 5e fb ff ff       	call   80103f59 <argint>
801043fb:	83 c4 10             	add    $0x10,%esp
801043fe:	85 c0                	test   %eax,%eax
80104400:	78 2e                	js     80104430 <sys_read+0x63>
80104402:	83 ec 04             	sub    $0x4,%esp
80104405:	ff 75 f0             	pushl  -0x10(%ebp)
80104408:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010440b:	50                   	push   %eax
8010440c:	6a 01                	push   $0x1
8010440e:	e8 72 fb ff ff       	call   80103f85 <argptr>
80104413:	83 c4 10             	add    $0x10,%esp
80104416:	85 c0                	test   %eax,%eax
80104418:	78 16                	js     80104430 <sys_read+0x63>
  return fileread(f, p, n);
8010441a:	83 ec 04             	sub    $0x4,%esp
8010441d:	ff 75 f0             	pushl  -0x10(%ebp)
80104420:	ff 75 ec             	pushl  -0x14(%ebp)
80104423:	ff 75 f4             	pushl  -0xc(%ebp)
80104426:	e8 a3 c9 ff ff       	call   80100dce <fileread>
8010442b:	83 c4 10             	add    $0x10,%esp
}
8010442e:	c9                   	leave  
8010442f:	c3                   	ret    
    return -1;
80104430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104435:	eb f7                	jmp    8010442e <sys_read+0x61>

80104437 <sys_write>:
{
80104437:	f3 0f 1e fb          	endbr32 
8010443b:	55                   	push   %ebp
8010443c:	89 e5                	mov    %esp,%ebp
8010443e:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, (void**)&p, n) < 0)
80104441:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104444:	ba 00 00 00 00       	mov    $0x0,%edx
80104449:	b8 00 00 00 00       	mov    $0x0,%eax
8010444e:	e8 30 fc ff ff       	call   80104083 <argfd>
80104453:	85 c0                	test   %eax,%eax
80104455:	78 43                	js     8010449a <sys_write+0x63>
80104457:	83 ec 08             	sub    $0x8,%esp
8010445a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010445d:	50                   	push   %eax
8010445e:	6a 02                	push   $0x2
80104460:	e8 f4 fa ff ff       	call   80103f59 <argint>
80104465:	83 c4 10             	add    $0x10,%esp
80104468:	85 c0                	test   %eax,%eax
8010446a:	78 2e                	js     8010449a <sys_write+0x63>
8010446c:	83 ec 04             	sub    $0x4,%esp
8010446f:	ff 75 f0             	pushl  -0x10(%ebp)
80104472:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104475:	50                   	push   %eax
80104476:	6a 01                	push   $0x1
80104478:	e8 08 fb ff ff       	call   80103f85 <argptr>
8010447d:	83 c4 10             	add    $0x10,%esp
80104480:	85 c0                	test   %eax,%eax
80104482:	78 16                	js     8010449a <sys_write+0x63>
  return filewrite(f, p, n);
80104484:	83 ec 04             	sub    $0x4,%esp
80104487:	ff 75 f0             	pushl  -0x10(%ebp)
8010448a:	ff 75 ec             	pushl  -0x14(%ebp)
8010448d:	ff 75 f4             	pushl  -0xc(%ebp)
80104490:	e8 c2 c9 ff ff       	call   80100e57 <filewrite>
80104495:	83 c4 10             	add    $0x10,%esp
}
80104498:	c9                   	leave  
80104499:	c3                   	ret    
    return -1;
8010449a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010449f:	eb f7                	jmp    80104498 <sys_write+0x61>

801044a1 <sys_close>:
{
801044a1:	f3 0f 1e fb          	endbr32 
801044a5:	55                   	push   %ebp
801044a6:	89 e5                	mov    %esp,%ebp
801044a8:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801044ab:	8d 4d f0             	lea    -0x10(%ebp),%ecx
801044ae:	8d 55 f4             	lea    -0xc(%ebp),%edx
801044b1:	b8 00 00 00 00       	mov    $0x0,%eax
801044b6:	e8 c8 fb ff ff       	call   80104083 <argfd>
801044bb:	85 c0                	test   %eax,%eax
801044bd:	78 25                	js     801044e4 <sys_close+0x43>
  myproc()->ofile[fd] = 0;
801044bf:	e8 8d ed ff ff       	call   80103251 <myproc>
801044c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044c7:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801044ce:	00 
  fileclose(f);
801044cf:	83 ec 0c             	sub    $0xc,%esp
801044d2:	ff 75 f0             	pushl  -0x10(%ebp)
801044d5:	e8 f3 c7 ff ff       	call   80100ccd <fileclose>
  return 0;
801044da:	83 c4 10             	add    $0x10,%esp
801044dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
801044e2:	c9                   	leave  
801044e3:	c3                   	ret    
    return -1;
801044e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044e9:	eb f7                	jmp    801044e2 <sys_close+0x41>

801044eb <sys_fstat>:
{
801044eb:	f3 0f 1e fb          	endbr32 
801044ef:	55                   	push   %ebp
801044f0:	89 e5                	mov    %esp,%ebp
801044f2:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801044f5:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801044f8:	ba 00 00 00 00       	mov    $0x0,%edx
801044fd:	b8 00 00 00 00       	mov    $0x0,%eax
80104502:	e8 7c fb ff ff       	call   80104083 <argfd>
80104507:	85 c0                	test   %eax,%eax
80104509:	78 2a                	js     80104535 <sys_fstat+0x4a>
8010450b:	83 ec 04             	sub    $0x4,%esp
8010450e:	6a 14                	push   $0x14
80104510:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104513:	50                   	push   %eax
80104514:	6a 01                	push   $0x1
80104516:	e8 6a fa ff ff       	call   80103f85 <argptr>
8010451b:	83 c4 10             	add    $0x10,%esp
8010451e:	85 c0                	test   %eax,%eax
80104520:	78 13                	js     80104535 <sys_fstat+0x4a>
  return filestat(f, st);
80104522:	83 ec 08             	sub    $0x8,%esp
80104525:	ff 75 f0             	pushl  -0x10(%ebp)
80104528:	ff 75 f4             	pushl  -0xc(%ebp)
8010452b:	e8 53 c8 ff ff       	call   80100d83 <filestat>
80104530:	83 c4 10             	add    $0x10,%esp
}
80104533:	c9                   	leave  
80104534:	c3                   	ret    
    return -1;
80104535:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010453a:	eb f7                	jmp    80104533 <sys_fstat+0x48>

8010453c <sys_link>:
{
8010453c:	f3 0f 1e fb          	endbr32 
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	56                   	push   %esi
80104544:	53                   	push   %ebx
80104545:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104548:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010454b:	50                   	push   %eax
8010454c:	6a 00                	push   $0x0
8010454e:	e8 9e fa ff ff       	call   80103ff1 <argstr>
80104553:	83 c4 10             	add    $0x10,%esp
80104556:	85 c0                	test   %eax,%eax
80104558:	0f 88 d1 00 00 00    	js     8010462f <sys_link+0xf3>
8010455e:	83 ec 08             	sub    $0x8,%esp
80104561:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104564:	50                   	push   %eax
80104565:	6a 01                	push   $0x1
80104567:	e8 85 fa ff ff       	call   80103ff1 <argstr>
8010456c:	83 c4 10             	add    $0x10,%esp
8010456f:	85 c0                	test   %eax,%eax
80104571:	0f 88 b8 00 00 00    	js     8010462f <sys_link+0xf3>
  begin_op();
80104577:	e8 57 e2 ff ff       	call   801027d3 <begin_op>
  if((ip = namei(old)) == 0){
8010457c:	83 ec 0c             	sub    $0xc,%esp
8010457f:	ff 75 e0             	pushl  -0x20(%ebp)
80104582:	e8 8b d6 ff ff       	call   80101c12 <namei>
80104587:	89 c3                	mov    %eax,%ebx
80104589:	83 c4 10             	add    $0x10,%esp
8010458c:	85 c0                	test   %eax,%eax
8010458e:	0f 84 a2 00 00 00    	je     80104636 <sys_link+0xfa>
  ilock(ip);
80104594:	83 ec 0c             	sub    $0xc,%esp
80104597:	50                   	push   %eax
80104598:	e8 e9 cf ff ff       	call   80101586 <ilock>
  if(ip->type == T_DIR){
8010459d:	83 c4 10             	add    $0x10,%esp
801045a0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801045a5:	0f 84 97 00 00 00    	je     80104642 <sys_link+0x106>
  ip->nlink++;
801045ab:	66 8b 43 56          	mov    0x56(%ebx),%ax
801045af:	40                   	inc    %eax
801045b0:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801045b4:	83 ec 0c             	sub    $0xc,%esp
801045b7:	53                   	push   %ebx
801045b8:	e8 68 ce ff ff       	call   80101425 <iupdate>
  iunlock(ip);
801045bd:	89 1c 24             	mov    %ebx,(%esp)
801045c0:	e8 85 d0 ff ff       	call   8010164a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801045c5:	83 c4 08             	add    $0x8,%esp
801045c8:	8d 45 ea             	lea    -0x16(%ebp),%eax
801045cb:	50                   	push   %eax
801045cc:	ff 75 e4             	pushl  -0x1c(%ebp)
801045cf:	e8 5a d6 ff ff       	call   80101c2e <nameiparent>
801045d4:	89 c6                	mov    %eax,%esi
801045d6:	83 c4 10             	add    $0x10,%esp
801045d9:	85 c0                	test   %eax,%eax
801045db:	0f 84 85 00 00 00    	je     80104666 <sys_link+0x12a>
  ilock(dp);
801045e1:	83 ec 0c             	sub    $0xc,%esp
801045e4:	50                   	push   %eax
801045e5:	e8 9c cf ff ff       	call   80101586 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801045ea:	83 c4 10             	add    $0x10,%esp
801045ed:	8b 03                	mov    (%ebx),%eax
801045ef:	39 06                	cmp    %eax,(%esi)
801045f1:	75 67                	jne    8010465a <sys_link+0x11e>
801045f3:	83 ec 04             	sub    $0x4,%esp
801045f6:	ff 73 04             	pushl  0x4(%ebx)
801045f9:	8d 45 ea             	lea    -0x16(%ebp),%eax
801045fc:	50                   	push   %eax
801045fd:	56                   	push   %esi
801045fe:	e8 5a d5 ff ff       	call   80101b5d <dirlink>
80104603:	83 c4 10             	add    $0x10,%esp
80104606:	85 c0                	test   %eax,%eax
80104608:	78 50                	js     8010465a <sys_link+0x11e>
  iunlockput(dp);
8010460a:	83 ec 0c             	sub    $0xc,%esp
8010460d:	56                   	push   %esi
8010460e:	e8 22 d1 ff ff       	call   80101735 <iunlockput>
  iput(ip);
80104613:	89 1c 24             	mov    %ebx,(%esp)
80104616:	e8 78 d0 ff ff       	call   80101693 <iput>
  end_op();
8010461b:	e8 33 e2 ff ff       	call   80102853 <end_op>
  return 0;
80104620:	83 c4 10             	add    $0x10,%esp
80104623:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104628:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010462b:	5b                   	pop    %ebx
8010462c:	5e                   	pop    %esi
8010462d:	5d                   	pop    %ebp
8010462e:	c3                   	ret    
    return -1;
8010462f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104634:	eb f2                	jmp    80104628 <sys_link+0xec>
    end_op();
80104636:	e8 18 e2 ff ff       	call   80102853 <end_op>
    return -1;
8010463b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104640:	eb e6                	jmp    80104628 <sys_link+0xec>
    iunlockput(ip);
80104642:	83 ec 0c             	sub    $0xc,%esp
80104645:	53                   	push   %ebx
80104646:	e8 ea d0 ff ff       	call   80101735 <iunlockput>
    end_op();
8010464b:	e8 03 e2 ff ff       	call   80102853 <end_op>
    return -1;
80104650:	83 c4 10             	add    $0x10,%esp
80104653:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104658:	eb ce                	jmp    80104628 <sys_link+0xec>
    iunlockput(dp);
8010465a:	83 ec 0c             	sub    $0xc,%esp
8010465d:	56                   	push   %esi
8010465e:	e8 d2 d0 ff ff       	call   80101735 <iunlockput>
    goto bad;
80104663:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104666:	83 ec 0c             	sub    $0xc,%esp
80104669:	53                   	push   %ebx
8010466a:	e8 17 cf ff ff       	call   80101586 <ilock>
  ip->nlink--;
8010466f:	66 8b 43 56          	mov    0x56(%ebx),%ax
80104673:	48                   	dec    %eax
80104674:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104678:	89 1c 24             	mov    %ebx,(%esp)
8010467b:	e8 a5 cd ff ff       	call   80101425 <iupdate>
  iunlockput(ip);
80104680:	89 1c 24             	mov    %ebx,(%esp)
80104683:	e8 ad d0 ff ff       	call   80101735 <iunlockput>
  end_op();
80104688:	e8 c6 e1 ff ff       	call   80102853 <end_op>
  return -1;
8010468d:	83 c4 10             	add    $0x10,%esp
80104690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104695:	eb 91                	jmp    80104628 <sys_link+0xec>

80104697 <sys_unlink>:
{
80104697:	f3 0f 1e fb          	endbr32 
8010469b:	55                   	push   %ebp
8010469c:	89 e5                	mov    %esp,%ebp
8010469e:	57                   	push   %edi
8010469f:	56                   	push   %esi
801046a0:	53                   	push   %ebx
801046a1:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801046a4:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801046a7:	50                   	push   %eax
801046a8:	6a 00                	push   $0x0
801046aa:	e8 42 f9 ff ff       	call   80103ff1 <argstr>
801046af:	83 c4 10             	add    $0x10,%esp
801046b2:	85 c0                	test   %eax,%eax
801046b4:	0f 88 7f 01 00 00    	js     80104839 <sys_unlink+0x1a2>
  begin_op();
801046ba:	e8 14 e1 ff ff       	call   801027d3 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801046bf:	83 ec 08             	sub    $0x8,%esp
801046c2:	8d 45 ca             	lea    -0x36(%ebp),%eax
801046c5:	50                   	push   %eax
801046c6:	ff 75 c4             	pushl  -0x3c(%ebp)
801046c9:	e8 60 d5 ff ff       	call   80101c2e <nameiparent>
801046ce:	89 c6                	mov    %eax,%esi
801046d0:	83 c4 10             	add    $0x10,%esp
801046d3:	85 c0                	test   %eax,%eax
801046d5:	0f 84 eb 00 00 00    	je     801047c6 <sys_unlink+0x12f>
  ilock(dp);
801046db:	83 ec 0c             	sub    $0xc,%esp
801046de:	50                   	push   %eax
801046df:	e8 a2 ce ff ff       	call   80101586 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801046e4:	83 c4 08             	add    $0x8,%esp
801046e7:	68 82 6d 10 80       	push   $0x80106d82
801046ec:	8d 45 ca             	lea    -0x36(%ebp),%eax
801046ef:	50                   	push   %eax
801046f0:	e8 ce d2 ff ff       	call   801019c3 <namecmp>
801046f5:	83 c4 10             	add    $0x10,%esp
801046f8:	85 c0                	test   %eax,%eax
801046fa:	0f 84 fa 00 00 00    	je     801047fa <sys_unlink+0x163>
80104700:	83 ec 08             	sub    $0x8,%esp
80104703:	68 81 6d 10 80       	push   $0x80106d81
80104708:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010470b:	50                   	push   %eax
8010470c:	e8 b2 d2 ff ff       	call   801019c3 <namecmp>
80104711:	83 c4 10             	add    $0x10,%esp
80104714:	85 c0                	test   %eax,%eax
80104716:	0f 84 de 00 00 00    	je     801047fa <sys_unlink+0x163>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010471c:	83 ec 04             	sub    $0x4,%esp
8010471f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104722:	50                   	push   %eax
80104723:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104726:	50                   	push   %eax
80104727:	56                   	push   %esi
80104728:	e8 af d2 ff ff       	call   801019dc <dirlookup>
8010472d:	89 c3                	mov    %eax,%ebx
8010472f:	83 c4 10             	add    $0x10,%esp
80104732:	85 c0                	test   %eax,%eax
80104734:	0f 84 c0 00 00 00    	je     801047fa <sys_unlink+0x163>
  ilock(ip);
8010473a:	83 ec 0c             	sub    $0xc,%esp
8010473d:	50                   	push   %eax
8010473e:	e8 43 ce ff ff       	call   80101586 <ilock>
  if(ip->nlink < 1)
80104743:	83 c4 10             	add    $0x10,%esp
80104746:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010474b:	0f 8e 81 00 00 00    	jle    801047d2 <sys_unlink+0x13b>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104751:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104756:	0f 84 83 00 00 00    	je     801047df <sys_unlink+0x148>
  memset(&de, 0, sizeof(de));
8010475c:	83 ec 04             	sub    $0x4,%esp
8010475f:	6a 10                	push   $0x10
80104761:	6a 00                	push   $0x0
80104763:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104766:	57                   	push   %edi
80104767:	e8 94 f5 ff ff       	call   80103d00 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010476c:	6a 10                	push   $0x10
8010476e:	ff 75 c0             	pushl  -0x40(%ebp)
80104771:	57                   	push   %edi
80104772:	56                   	push   %esi
80104773:	e8 13 d1 ff ff       	call   8010188b <writei>
80104778:	83 c4 20             	add    $0x20,%esp
8010477b:	83 f8 10             	cmp    $0x10,%eax
8010477e:	0f 85 8e 00 00 00    	jne    80104812 <sys_unlink+0x17b>
  if(ip->type == T_DIR){
80104784:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104789:	0f 84 90 00 00 00    	je     8010481f <sys_unlink+0x188>
  iunlockput(dp);
8010478f:	83 ec 0c             	sub    $0xc,%esp
80104792:	56                   	push   %esi
80104793:	e8 9d cf ff ff       	call   80101735 <iunlockput>
  ip->nlink--;
80104798:	66 8b 43 56          	mov    0x56(%ebx),%ax
8010479c:	48                   	dec    %eax
8010479d:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801047a1:	89 1c 24             	mov    %ebx,(%esp)
801047a4:	e8 7c cc ff ff       	call   80101425 <iupdate>
  iunlockput(ip);
801047a9:	89 1c 24             	mov    %ebx,(%esp)
801047ac:	e8 84 cf ff ff       	call   80101735 <iunlockput>
  end_op();
801047b1:	e8 9d e0 ff ff       	call   80102853 <end_op>
  return 0;
801047b6:	83 c4 10             	add    $0x10,%esp
801047b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801047be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801047c1:	5b                   	pop    %ebx
801047c2:	5e                   	pop    %esi
801047c3:	5f                   	pop    %edi
801047c4:	5d                   	pop    %ebp
801047c5:	c3                   	ret    
    end_op();
801047c6:	e8 88 e0 ff ff       	call   80102853 <end_op>
    return -1;
801047cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047d0:	eb ec                	jmp    801047be <sys_unlink+0x127>
    panic("unlink: nlink < 1");
801047d2:	83 ec 0c             	sub    $0xc,%esp
801047d5:	68 a0 6d 10 80       	push   $0x80106da0
801047da:	e8 76 bb ff ff       	call   80100355 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801047df:	89 d8                	mov    %ebx,%eax
801047e1:	e8 32 f9 ff ff       	call   80104118 <isdirempty>
801047e6:	85 c0                	test   %eax,%eax
801047e8:	0f 85 6e ff ff ff    	jne    8010475c <sys_unlink+0xc5>
    iunlockput(ip);
801047ee:	83 ec 0c             	sub    $0xc,%esp
801047f1:	53                   	push   %ebx
801047f2:	e8 3e cf ff ff       	call   80101735 <iunlockput>
    goto bad;
801047f7:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801047fa:	83 ec 0c             	sub    $0xc,%esp
801047fd:	56                   	push   %esi
801047fe:	e8 32 cf ff ff       	call   80101735 <iunlockput>
  end_op();
80104803:	e8 4b e0 ff ff       	call   80102853 <end_op>
  return -1;
80104808:	83 c4 10             	add    $0x10,%esp
8010480b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104810:	eb ac                	jmp    801047be <sys_unlink+0x127>
    panic("unlink: writei");
80104812:	83 ec 0c             	sub    $0xc,%esp
80104815:	68 b2 6d 10 80       	push   $0x80106db2
8010481a:	e8 36 bb ff ff       	call   80100355 <panic>
    dp->nlink--;
8010481f:	66 8b 46 56          	mov    0x56(%esi),%ax
80104823:	48                   	dec    %eax
80104824:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
80104828:	83 ec 0c             	sub    $0xc,%esp
8010482b:	56                   	push   %esi
8010482c:	e8 f4 cb ff ff       	call   80101425 <iupdate>
80104831:	83 c4 10             	add    $0x10,%esp
80104834:	e9 56 ff ff ff       	jmp    8010478f <sys_unlink+0xf8>
    return -1;
80104839:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010483e:	e9 7b ff ff ff       	jmp    801047be <sys_unlink+0x127>

80104843 <sys_open>:

int
sys_open(void)
{
80104843:	f3 0f 1e fb          	endbr32 
80104847:	55                   	push   %ebp
80104848:	89 e5                	mov    %esp,%ebp
8010484a:	57                   	push   %edi
8010484b:	56                   	push   %esi
8010484c:	53                   	push   %ebx
8010484d:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104850:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104853:	50                   	push   %eax
80104854:	6a 00                	push   $0x0
80104856:	e8 96 f7 ff ff       	call   80103ff1 <argstr>
8010485b:	83 c4 10             	add    $0x10,%esp
8010485e:	85 c0                	test   %eax,%eax
80104860:	0f 88 a0 00 00 00    	js     80104906 <sys_open+0xc3>
80104866:	83 ec 08             	sub    $0x8,%esp
80104869:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010486c:	50                   	push   %eax
8010486d:	6a 01                	push   $0x1
8010486f:	e8 e5 f6 ff ff       	call   80103f59 <argint>
80104874:	83 c4 10             	add    $0x10,%esp
80104877:	85 c0                	test   %eax,%eax
80104879:	0f 88 87 00 00 00    	js     80104906 <sys_open+0xc3>
    return -1;

  begin_op();
8010487f:	e8 4f df ff ff       	call   801027d3 <begin_op>

  if(omode & O_CREATE){
80104884:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
80104888:	0f 84 8b 00 00 00    	je     80104919 <sys_open+0xd6>
    ip = create(path, T_FILE, 0, 0);
8010488e:	83 ec 0c             	sub    $0xc,%esp
80104891:	6a 00                	push   $0x0
80104893:	b9 00 00 00 00       	mov    $0x0,%ecx
80104898:	ba 02 00 00 00       	mov    $0x2,%edx
8010489d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801048a0:	e8 ca f8 ff ff       	call   8010416f <create>
801048a5:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801048a7:	83 c4 10             	add    $0x10,%esp
801048aa:	85 c0                	test   %eax,%eax
801048ac:	74 5f                	je     8010490d <sys_open+0xca>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801048ae:	e8 6e c3 ff ff       	call   80100c21 <filealloc>
801048b3:	89 c3                	mov    %eax,%ebx
801048b5:	85 c0                	test   %eax,%eax
801048b7:	0f 84 b5 00 00 00    	je     80104972 <sys_open+0x12f>
801048bd:	e8 21 f8 ff ff       	call   801040e3 <fdalloc>
801048c2:	89 c7                	mov    %eax,%edi
801048c4:	85 c0                	test   %eax,%eax
801048c6:	0f 88 a6 00 00 00    	js     80104972 <sys_open+0x12f>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801048cc:	83 ec 0c             	sub    $0xc,%esp
801048cf:	56                   	push   %esi
801048d0:	e8 75 cd ff ff       	call   8010164a <iunlock>
  end_op();
801048d5:	e8 79 df ff ff       	call   80102853 <end_op>

  f->type = FD_INODE;
801048da:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
801048e0:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
801048e3:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
801048ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048ed:	83 c4 10             	add    $0x10,%esp
801048f0:	a8 01                	test   $0x1,%al
801048f2:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801048f6:	a8 03                	test   $0x3,%al
801048f8:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
801048fc:	89 f8                	mov    %edi,%eax
801048fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104901:	5b                   	pop    %ebx
80104902:	5e                   	pop    %esi
80104903:	5f                   	pop    %edi
80104904:	5d                   	pop    %ebp
80104905:	c3                   	ret    
    return -1;
80104906:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010490b:	eb ef                	jmp    801048fc <sys_open+0xb9>
      end_op();
8010490d:	e8 41 df ff ff       	call   80102853 <end_op>
      return -1;
80104912:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104917:	eb e3                	jmp    801048fc <sys_open+0xb9>
    if((ip = namei(path)) == 0){
80104919:	83 ec 0c             	sub    $0xc,%esp
8010491c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010491f:	e8 ee d2 ff ff       	call   80101c12 <namei>
80104924:	89 c6                	mov    %eax,%esi
80104926:	83 c4 10             	add    $0x10,%esp
80104929:	85 c0                	test   %eax,%eax
8010492b:	74 39                	je     80104966 <sys_open+0x123>
    ilock(ip);
8010492d:	83 ec 0c             	sub    $0xc,%esp
80104930:	50                   	push   %eax
80104931:	e8 50 cc ff ff       	call   80101586 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104936:	83 c4 10             	add    $0x10,%esp
80104939:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
8010493e:	0f 85 6a ff ff ff    	jne    801048ae <sys_open+0x6b>
80104944:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104948:	0f 84 60 ff ff ff    	je     801048ae <sys_open+0x6b>
      iunlockput(ip);
8010494e:	83 ec 0c             	sub    $0xc,%esp
80104951:	56                   	push   %esi
80104952:	e8 de cd ff ff       	call   80101735 <iunlockput>
      end_op();
80104957:	e8 f7 de ff ff       	call   80102853 <end_op>
      return -1;
8010495c:	83 c4 10             	add    $0x10,%esp
8010495f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104964:	eb 96                	jmp    801048fc <sys_open+0xb9>
      end_op();
80104966:	e8 e8 de ff ff       	call   80102853 <end_op>
      return -1;
8010496b:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104970:	eb 8a                	jmp    801048fc <sys_open+0xb9>
    if(f)
80104972:	85 db                	test   %ebx,%ebx
80104974:	74 0c                	je     80104982 <sys_open+0x13f>
      fileclose(f);
80104976:	83 ec 0c             	sub    $0xc,%esp
80104979:	53                   	push   %ebx
8010497a:	e8 4e c3 ff ff       	call   80100ccd <fileclose>
8010497f:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104982:	83 ec 0c             	sub    $0xc,%esp
80104985:	56                   	push   %esi
80104986:	e8 aa cd ff ff       	call   80101735 <iunlockput>
    end_op();
8010498b:	e8 c3 de ff ff       	call   80102853 <end_op>
    return -1;
80104990:	83 c4 10             	add    $0x10,%esp
80104993:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104998:	e9 5f ff ff ff       	jmp    801048fc <sys_open+0xb9>

8010499d <sys_mkdir>:

int
sys_mkdir(void)
{
8010499d:	f3 0f 1e fb          	endbr32 
801049a1:	55                   	push   %ebp
801049a2:	89 e5                	mov    %esp,%ebp
801049a4:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801049a7:	e8 27 de ff ff       	call   801027d3 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801049ac:	83 ec 08             	sub    $0x8,%esp
801049af:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049b2:	50                   	push   %eax
801049b3:	6a 00                	push   $0x0
801049b5:	e8 37 f6 ff ff       	call   80103ff1 <argstr>
801049ba:	83 c4 10             	add    $0x10,%esp
801049bd:	85 c0                	test   %eax,%eax
801049bf:	78 36                	js     801049f7 <sys_mkdir+0x5a>
801049c1:	83 ec 0c             	sub    $0xc,%esp
801049c4:	6a 00                	push   $0x0
801049c6:	b9 00 00 00 00       	mov    $0x0,%ecx
801049cb:	ba 01 00 00 00       	mov    $0x1,%edx
801049d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d3:	e8 97 f7 ff ff       	call   8010416f <create>
801049d8:	83 c4 10             	add    $0x10,%esp
801049db:	85 c0                	test   %eax,%eax
801049dd:	74 18                	je     801049f7 <sys_mkdir+0x5a>
    end_op();
    return -1;
  }
  iunlockput(ip);
801049df:	83 ec 0c             	sub    $0xc,%esp
801049e2:	50                   	push   %eax
801049e3:	e8 4d cd ff ff       	call   80101735 <iunlockput>
  end_op();
801049e8:	e8 66 de ff ff       	call   80102853 <end_op>
  return 0;
801049ed:	83 c4 10             	add    $0x10,%esp
801049f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801049f5:	c9                   	leave  
801049f6:	c3                   	ret    
    end_op();
801049f7:	e8 57 de ff ff       	call   80102853 <end_op>
    return -1;
801049fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a01:	eb f2                	jmp    801049f5 <sys_mkdir+0x58>

80104a03 <sys_mknod>:

int
sys_mknod(void)
{
80104a03:	f3 0f 1e fb          	endbr32 
80104a07:	55                   	push   %ebp
80104a08:	89 e5                	mov    %esp,%ebp
80104a0a:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104a0d:	e8 c1 dd ff ff       	call   801027d3 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104a12:	83 ec 08             	sub    $0x8,%esp
80104a15:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a18:	50                   	push   %eax
80104a19:	6a 00                	push   $0x0
80104a1b:	e8 d1 f5 ff ff       	call   80103ff1 <argstr>
80104a20:	83 c4 10             	add    $0x10,%esp
80104a23:	85 c0                	test   %eax,%eax
80104a25:	78 62                	js     80104a89 <sys_mknod+0x86>
     argint(1, &major) < 0 ||
80104a27:	83 ec 08             	sub    $0x8,%esp
80104a2a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a2d:	50                   	push   %eax
80104a2e:	6a 01                	push   $0x1
80104a30:	e8 24 f5 ff ff       	call   80103f59 <argint>
  if((argstr(0, &path)) < 0 ||
80104a35:	83 c4 10             	add    $0x10,%esp
80104a38:	85 c0                	test   %eax,%eax
80104a3a:	78 4d                	js     80104a89 <sys_mknod+0x86>
     argint(2, &minor) < 0 ||
80104a3c:	83 ec 08             	sub    $0x8,%esp
80104a3f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104a42:	50                   	push   %eax
80104a43:	6a 02                	push   $0x2
80104a45:	e8 0f f5 ff ff       	call   80103f59 <argint>
     argint(1, &major) < 0 ||
80104a4a:	83 c4 10             	add    $0x10,%esp
80104a4d:	85 c0                	test   %eax,%eax
80104a4f:	78 38                	js     80104a89 <sys_mknod+0x86>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104a51:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104a55:	83 ec 0c             	sub    $0xc,%esp
80104a58:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104a5c:	50                   	push   %eax
80104a5d:	ba 03 00 00 00       	mov    $0x3,%edx
80104a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a65:	e8 05 f7 ff ff       	call   8010416f <create>
     argint(2, &minor) < 0 ||
80104a6a:	83 c4 10             	add    $0x10,%esp
80104a6d:	85 c0                	test   %eax,%eax
80104a6f:	74 18                	je     80104a89 <sys_mknod+0x86>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104a71:	83 ec 0c             	sub    $0xc,%esp
80104a74:	50                   	push   %eax
80104a75:	e8 bb cc ff ff       	call   80101735 <iunlockput>
  end_op();
80104a7a:	e8 d4 dd ff ff       	call   80102853 <end_op>
  return 0;
80104a7f:	83 c4 10             	add    $0x10,%esp
80104a82:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a87:	c9                   	leave  
80104a88:	c3                   	ret    
    end_op();
80104a89:	e8 c5 dd ff ff       	call   80102853 <end_op>
    return -1;
80104a8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a93:	eb f2                	jmp    80104a87 <sys_mknod+0x84>

80104a95 <sys_chdir>:

int
sys_chdir(void)
{
80104a95:	f3 0f 1e fb          	endbr32 
80104a99:	55                   	push   %ebp
80104a9a:	89 e5                	mov    %esp,%ebp
80104a9c:	56                   	push   %esi
80104a9d:	53                   	push   %ebx
80104a9e:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104aa1:	e8 ab e7 ff ff       	call   80103251 <myproc>
80104aa6:	89 c6                	mov    %eax,%esi
  
  begin_op();
80104aa8:	e8 26 dd ff ff       	call   801027d3 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104aad:	83 ec 08             	sub    $0x8,%esp
80104ab0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ab3:	50                   	push   %eax
80104ab4:	6a 00                	push   $0x0
80104ab6:	e8 36 f5 ff ff       	call   80103ff1 <argstr>
80104abb:	83 c4 10             	add    $0x10,%esp
80104abe:	85 c0                	test   %eax,%eax
80104ac0:	78 52                	js     80104b14 <sys_chdir+0x7f>
80104ac2:	83 ec 0c             	sub    $0xc,%esp
80104ac5:	ff 75 f4             	pushl  -0xc(%ebp)
80104ac8:	e8 45 d1 ff ff       	call   80101c12 <namei>
80104acd:	89 c3                	mov    %eax,%ebx
80104acf:	83 c4 10             	add    $0x10,%esp
80104ad2:	85 c0                	test   %eax,%eax
80104ad4:	74 3e                	je     80104b14 <sys_chdir+0x7f>
    end_op();
    return -1;
  }
  ilock(ip);
80104ad6:	83 ec 0c             	sub    $0xc,%esp
80104ad9:	50                   	push   %eax
80104ada:	e8 a7 ca ff ff       	call   80101586 <ilock>
  if(ip->type != T_DIR){
80104adf:	83 c4 10             	add    $0x10,%esp
80104ae2:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ae7:	75 37                	jne    80104b20 <sys_chdir+0x8b>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104ae9:	83 ec 0c             	sub    $0xc,%esp
80104aec:	53                   	push   %ebx
80104aed:	e8 58 cb ff ff       	call   8010164a <iunlock>
  iput(curproc->cwd);
80104af2:	83 c4 04             	add    $0x4,%esp
80104af5:	ff 76 68             	pushl  0x68(%esi)
80104af8:	e8 96 cb ff ff       	call   80101693 <iput>
  end_op();
80104afd:	e8 51 dd ff ff       	call   80102853 <end_op>
  curproc->cwd = ip;
80104b02:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104b05:	83 c4 10             	add    $0x10,%esp
80104b08:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b10:	5b                   	pop    %ebx
80104b11:	5e                   	pop    %esi
80104b12:	5d                   	pop    %ebp
80104b13:	c3                   	ret    
    end_op();
80104b14:	e8 3a dd ff ff       	call   80102853 <end_op>
    return -1;
80104b19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b1e:	eb ed                	jmp    80104b0d <sys_chdir+0x78>
    iunlockput(ip);
80104b20:	83 ec 0c             	sub    $0xc,%esp
80104b23:	53                   	push   %ebx
80104b24:	e8 0c cc ff ff       	call   80101735 <iunlockput>
    end_op();
80104b29:	e8 25 dd ff ff       	call   80102853 <end_op>
    return -1;
80104b2e:	83 c4 10             	add    $0x10,%esp
80104b31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b36:	eb d5                	jmp    80104b0d <sys_chdir+0x78>

80104b38 <sys_exec>:

int
sys_exec(void)
{
80104b38:	f3 0f 1e fb          	endbr32 
80104b3c:	55                   	push   %ebp
80104b3d:	89 e5                	mov    %esp,%ebp
80104b3f:	53                   	push   %ebx
80104b40:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104b46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b49:	50                   	push   %eax
80104b4a:	6a 00                	push   $0x0
80104b4c:	e8 a0 f4 ff ff       	call   80103ff1 <argstr>
80104b51:	83 c4 10             	add    $0x10,%esp
80104b54:	85 c0                	test   %eax,%eax
80104b56:	78 38                	js     80104b90 <sys_exec+0x58>
80104b58:	83 ec 08             	sub    $0x8,%esp
80104b5b:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104b61:	50                   	push   %eax
80104b62:	6a 01                	push   $0x1
80104b64:	e8 f0 f3 ff ff       	call   80103f59 <argint>
80104b69:	83 c4 10             	add    $0x10,%esp
80104b6c:	85 c0                	test   %eax,%eax
80104b6e:	78 20                	js     80104b90 <sys_exec+0x58>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104b70:	83 ec 04             	sub    $0x4,%esp
80104b73:	68 80 00 00 00       	push   $0x80
80104b78:	6a 00                	push   $0x0
80104b7a:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104b80:	50                   	push   %eax
80104b81:	e8 7a f1 ff ff       	call   80103d00 <memset>
80104b86:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80104b89:	bb 00 00 00 00       	mov    $0x0,%ebx
80104b8e:	eb 2a                	jmp    80104bba <sys_exec+0x82>
    return -1;
80104b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b95:	eb 76                	jmp    80104c0d <sys_exec+0xd5>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80104b97:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80104b9e:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104ba2:	83 ec 08             	sub    $0x8,%esp
80104ba5:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104bab:	50                   	push   %eax
80104bac:	ff 75 f4             	pushl  -0xc(%ebp)
80104baf:	e8 0b bd ff ff       	call   801008bf <exec>
80104bb4:	83 c4 10             	add    $0x10,%esp
80104bb7:	eb 54                	jmp    80104c0d <sys_exec+0xd5>
  for(i=0;; i++){
80104bb9:	43                   	inc    %ebx
    if(i >= NELEM(argv))
80104bba:	83 fb 1f             	cmp    $0x1f,%ebx
80104bbd:	77 49                	ja     80104c08 <sys_exec+0xd0>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104bbf:	83 ec 08             	sub    $0x8,%esp
80104bc2:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104bc8:	50                   	push   %eax
80104bc9:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104bcf:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104bd2:	50                   	push   %eax
80104bd3:	e8 ff f2 ff ff       	call   80103ed7 <fetchint>
80104bd8:	83 c4 10             	add    $0x10,%esp
80104bdb:	85 c0                	test   %eax,%eax
80104bdd:	78 33                	js     80104c12 <sys_exec+0xda>
    if(uarg == 0){
80104bdf:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80104be5:	85 c0                	test   %eax,%eax
80104be7:	74 ae                	je     80104b97 <sys_exec+0x5f>
    if(fetchstr(uarg, &argv[i]) < 0)
80104be9:	83 ec 08             	sub    $0x8,%esp
80104bec:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104bf3:	52                   	push   %edx
80104bf4:	50                   	push   %eax
80104bf5:	e8 1d f3 ff ff       	call   80103f17 <fetchstr>
80104bfa:	83 c4 10             	add    $0x10,%esp
80104bfd:	85 c0                	test   %eax,%eax
80104bff:	79 b8                	jns    80104bb9 <sys_exec+0x81>
      return -1;
80104c01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c06:	eb 05                	jmp    80104c0d <sys_exec+0xd5>
      return -1;
80104c08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c0d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c10:	c9                   	leave  
80104c11:	c3                   	ret    
      return -1;
80104c12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c17:	eb f4                	jmp    80104c0d <sys_exec+0xd5>

80104c19 <sys_pipe>:

int
sys_pipe(void)
{
80104c19:	f3 0f 1e fb          	endbr32 
80104c1d:	55                   	push   %ebp
80104c1e:	89 e5                	mov    %esp,%ebp
80104c20:	53                   	push   %ebx
80104c21:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104c24:	6a 08                	push   $0x8
80104c26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c29:	50                   	push   %eax
80104c2a:	6a 00                	push   $0x0
80104c2c:	e8 54 f3 ff ff       	call   80103f85 <argptr>
80104c31:	83 c4 10             	add    $0x10,%esp
80104c34:	85 c0                	test   %eax,%eax
80104c36:	78 79                	js     80104cb1 <sys_pipe+0x98>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104c38:	83 ec 08             	sub    $0x8,%esp
80104c3b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104c3e:	50                   	push   %eax
80104c3f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c42:	50                   	push   %eax
80104c43:	e8 1e e1 ff ff       	call   80102d66 <pipealloc>
80104c48:	83 c4 10             	add    $0x10,%esp
80104c4b:	85 c0                	test   %eax,%eax
80104c4d:	78 69                	js     80104cb8 <sys_pipe+0x9f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c52:	e8 8c f4 ff ff       	call   801040e3 <fdalloc>
80104c57:	89 c3                	mov    %eax,%ebx
80104c59:	85 c0                	test   %eax,%eax
80104c5b:	78 21                	js     80104c7e <sys_pipe+0x65>
80104c5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c60:	e8 7e f4 ff ff       	call   801040e3 <fdalloc>
80104c65:	85 c0                	test   %eax,%eax
80104c67:	78 15                	js     80104c7e <sys_pipe+0x65>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104c69:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c6c:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c71:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104c74:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c7c:	c9                   	leave  
80104c7d:	c3                   	ret    
    if(fd0 >= 0)
80104c7e:	85 db                	test   %ebx,%ebx
80104c80:	79 20                	jns    80104ca2 <sys_pipe+0x89>
    fileclose(rf);
80104c82:	83 ec 0c             	sub    $0xc,%esp
80104c85:	ff 75 f0             	pushl  -0x10(%ebp)
80104c88:	e8 40 c0 ff ff       	call   80100ccd <fileclose>
    fileclose(wf);
80104c8d:	83 c4 04             	add    $0x4,%esp
80104c90:	ff 75 ec             	pushl  -0x14(%ebp)
80104c93:	e8 35 c0 ff ff       	call   80100ccd <fileclose>
    return -1;
80104c98:	83 c4 10             	add    $0x10,%esp
80104c9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ca0:	eb d7                	jmp    80104c79 <sys_pipe+0x60>
      myproc()->ofile[fd0] = 0;
80104ca2:	e8 aa e5 ff ff       	call   80103251 <myproc>
80104ca7:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104cae:	00 
80104caf:	eb d1                	jmp    80104c82 <sys_pipe+0x69>
    return -1;
80104cb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cb6:	eb c1                	jmp    80104c79 <sys_pipe+0x60>
    return -1;
80104cb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cbd:	eb ba                	jmp    80104c79 <sys_pipe+0x60>

80104cbf <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80104cbf:	f3 0f 1e fb          	endbr32 
80104cc3:	55                   	push   %ebp
80104cc4:	89 e5                	mov    %esp,%ebp
80104cc6:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104cc9:	e8 03 e7 ff ff       	call   801033d1 <fork>
}
80104cce:	c9                   	leave  
80104ccf:	c3                   	ret    

80104cd0 <sys_exit>:

int
sys_exit(void)
{
80104cd0:	f3 0f 1e fb          	endbr32 
80104cd4:	55                   	push   %ebp
80104cd5:	89 e5                	mov    %esp,%ebp
80104cd7:	83 ec 08             	sub    $0x8,%esp
  exit();
80104cda:	e8 30 e9 ff ff       	call   8010360f <exit>
  return 0;  // not reached
}
80104cdf:	b8 00 00 00 00       	mov    $0x0,%eax
80104ce4:	c9                   	leave  
80104ce5:	c3                   	ret    

80104ce6 <sys_wait>:

int
sys_wait(void)
{
80104ce6:	f3 0f 1e fb          	endbr32 
80104cea:	55                   	push   %ebp
80104ceb:	89 e5                	mov    %esp,%ebp
80104ced:	83 ec 08             	sub    $0x8,%esp
  return wait();
80104cf0:	e8 be ea ff ff       	call   801037b3 <wait>
}
80104cf5:	c9                   	leave  
80104cf6:	c3                   	ret    

80104cf7 <sys_kill>:

int
sys_kill(void)
{
80104cf7:	f3 0f 1e fb          	endbr32 
80104cfb:	55                   	push   %ebp
80104cfc:	89 e5                	mov    %esp,%ebp
80104cfe:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104d01:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d04:	50                   	push   %eax
80104d05:	6a 00                	push   $0x0
80104d07:	e8 4d f2 ff ff       	call   80103f59 <argint>
80104d0c:	83 c4 10             	add    $0x10,%esp
80104d0f:	85 c0                	test   %eax,%eax
80104d11:	78 10                	js     80104d23 <sys_kill+0x2c>
    return -1;
  return kill(pid);
80104d13:	83 ec 0c             	sub    $0xc,%esp
80104d16:	ff 75 f4             	pushl  -0xc(%ebp)
80104d19:	e8 9c eb ff ff       	call   801038ba <kill>
80104d1e:	83 c4 10             	add    $0x10,%esp
}
80104d21:	c9                   	leave  
80104d22:	c3                   	ret    
    return -1;
80104d23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d28:	eb f7                	jmp    80104d21 <sys_kill+0x2a>

80104d2a <sys_getpid>:

int
sys_getpid(void)
{
80104d2a:	f3 0f 1e fb          	endbr32 
80104d2e:	55                   	push   %ebp
80104d2f:	89 e5                	mov    %esp,%ebp
80104d31:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104d34:	e8 18 e5 ff ff       	call   80103251 <myproc>
80104d39:	8b 40 10             	mov    0x10(%eax),%eax
}
80104d3c:	c9                   	leave  
80104d3d:	c3                   	ret    

80104d3e <sys_sbrk>:

int
sys_sbrk(void)
{
80104d3e:	f3 0f 1e fb          	endbr32 
80104d42:	55                   	push   %ebp
80104d43:	89 e5                	mov    %esp,%ebp
80104d45:	53                   	push   %ebx
80104d46:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104d49:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d4c:	50                   	push   %eax
80104d4d:	6a 00                	push   $0x0
80104d4f:	e8 05 f2 ff ff       	call   80103f59 <argint>
80104d54:	83 c4 10             	add    $0x10,%esp
80104d57:	85 c0                	test   %eax,%eax
80104d59:	78 20                	js     80104d7b <sys_sbrk+0x3d>
    return -1;
  addr = myproc()->sz;
80104d5b:	e8 f1 e4 ff ff       	call   80103251 <myproc>
80104d60:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80104d62:	83 ec 0c             	sub    $0xc,%esp
80104d65:	ff 75 f4             	pushl  -0xc(%ebp)
80104d68:	e8 f6 e5 ff ff       	call   80103363 <growproc>
80104d6d:	83 c4 10             	add    $0x10,%esp
80104d70:	85 c0                	test   %eax,%eax
80104d72:	78 0e                	js     80104d82 <sys_sbrk+0x44>
    return -1;
  return addr;
}
80104d74:	89 d8                	mov    %ebx,%eax
80104d76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d79:	c9                   	leave  
80104d7a:	c3                   	ret    
    return -1;
80104d7b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104d80:	eb f2                	jmp    80104d74 <sys_sbrk+0x36>
    return -1;
80104d82:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104d87:	eb eb                	jmp    80104d74 <sys_sbrk+0x36>

80104d89 <sys_sleep>:

int
sys_sleep(void)
{
80104d89:	f3 0f 1e fb          	endbr32 
80104d8d:	55                   	push   %ebp
80104d8e:	89 e5                	mov    %esp,%ebp
80104d90:	53                   	push   %ebx
80104d91:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104d94:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d97:	50                   	push   %eax
80104d98:	6a 00                	push   $0x0
80104d9a:	e8 ba f1 ff ff       	call   80103f59 <argint>
80104d9f:	83 c4 10             	add    $0x10,%esp
80104da2:	85 c0                	test   %eax,%eax
80104da4:	78 75                	js     80104e1b <sys_sleep+0x92>
    return -1;
  acquire(&tickslock);
80104da6:	83 ec 0c             	sub    $0xc,%esp
80104da9:	68 60 4c 11 80       	push   $0x80114c60
80104dae:	e8 99 ee ff ff       	call   80103c4c <acquire>
  ticks0 = ticks;
80104db3:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
80104db9:	83 c4 10             	add    $0x10,%esp
80104dbc:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80104dc1:	29 d8                	sub    %ebx,%eax
80104dc3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104dc6:	73 39                	jae    80104e01 <sys_sleep+0x78>
    if(myproc()->killed){
80104dc8:	e8 84 e4 ff ff       	call   80103251 <myproc>
80104dcd:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104dd1:	75 17                	jne    80104dea <sys_sleep+0x61>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104dd3:	83 ec 08             	sub    $0x8,%esp
80104dd6:	68 60 4c 11 80       	push   $0x80114c60
80104ddb:	68 a0 54 11 80       	push   $0x801154a0
80104de0:	e8 39 e9 ff ff       	call   8010371e <sleep>
80104de5:	83 c4 10             	add    $0x10,%esp
80104de8:	eb d2                	jmp    80104dbc <sys_sleep+0x33>
      release(&tickslock);
80104dea:	83 ec 0c             	sub    $0xc,%esp
80104ded:	68 60 4c 11 80       	push   $0x80114c60
80104df2:	e8 be ee ff ff       	call   80103cb5 <release>
      return -1;
80104df7:	83 c4 10             	add    $0x10,%esp
80104dfa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dff:	eb 15                	jmp    80104e16 <sys_sleep+0x8d>
  }
  release(&tickslock);
80104e01:	83 ec 0c             	sub    $0xc,%esp
80104e04:	68 60 4c 11 80       	push   $0x80114c60
80104e09:	e8 a7 ee ff ff       	call   80103cb5 <release>
  return 0;
80104e0e:	83 c4 10             	add    $0x10,%esp
80104e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e19:	c9                   	leave  
80104e1a:	c3                   	ret    
    return -1;
80104e1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e20:	eb f4                	jmp    80104e16 <sys_sleep+0x8d>

80104e22 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80104e22:	f3 0f 1e fb          	endbr32 
80104e26:	55                   	push   %ebp
80104e27:	89 e5                	mov    %esp,%ebp
80104e29:	53                   	push   %ebx
80104e2a:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80104e2d:	68 60 4c 11 80       	push   $0x80114c60
80104e32:	e8 15 ee ff ff       	call   80103c4c <acquire>
  xticks = ticks;
80104e37:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
80104e3d:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80104e44:	e8 6c ee ff ff       	call   80103cb5 <release>
  return xticks;
}
80104e49:	89 d8                	mov    %ebx,%eax
80104e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e4e:	c9                   	leave  
80104e4f:	c3                   	ret    

80104e50 <sys_date>:

int
sys_date(void){
80104e50:	f3 0f 1e fb          	endbr32 
80104e54:	55                   	push   %ebp
80104e55:	89 e5                	mov    %esp,%ebp
80104e57:	83 ec 1c             	sub    $0x1c,%esp

  struct rtcdate *d;
  
  if(argptr(0,(void **)&d,sizeof(struct rtcdate))<-1)
80104e5a:	6a 18                	push   $0x18
80104e5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e5f:	50                   	push   %eax
80104e60:	6a 00                	push   $0x0
80104e62:	e8 1e f1 ff ff       	call   80103f85 <argptr>
80104e67:	83 c4 10             	add    $0x10,%esp
80104e6a:	83 f8 ff             	cmp    $0xffffffff,%eax
80104e6d:	7c 15                	jl     80104e84 <sys_date+0x34>
    return -1;
  cmostime(d);
80104e6f:	83 ec 0c             	sub    $0xc,%esp
80104e72:	ff 75 f4             	pushl  -0xc(%ebp)
80104e75:	e8 23 d6 ff ff       	call   8010249d <cmostime>
  return 0;
80104e7a:	83 c4 10             	add    $0x10,%esp
80104e7d:	b8 00 00 00 00       	mov    $0x0,%eax

}
80104e82:	c9                   	leave  
80104e83:	c3                   	ret    
    return -1;
80104e84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e89:	eb f7                	jmp    80104e82 <sys_date+0x32>

80104e8b <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80104e8b:	1e                   	push   %ds
  pushl %es
80104e8c:	06                   	push   %es
  pushl %fs
80104e8d:	0f a0                	push   %fs
  pushl %gs
80104e8f:	0f a8                	push   %gs
  pushal
80104e91:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80104e92:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80104e96:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80104e98:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80104e9a:	54                   	push   %esp
  call trap
80104e9b:	e8 e6 00 00 00       	call   80104f86 <trap>
  addl $4, %esp
80104ea0:	83 c4 04             	add    $0x4,%esp

80104ea3 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80104ea3:	61                   	popa   
  popl %gs
80104ea4:	0f a9                	pop    %gs
  popl %fs
80104ea6:	0f a1                	pop    %fs
  popl %es
80104ea8:	07                   	pop    %es
  popl %ds
80104ea9:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80104eaa:	83 c4 08             	add    $0x8,%esp
  iret
80104ead:	cf                   	iret   

80104eae <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80104eae:	f3 0f 1e fb          	endbr32 
80104eb2:	55                   	push   %ebp
80104eb3:	89 e5                	mov    %esp,%ebp
80104eb5:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
80104eb8:	b8 00 00 00 00       	mov    $0x0,%eax
80104ebd:	3d ff 00 00 00       	cmp    $0xff,%eax
80104ec2:	7f 49                	jg     80104f0d <tvinit+0x5f>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80104ec4:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
80104ecb:	66 89 0c c5 a0 4c 11 	mov    %cx,-0x7feeb360(,%eax,8)
80104ed2:	80 
80104ed3:	66 c7 04 c5 a2 4c 11 	movw   $0x8,-0x7feeb35e(,%eax,8)
80104eda:	80 08 00 
80104edd:	c6 04 c5 a4 4c 11 80 	movb   $0x0,-0x7feeb35c(,%eax,8)
80104ee4:	00 
80104ee5:	8a 14 c5 a5 4c 11 80 	mov    -0x7feeb35b(,%eax,8),%dl
80104eec:	83 e2 f0             	and    $0xfffffff0,%edx
80104eef:	83 ca 0e             	or     $0xe,%edx
80104ef2:	83 e2 8f             	and    $0xffffff8f,%edx
80104ef5:	83 ca 80             	or     $0xffffff80,%edx
80104ef8:	88 14 c5 a5 4c 11 80 	mov    %dl,-0x7feeb35b(,%eax,8)
80104eff:	c1 e9 10             	shr    $0x10,%ecx
80104f02:	66 89 0c c5 a6 4c 11 	mov    %cx,-0x7feeb35a(,%eax,8)
80104f09:	80 
  for(i = 0; i < 256; i++)
80104f0a:	40                   	inc    %eax
80104f0b:	eb b0                	jmp    80104ebd <tvinit+0xf>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80104f0d:	8b 15 08 a1 10 80    	mov    0x8010a108,%edx
80104f13:	66 89 15 a0 4e 11 80 	mov    %dx,0x80114ea0
80104f1a:	66 c7 05 a2 4e 11 80 	movw   $0x8,0x80114ea2
80104f21:	08 00 
80104f23:	c6 05 a4 4e 11 80 00 	movb   $0x0,0x80114ea4
80104f2a:	a0 a5 4e 11 80       	mov    0x80114ea5,%al
80104f2f:	83 c8 0f             	or     $0xf,%eax
80104f32:	83 e0 ef             	and    $0xffffffef,%eax
80104f35:	83 c8 e0             	or     $0xffffffe0,%eax
80104f38:	a2 a5 4e 11 80       	mov    %al,0x80114ea5
80104f3d:	c1 ea 10             	shr    $0x10,%edx
80104f40:	66 89 15 a6 4e 11 80 	mov    %dx,0x80114ea6

  initlock(&tickslock, "time");
80104f47:	83 ec 08             	sub    $0x8,%esp
80104f4a:	68 c1 6d 10 80       	push   $0x80106dc1
80104f4f:	68 60 4c 11 80       	push   $0x80114c60
80104f54:	e8 a8 eb ff ff       	call   80103b01 <initlock>
}
80104f59:	83 c4 10             	add    $0x10,%esp
80104f5c:	c9                   	leave  
80104f5d:	c3                   	ret    

80104f5e <idtinit>:

void
idtinit(void)
{
80104f5e:	f3 0f 1e fb          	endbr32 
80104f62:	55                   	push   %ebp
80104f63:	89 e5                	mov    %esp,%ebp
80104f65:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80104f68:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80104f6e:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
80104f73:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80104f77:	c1 e8 10             	shr    $0x10,%eax
80104f7a:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80104f7e:	8d 45 fa             	lea    -0x6(%ebp),%eax
80104f81:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80104f84:	c9                   	leave  
80104f85:	c3                   	ret    

80104f86 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80104f86:	f3 0f 1e fb          	endbr32 
80104f8a:	55                   	push   %ebp
80104f8b:	89 e5                	mov    %esp,%ebp
80104f8d:	57                   	push   %edi
80104f8e:	56                   	push   %esi
80104f8f:	53                   	push   %ebx
80104f90:	83 ec 1c             	sub    $0x1c,%esp
80104f93:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80104f96:	8b 43 30             	mov    0x30(%ebx),%eax
80104f99:	83 f8 40             	cmp    $0x40,%eax
80104f9c:	74 14                	je     80104fb2 <trap+0x2c>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80104f9e:	83 e8 20             	sub    $0x20,%eax
80104fa1:	83 f8 1f             	cmp    $0x1f,%eax
80104fa4:	0f 87 37 01 00 00    	ja     801050e1 <trap+0x15b>
80104faa:	3e ff 24 85 68 6e 10 	notrack jmp *-0x7fef9198(,%eax,4)
80104fb1:	80 
    if(myproc()->killed)
80104fb2:	e8 9a e2 ff ff       	call   80103251 <myproc>
80104fb7:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104fbb:	75 1f                	jne    80104fdc <trap+0x56>
    myproc()->tf = tf;
80104fbd:	e8 8f e2 ff ff       	call   80103251 <myproc>
80104fc2:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80104fc5:	e8 5e f0 ff ff       	call   80104028 <syscall>
    if(myproc()->killed)
80104fca:	e8 82 e2 ff ff       	call   80103251 <myproc>
80104fcf:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104fd3:	74 7c                	je     80105051 <trap+0xcb>
      exit();
80104fd5:	e8 35 e6 ff ff       	call   8010360f <exit>
    return;
80104fda:	eb 75                	jmp    80105051 <trap+0xcb>
      exit();
80104fdc:	e8 2e e6 ff ff       	call   8010360f <exit>
80104fe1:	eb da                	jmp    80104fbd <trap+0x37>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80104fe3:	e8 34 e2 ff ff       	call   8010321c <cpuid>
80104fe8:	85 c0                	test   %eax,%eax
80104fea:	74 6d                	je     80105059 <trap+0xd3>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80104fec:	e8 eb d3 ff ff       	call   801023dc <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80104ff1:	e8 5b e2 ff ff       	call   80103251 <myproc>
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	74 1b                	je     80105015 <trap+0x8f>
80104ffa:	e8 52 e2 ff ff       	call   80103251 <myproc>
80104fff:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105003:	74 10                	je     80105015 <trap+0x8f>
80105005:	8b 43 3c             	mov    0x3c(%ebx),%eax
80105008:	83 e0 03             	and    $0x3,%eax
8010500b:	66 83 f8 03          	cmp    $0x3,%ax
8010500f:	0f 84 5f 01 00 00    	je     80105174 <trap+0x1ee>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105015:	e8 37 e2 ff ff       	call   80103251 <myproc>
8010501a:	85 c0                	test   %eax,%eax
8010501c:	74 0f                	je     8010502d <trap+0xa7>
8010501e:	e8 2e e2 ff ff       	call   80103251 <myproc>
80105023:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105027:	0f 84 51 01 00 00    	je     8010517e <trap+0x1f8>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010502d:	e8 1f e2 ff ff       	call   80103251 <myproc>
80105032:	85 c0                	test   %eax,%eax
80105034:	74 1b                	je     80105051 <trap+0xcb>
80105036:	e8 16 e2 ff ff       	call   80103251 <myproc>
8010503b:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010503f:	74 10                	je     80105051 <trap+0xcb>
80105041:	8b 43 3c             	mov    0x3c(%ebx),%eax
80105044:	83 e0 03             	and    $0x3,%eax
80105047:	66 83 f8 03          	cmp    $0x3,%ax
8010504b:	0f 84 41 01 00 00    	je     80105192 <trap+0x20c>
    exit();
}
80105051:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105054:	5b                   	pop    %ebx
80105055:	5e                   	pop    %esi
80105056:	5f                   	pop    %edi
80105057:	5d                   	pop    %ebp
80105058:	c3                   	ret    
      acquire(&tickslock);
80105059:	83 ec 0c             	sub    $0xc,%esp
8010505c:	68 60 4c 11 80       	push   $0x80114c60
80105061:	e8 e6 eb ff ff       	call   80103c4c <acquire>
      ticks++;
80105066:	ff 05 a0 54 11 80    	incl   0x801154a0
      wakeup(&ticks);
8010506c:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
80105073:	e8 15 e8 ff ff       	call   8010388d <wakeup>
      release(&tickslock);
80105078:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010507f:	e8 31 ec ff ff       	call   80103cb5 <release>
80105084:	83 c4 10             	add    $0x10,%esp
80105087:	e9 60 ff ff ff       	jmp    80104fec <trap+0x66>
    ideintr();
8010508c:	e8 07 cd ff ff       	call   80101d98 <ideintr>
    lapiceoi();
80105091:	e8 46 d3 ff ff       	call   801023dc <lapiceoi>
    break;
80105096:	e9 56 ff ff ff       	jmp    80104ff1 <trap+0x6b>
    kbdintr();
8010509b:	e8 79 d1 ff ff       	call   80102219 <kbdintr>
    lapiceoi();
801050a0:	e8 37 d3 ff ff       	call   801023dc <lapiceoi>
    break;
801050a5:	e9 47 ff ff ff       	jmp    80104ff1 <trap+0x6b>
    uartintr();
801050aa:	e8 f5 01 00 00       	call   801052a4 <uartintr>
    lapiceoi();
801050af:	e8 28 d3 ff ff       	call   801023dc <lapiceoi>
    break;
801050b4:	e9 38 ff ff ff       	jmp    80104ff1 <trap+0x6b>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801050b9:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
801050bc:	8b 73 3c             	mov    0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801050bf:	e8 58 e1 ff ff       	call   8010321c <cpuid>
801050c4:	57                   	push   %edi
801050c5:	0f b7 f6             	movzwl %si,%esi
801050c8:	56                   	push   %esi
801050c9:	50                   	push   %eax
801050ca:	68 cc 6d 10 80       	push   $0x80106dcc
801050cf:	e8 29 b5 ff ff       	call   801005fd <cprintf>
    lapiceoi();
801050d4:	e8 03 d3 ff ff       	call   801023dc <lapiceoi>
    break;
801050d9:	83 c4 10             	add    $0x10,%esp
801050dc:	e9 10 ff ff ff       	jmp    80104ff1 <trap+0x6b>
    if(myproc() == 0 || (tf->cs&3) == 0){
801050e1:	e8 6b e1 ff ff       	call   80103251 <myproc>
801050e6:	85 c0                	test   %eax,%eax
801050e8:	74 5f                	je     80105149 <trap+0x1c3>
801050ea:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801050ee:	74 59                	je     80105149 <trap+0x1c3>
  asm volatile("movl %%cr2,%0" : "=r" (val));
801050f0:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801050f3:	8b 43 38             	mov    0x38(%ebx),%eax
801050f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801050f9:	e8 1e e1 ff ff       	call   8010321c <cpuid>
801050fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105101:	8b 53 34             	mov    0x34(%ebx),%edx
80105104:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105107:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
8010510a:	e8 42 e1 ff ff       	call   80103251 <myproc>
8010510f:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105112:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105115:	e8 37 e1 ff ff       	call   80103251 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010511a:	57                   	push   %edi
8010511b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010511e:	ff 75 e0             	pushl  -0x20(%ebp)
80105121:	ff 75 dc             	pushl  -0x24(%ebp)
80105124:	56                   	push   %esi
80105125:	ff 75 d8             	pushl  -0x28(%ebp)
80105128:	ff 70 10             	pushl  0x10(%eax)
8010512b:	68 24 6e 10 80       	push   $0x80106e24
80105130:	e8 c8 b4 ff ff       	call   801005fd <cprintf>
    myproc()->killed = 1;
80105135:	83 c4 20             	add    $0x20,%esp
80105138:	e8 14 e1 ff ff       	call   80103251 <myproc>
8010513d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105144:	e9 a8 fe ff ff       	jmp    80104ff1 <trap+0x6b>
80105149:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010514c:	8b 73 38             	mov    0x38(%ebx),%esi
8010514f:	e8 c8 e0 ff ff       	call   8010321c <cpuid>
80105154:	83 ec 0c             	sub    $0xc,%esp
80105157:	57                   	push   %edi
80105158:	56                   	push   %esi
80105159:	50                   	push   %eax
8010515a:	ff 73 30             	pushl  0x30(%ebx)
8010515d:	68 f0 6d 10 80       	push   $0x80106df0
80105162:	e8 96 b4 ff ff       	call   801005fd <cprintf>
      panic("trap");
80105167:	83 c4 14             	add    $0x14,%esp
8010516a:	68 c6 6d 10 80       	push   $0x80106dc6
8010516f:	e8 e1 b1 ff ff       	call   80100355 <panic>
    exit();
80105174:	e8 96 e4 ff ff       	call   8010360f <exit>
80105179:	e9 97 fe ff ff       	jmp    80105015 <trap+0x8f>
  if(myproc() && myproc()->state == RUNNING &&
8010517e:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105182:	0f 85 a5 fe ff ff    	jne    8010502d <trap+0xa7>
    yield();
80105188:	e8 5b e5 ff ff       	call   801036e8 <yield>
8010518d:	e9 9b fe ff ff       	jmp    8010502d <trap+0xa7>
    exit();
80105192:	e8 78 e4 ff ff       	call   8010360f <exit>
80105197:	e9 b5 fe ff ff       	jmp    80105051 <trap+0xcb>

8010519c <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
8010519c:	f3 0f 1e fb          	endbr32 
  if(!uart)
801051a0:	83 3d bc a5 10 80 00 	cmpl   $0x0,0x8010a5bc
801051a7:	74 14                	je     801051bd <uartgetc+0x21>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801051a9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801051ae:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801051af:	a8 01                	test   $0x1,%al
801051b1:	74 10                	je     801051c3 <uartgetc+0x27>
801051b3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801051b8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801051b9:	0f b6 c0             	movzbl %al,%eax
801051bc:	c3                   	ret    
    return -1;
801051bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051c2:	c3                   	ret    
    return -1;
801051c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051c8:	c3                   	ret    

801051c9 <uartputc>:
{
801051c9:	f3 0f 1e fb          	endbr32 
  if(!uart)
801051cd:	83 3d bc a5 10 80 00 	cmpl   $0x0,0x8010a5bc
801051d4:	74 39                	je     8010520f <uartputc+0x46>
{
801051d6:	55                   	push   %ebp
801051d7:	89 e5                	mov    %esp,%ebp
801051d9:	53                   	push   %ebx
801051da:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801051dd:	bb 00 00 00 00       	mov    $0x0,%ebx
801051e2:	83 fb 7f             	cmp    $0x7f,%ebx
801051e5:	7f 1a                	jg     80105201 <uartputc+0x38>
801051e7:	ba fd 03 00 00       	mov    $0x3fd,%edx
801051ec:	ec                   	in     (%dx),%al
801051ed:	a8 20                	test   $0x20,%al
801051ef:	75 10                	jne    80105201 <uartputc+0x38>
    microdelay(10);
801051f1:	83 ec 0c             	sub    $0xc,%esp
801051f4:	6a 0a                	push   $0xa
801051f6:	e8 06 d2 ff ff       	call   80102401 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801051fb:	43                   	inc    %ebx
801051fc:	83 c4 10             	add    $0x10,%esp
801051ff:	eb e1                	jmp    801051e2 <uartputc+0x19>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105201:	8b 45 08             	mov    0x8(%ebp),%eax
80105204:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105209:	ee                   	out    %al,(%dx)
}
8010520a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010520d:	c9                   	leave  
8010520e:	c3                   	ret    
8010520f:	c3                   	ret    

80105210 <uartinit>:
{
80105210:	f3 0f 1e fb          	endbr32 
80105214:	55                   	push   %ebp
80105215:	89 e5                	mov    %esp,%ebp
80105217:	56                   	push   %esi
80105218:	53                   	push   %ebx
80105219:	b1 00                	mov    $0x0,%cl
8010521b:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105220:	88 c8                	mov    %cl,%al
80105222:	ee                   	out    %al,(%dx)
80105223:	be fb 03 00 00       	mov    $0x3fb,%esi
80105228:	b0 80                	mov    $0x80,%al
8010522a:	89 f2                	mov    %esi,%edx
8010522c:	ee                   	out    %al,(%dx)
8010522d:	b0 0c                	mov    $0xc,%al
8010522f:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105234:	ee                   	out    %al,(%dx)
80105235:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010523a:	88 c8                	mov    %cl,%al
8010523c:	89 da                	mov    %ebx,%edx
8010523e:	ee                   	out    %al,(%dx)
8010523f:	b0 03                	mov    $0x3,%al
80105241:	89 f2                	mov    %esi,%edx
80105243:	ee                   	out    %al,(%dx)
80105244:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105249:	88 c8                	mov    %cl,%al
8010524b:	ee                   	out    %al,(%dx)
8010524c:	b0 01                	mov    $0x1,%al
8010524e:	89 da                	mov    %ebx,%edx
80105250:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105251:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105256:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105257:	3c ff                	cmp    $0xff,%al
80105259:	74 42                	je     8010529d <uartinit+0x8d>
  uart = 1;
8010525b:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105262:	00 00 00 
80105265:	ba fa 03 00 00       	mov    $0x3fa,%edx
8010526a:	ec                   	in     (%dx),%al
8010526b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105270:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105271:	83 ec 08             	sub    $0x8,%esp
80105274:	6a 00                	push   $0x0
80105276:	6a 04                	push   $0x4
80105278:	e8 28 cd ff ff       	call   80101fa5 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
8010527d:	83 c4 10             	add    $0x10,%esp
80105280:	bb e8 6e 10 80       	mov    $0x80106ee8,%ebx
80105285:	eb 10                	jmp    80105297 <uartinit+0x87>
    uartputc(*p);
80105287:	83 ec 0c             	sub    $0xc,%esp
8010528a:	0f be c0             	movsbl %al,%eax
8010528d:	50                   	push   %eax
8010528e:	e8 36 ff ff ff       	call   801051c9 <uartputc>
  for(p="xv6...\n"; *p; p++)
80105293:	43                   	inc    %ebx
80105294:	83 c4 10             	add    $0x10,%esp
80105297:	8a 03                	mov    (%ebx),%al
80105299:	84 c0                	test   %al,%al
8010529b:	75 ea                	jne    80105287 <uartinit+0x77>
}
8010529d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052a0:	5b                   	pop    %ebx
801052a1:	5e                   	pop    %esi
801052a2:	5d                   	pop    %ebp
801052a3:	c3                   	ret    

801052a4 <uartintr>:

void
uartintr(void)
{
801052a4:	f3 0f 1e fb          	endbr32 
801052a8:	55                   	push   %ebp
801052a9:	89 e5                	mov    %esp,%ebp
801052ab:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801052ae:	68 9c 51 10 80       	push   $0x8010519c
801052b3:	e8 6e b4 ff ff       	call   80100726 <consoleintr>
}
801052b8:	83 c4 10             	add    $0x10,%esp
801052bb:	c9                   	leave  
801052bc:	c3                   	ret    

801052bd <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801052bd:	6a 00                	push   $0x0
  pushl $0
801052bf:	6a 00                	push   $0x0
  jmp alltraps
801052c1:	e9 c5 fb ff ff       	jmp    80104e8b <alltraps>

801052c6 <vector1>:
.globl vector1
vector1:
  pushl $0
801052c6:	6a 00                	push   $0x0
  pushl $1
801052c8:	6a 01                	push   $0x1
  jmp alltraps
801052ca:	e9 bc fb ff ff       	jmp    80104e8b <alltraps>

801052cf <vector2>:
.globl vector2
vector2:
  pushl $0
801052cf:	6a 00                	push   $0x0
  pushl $2
801052d1:	6a 02                	push   $0x2
  jmp alltraps
801052d3:	e9 b3 fb ff ff       	jmp    80104e8b <alltraps>

801052d8 <vector3>:
.globl vector3
vector3:
  pushl $0
801052d8:	6a 00                	push   $0x0
  pushl $3
801052da:	6a 03                	push   $0x3
  jmp alltraps
801052dc:	e9 aa fb ff ff       	jmp    80104e8b <alltraps>

801052e1 <vector4>:
.globl vector4
vector4:
  pushl $0
801052e1:	6a 00                	push   $0x0
  pushl $4
801052e3:	6a 04                	push   $0x4
  jmp alltraps
801052e5:	e9 a1 fb ff ff       	jmp    80104e8b <alltraps>

801052ea <vector5>:
.globl vector5
vector5:
  pushl $0
801052ea:	6a 00                	push   $0x0
  pushl $5
801052ec:	6a 05                	push   $0x5
  jmp alltraps
801052ee:	e9 98 fb ff ff       	jmp    80104e8b <alltraps>

801052f3 <vector6>:
.globl vector6
vector6:
  pushl $0
801052f3:	6a 00                	push   $0x0
  pushl $6
801052f5:	6a 06                	push   $0x6
  jmp alltraps
801052f7:	e9 8f fb ff ff       	jmp    80104e8b <alltraps>

801052fc <vector7>:
.globl vector7
vector7:
  pushl $0
801052fc:	6a 00                	push   $0x0
  pushl $7
801052fe:	6a 07                	push   $0x7
  jmp alltraps
80105300:	e9 86 fb ff ff       	jmp    80104e8b <alltraps>

80105305 <vector8>:
.globl vector8
vector8:
  pushl $8
80105305:	6a 08                	push   $0x8
  jmp alltraps
80105307:	e9 7f fb ff ff       	jmp    80104e8b <alltraps>

8010530c <vector9>:
.globl vector9
vector9:
  pushl $0
8010530c:	6a 00                	push   $0x0
  pushl $9
8010530e:	6a 09                	push   $0x9
  jmp alltraps
80105310:	e9 76 fb ff ff       	jmp    80104e8b <alltraps>

80105315 <vector10>:
.globl vector10
vector10:
  pushl $10
80105315:	6a 0a                	push   $0xa
  jmp alltraps
80105317:	e9 6f fb ff ff       	jmp    80104e8b <alltraps>

8010531c <vector11>:
.globl vector11
vector11:
  pushl $11
8010531c:	6a 0b                	push   $0xb
  jmp alltraps
8010531e:	e9 68 fb ff ff       	jmp    80104e8b <alltraps>

80105323 <vector12>:
.globl vector12
vector12:
  pushl $12
80105323:	6a 0c                	push   $0xc
  jmp alltraps
80105325:	e9 61 fb ff ff       	jmp    80104e8b <alltraps>

8010532a <vector13>:
.globl vector13
vector13:
  pushl $13
8010532a:	6a 0d                	push   $0xd
  jmp alltraps
8010532c:	e9 5a fb ff ff       	jmp    80104e8b <alltraps>

80105331 <vector14>:
.globl vector14
vector14:
  pushl $14
80105331:	6a 0e                	push   $0xe
  jmp alltraps
80105333:	e9 53 fb ff ff       	jmp    80104e8b <alltraps>

80105338 <vector15>:
.globl vector15
vector15:
  pushl $0
80105338:	6a 00                	push   $0x0
  pushl $15
8010533a:	6a 0f                	push   $0xf
  jmp alltraps
8010533c:	e9 4a fb ff ff       	jmp    80104e8b <alltraps>

80105341 <vector16>:
.globl vector16
vector16:
  pushl $0
80105341:	6a 00                	push   $0x0
  pushl $16
80105343:	6a 10                	push   $0x10
  jmp alltraps
80105345:	e9 41 fb ff ff       	jmp    80104e8b <alltraps>

8010534a <vector17>:
.globl vector17
vector17:
  pushl $17
8010534a:	6a 11                	push   $0x11
  jmp alltraps
8010534c:	e9 3a fb ff ff       	jmp    80104e8b <alltraps>

80105351 <vector18>:
.globl vector18
vector18:
  pushl $0
80105351:	6a 00                	push   $0x0
  pushl $18
80105353:	6a 12                	push   $0x12
  jmp alltraps
80105355:	e9 31 fb ff ff       	jmp    80104e8b <alltraps>

8010535a <vector19>:
.globl vector19
vector19:
  pushl $0
8010535a:	6a 00                	push   $0x0
  pushl $19
8010535c:	6a 13                	push   $0x13
  jmp alltraps
8010535e:	e9 28 fb ff ff       	jmp    80104e8b <alltraps>

80105363 <vector20>:
.globl vector20
vector20:
  pushl $0
80105363:	6a 00                	push   $0x0
  pushl $20
80105365:	6a 14                	push   $0x14
  jmp alltraps
80105367:	e9 1f fb ff ff       	jmp    80104e8b <alltraps>

8010536c <vector21>:
.globl vector21
vector21:
  pushl $0
8010536c:	6a 00                	push   $0x0
  pushl $21
8010536e:	6a 15                	push   $0x15
  jmp alltraps
80105370:	e9 16 fb ff ff       	jmp    80104e8b <alltraps>

80105375 <vector22>:
.globl vector22
vector22:
  pushl $0
80105375:	6a 00                	push   $0x0
  pushl $22
80105377:	6a 16                	push   $0x16
  jmp alltraps
80105379:	e9 0d fb ff ff       	jmp    80104e8b <alltraps>

8010537e <vector23>:
.globl vector23
vector23:
  pushl $0
8010537e:	6a 00                	push   $0x0
  pushl $23
80105380:	6a 17                	push   $0x17
  jmp alltraps
80105382:	e9 04 fb ff ff       	jmp    80104e8b <alltraps>

80105387 <vector24>:
.globl vector24
vector24:
  pushl $0
80105387:	6a 00                	push   $0x0
  pushl $24
80105389:	6a 18                	push   $0x18
  jmp alltraps
8010538b:	e9 fb fa ff ff       	jmp    80104e8b <alltraps>

80105390 <vector25>:
.globl vector25
vector25:
  pushl $0
80105390:	6a 00                	push   $0x0
  pushl $25
80105392:	6a 19                	push   $0x19
  jmp alltraps
80105394:	e9 f2 fa ff ff       	jmp    80104e8b <alltraps>

80105399 <vector26>:
.globl vector26
vector26:
  pushl $0
80105399:	6a 00                	push   $0x0
  pushl $26
8010539b:	6a 1a                	push   $0x1a
  jmp alltraps
8010539d:	e9 e9 fa ff ff       	jmp    80104e8b <alltraps>

801053a2 <vector27>:
.globl vector27
vector27:
  pushl $0
801053a2:	6a 00                	push   $0x0
  pushl $27
801053a4:	6a 1b                	push   $0x1b
  jmp alltraps
801053a6:	e9 e0 fa ff ff       	jmp    80104e8b <alltraps>

801053ab <vector28>:
.globl vector28
vector28:
  pushl $0
801053ab:	6a 00                	push   $0x0
  pushl $28
801053ad:	6a 1c                	push   $0x1c
  jmp alltraps
801053af:	e9 d7 fa ff ff       	jmp    80104e8b <alltraps>

801053b4 <vector29>:
.globl vector29
vector29:
  pushl $0
801053b4:	6a 00                	push   $0x0
  pushl $29
801053b6:	6a 1d                	push   $0x1d
  jmp alltraps
801053b8:	e9 ce fa ff ff       	jmp    80104e8b <alltraps>

801053bd <vector30>:
.globl vector30
vector30:
  pushl $0
801053bd:	6a 00                	push   $0x0
  pushl $30
801053bf:	6a 1e                	push   $0x1e
  jmp alltraps
801053c1:	e9 c5 fa ff ff       	jmp    80104e8b <alltraps>

801053c6 <vector31>:
.globl vector31
vector31:
  pushl $0
801053c6:	6a 00                	push   $0x0
  pushl $31
801053c8:	6a 1f                	push   $0x1f
  jmp alltraps
801053ca:	e9 bc fa ff ff       	jmp    80104e8b <alltraps>

801053cf <vector32>:
.globl vector32
vector32:
  pushl $0
801053cf:	6a 00                	push   $0x0
  pushl $32
801053d1:	6a 20                	push   $0x20
  jmp alltraps
801053d3:	e9 b3 fa ff ff       	jmp    80104e8b <alltraps>

801053d8 <vector33>:
.globl vector33
vector33:
  pushl $0
801053d8:	6a 00                	push   $0x0
  pushl $33
801053da:	6a 21                	push   $0x21
  jmp alltraps
801053dc:	e9 aa fa ff ff       	jmp    80104e8b <alltraps>

801053e1 <vector34>:
.globl vector34
vector34:
  pushl $0
801053e1:	6a 00                	push   $0x0
  pushl $34
801053e3:	6a 22                	push   $0x22
  jmp alltraps
801053e5:	e9 a1 fa ff ff       	jmp    80104e8b <alltraps>

801053ea <vector35>:
.globl vector35
vector35:
  pushl $0
801053ea:	6a 00                	push   $0x0
  pushl $35
801053ec:	6a 23                	push   $0x23
  jmp alltraps
801053ee:	e9 98 fa ff ff       	jmp    80104e8b <alltraps>

801053f3 <vector36>:
.globl vector36
vector36:
  pushl $0
801053f3:	6a 00                	push   $0x0
  pushl $36
801053f5:	6a 24                	push   $0x24
  jmp alltraps
801053f7:	e9 8f fa ff ff       	jmp    80104e8b <alltraps>

801053fc <vector37>:
.globl vector37
vector37:
  pushl $0
801053fc:	6a 00                	push   $0x0
  pushl $37
801053fe:	6a 25                	push   $0x25
  jmp alltraps
80105400:	e9 86 fa ff ff       	jmp    80104e8b <alltraps>

80105405 <vector38>:
.globl vector38
vector38:
  pushl $0
80105405:	6a 00                	push   $0x0
  pushl $38
80105407:	6a 26                	push   $0x26
  jmp alltraps
80105409:	e9 7d fa ff ff       	jmp    80104e8b <alltraps>

8010540e <vector39>:
.globl vector39
vector39:
  pushl $0
8010540e:	6a 00                	push   $0x0
  pushl $39
80105410:	6a 27                	push   $0x27
  jmp alltraps
80105412:	e9 74 fa ff ff       	jmp    80104e8b <alltraps>

80105417 <vector40>:
.globl vector40
vector40:
  pushl $0
80105417:	6a 00                	push   $0x0
  pushl $40
80105419:	6a 28                	push   $0x28
  jmp alltraps
8010541b:	e9 6b fa ff ff       	jmp    80104e8b <alltraps>

80105420 <vector41>:
.globl vector41
vector41:
  pushl $0
80105420:	6a 00                	push   $0x0
  pushl $41
80105422:	6a 29                	push   $0x29
  jmp alltraps
80105424:	e9 62 fa ff ff       	jmp    80104e8b <alltraps>

80105429 <vector42>:
.globl vector42
vector42:
  pushl $0
80105429:	6a 00                	push   $0x0
  pushl $42
8010542b:	6a 2a                	push   $0x2a
  jmp alltraps
8010542d:	e9 59 fa ff ff       	jmp    80104e8b <alltraps>

80105432 <vector43>:
.globl vector43
vector43:
  pushl $0
80105432:	6a 00                	push   $0x0
  pushl $43
80105434:	6a 2b                	push   $0x2b
  jmp alltraps
80105436:	e9 50 fa ff ff       	jmp    80104e8b <alltraps>

8010543b <vector44>:
.globl vector44
vector44:
  pushl $0
8010543b:	6a 00                	push   $0x0
  pushl $44
8010543d:	6a 2c                	push   $0x2c
  jmp alltraps
8010543f:	e9 47 fa ff ff       	jmp    80104e8b <alltraps>

80105444 <vector45>:
.globl vector45
vector45:
  pushl $0
80105444:	6a 00                	push   $0x0
  pushl $45
80105446:	6a 2d                	push   $0x2d
  jmp alltraps
80105448:	e9 3e fa ff ff       	jmp    80104e8b <alltraps>

8010544d <vector46>:
.globl vector46
vector46:
  pushl $0
8010544d:	6a 00                	push   $0x0
  pushl $46
8010544f:	6a 2e                	push   $0x2e
  jmp alltraps
80105451:	e9 35 fa ff ff       	jmp    80104e8b <alltraps>

80105456 <vector47>:
.globl vector47
vector47:
  pushl $0
80105456:	6a 00                	push   $0x0
  pushl $47
80105458:	6a 2f                	push   $0x2f
  jmp alltraps
8010545a:	e9 2c fa ff ff       	jmp    80104e8b <alltraps>

8010545f <vector48>:
.globl vector48
vector48:
  pushl $0
8010545f:	6a 00                	push   $0x0
  pushl $48
80105461:	6a 30                	push   $0x30
  jmp alltraps
80105463:	e9 23 fa ff ff       	jmp    80104e8b <alltraps>

80105468 <vector49>:
.globl vector49
vector49:
  pushl $0
80105468:	6a 00                	push   $0x0
  pushl $49
8010546a:	6a 31                	push   $0x31
  jmp alltraps
8010546c:	e9 1a fa ff ff       	jmp    80104e8b <alltraps>

80105471 <vector50>:
.globl vector50
vector50:
  pushl $0
80105471:	6a 00                	push   $0x0
  pushl $50
80105473:	6a 32                	push   $0x32
  jmp alltraps
80105475:	e9 11 fa ff ff       	jmp    80104e8b <alltraps>

8010547a <vector51>:
.globl vector51
vector51:
  pushl $0
8010547a:	6a 00                	push   $0x0
  pushl $51
8010547c:	6a 33                	push   $0x33
  jmp alltraps
8010547e:	e9 08 fa ff ff       	jmp    80104e8b <alltraps>

80105483 <vector52>:
.globl vector52
vector52:
  pushl $0
80105483:	6a 00                	push   $0x0
  pushl $52
80105485:	6a 34                	push   $0x34
  jmp alltraps
80105487:	e9 ff f9 ff ff       	jmp    80104e8b <alltraps>

8010548c <vector53>:
.globl vector53
vector53:
  pushl $0
8010548c:	6a 00                	push   $0x0
  pushl $53
8010548e:	6a 35                	push   $0x35
  jmp alltraps
80105490:	e9 f6 f9 ff ff       	jmp    80104e8b <alltraps>

80105495 <vector54>:
.globl vector54
vector54:
  pushl $0
80105495:	6a 00                	push   $0x0
  pushl $54
80105497:	6a 36                	push   $0x36
  jmp alltraps
80105499:	e9 ed f9 ff ff       	jmp    80104e8b <alltraps>

8010549e <vector55>:
.globl vector55
vector55:
  pushl $0
8010549e:	6a 00                	push   $0x0
  pushl $55
801054a0:	6a 37                	push   $0x37
  jmp alltraps
801054a2:	e9 e4 f9 ff ff       	jmp    80104e8b <alltraps>

801054a7 <vector56>:
.globl vector56
vector56:
  pushl $0
801054a7:	6a 00                	push   $0x0
  pushl $56
801054a9:	6a 38                	push   $0x38
  jmp alltraps
801054ab:	e9 db f9 ff ff       	jmp    80104e8b <alltraps>

801054b0 <vector57>:
.globl vector57
vector57:
  pushl $0
801054b0:	6a 00                	push   $0x0
  pushl $57
801054b2:	6a 39                	push   $0x39
  jmp alltraps
801054b4:	e9 d2 f9 ff ff       	jmp    80104e8b <alltraps>

801054b9 <vector58>:
.globl vector58
vector58:
  pushl $0
801054b9:	6a 00                	push   $0x0
  pushl $58
801054bb:	6a 3a                	push   $0x3a
  jmp alltraps
801054bd:	e9 c9 f9 ff ff       	jmp    80104e8b <alltraps>

801054c2 <vector59>:
.globl vector59
vector59:
  pushl $0
801054c2:	6a 00                	push   $0x0
  pushl $59
801054c4:	6a 3b                	push   $0x3b
  jmp alltraps
801054c6:	e9 c0 f9 ff ff       	jmp    80104e8b <alltraps>

801054cb <vector60>:
.globl vector60
vector60:
  pushl $0
801054cb:	6a 00                	push   $0x0
  pushl $60
801054cd:	6a 3c                	push   $0x3c
  jmp alltraps
801054cf:	e9 b7 f9 ff ff       	jmp    80104e8b <alltraps>

801054d4 <vector61>:
.globl vector61
vector61:
  pushl $0
801054d4:	6a 00                	push   $0x0
  pushl $61
801054d6:	6a 3d                	push   $0x3d
  jmp alltraps
801054d8:	e9 ae f9 ff ff       	jmp    80104e8b <alltraps>

801054dd <vector62>:
.globl vector62
vector62:
  pushl $0
801054dd:	6a 00                	push   $0x0
  pushl $62
801054df:	6a 3e                	push   $0x3e
  jmp alltraps
801054e1:	e9 a5 f9 ff ff       	jmp    80104e8b <alltraps>

801054e6 <vector63>:
.globl vector63
vector63:
  pushl $0
801054e6:	6a 00                	push   $0x0
  pushl $63
801054e8:	6a 3f                	push   $0x3f
  jmp alltraps
801054ea:	e9 9c f9 ff ff       	jmp    80104e8b <alltraps>

801054ef <vector64>:
.globl vector64
vector64:
  pushl $0
801054ef:	6a 00                	push   $0x0
  pushl $64
801054f1:	6a 40                	push   $0x40
  jmp alltraps
801054f3:	e9 93 f9 ff ff       	jmp    80104e8b <alltraps>

801054f8 <vector65>:
.globl vector65
vector65:
  pushl $0
801054f8:	6a 00                	push   $0x0
  pushl $65
801054fa:	6a 41                	push   $0x41
  jmp alltraps
801054fc:	e9 8a f9 ff ff       	jmp    80104e8b <alltraps>

80105501 <vector66>:
.globl vector66
vector66:
  pushl $0
80105501:	6a 00                	push   $0x0
  pushl $66
80105503:	6a 42                	push   $0x42
  jmp alltraps
80105505:	e9 81 f9 ff ff       	jmp    80104e8b <alltraps>

8010550a <vector67>:
.globl vector67
vector67:
  pushl $0
8010550a:	6a 00                	push   $0x0
  pushl $67
8010550c:	6a 43                	push   $0x43
  jmp alltraps
8010550e:	e9 78 f9 ff ff       	jmp    80104e8b <alltraps>

80105513 <vector68>:
.globl vector68
vector68:
  pushl $0
80105513:	6a 00                	push   $0x0
  pushl $68
80105515:	6a 44                	push   $0x44
  jmp alltraps
80105517:	e9 6f f9 ff ff       	jmp    80104e8b <alltraps>

8010551c <vector69>:
.globl vector69
vector69:
  pushl $0
8010551c:	6a 00                	push   $0x0
  pushl $69
8010551e:	6a 45                	push   $0x45
  jmp alltraps
80105520:	e9 66 f9 ff ff       	jmp    80104e8b <alltraps>

80105525 <vector70>:
.globl vector70
vector70:
  pushl $0
80105525:	6a 00                	push   $0x0
  pushl $70
80105527:	6a 46                	push   $0x46
  jmp alltraps
80105529:	e9 5d f9 ff ff       	jmp    80104e8b <alltraps>

8010552e <vector71>:
.globl vector71
vector71:
  pushl $0
8010552e:	6a 00                	push   $0x0
  pushl $71
80105530:	6a 47                	push   $0x47
  jmp alltraps
80105532:	e9 54 f9 ff ff       	jmp    80104e8b <alltraps>

80105537 <vector72>:
.globl vector72
vector72:
  pushl $0
80105537:	6a 00                	push   $0x0
  pushl $72
80105539:	6a 48                	push   $0x48
  jmp alltraps
8010553b:	e9 4b f9 ff ff       	jmp    80104e8b <alltraps>

80105540 <vector73>:
.globl vector73
vector73:
  pushl $0
80105540:	6a 00                	push   $0x0
  pushl $73
80105542:	6a 49                	push   $0x49
  jmp alltraps
80105544:	e9 42 f9 ff ff       	jmp    80104e8b <alltraps>

80105549 <vector74>:
.globl vector74
vector74:
  pushl $0
80105549:	6a 00                	push   $0x0
  pushl $74
8010554b:	6a 4a                	push   $0x4a
  jmp alltraps
8010554d:	e9 39 f9 ff ff       	jmp    80104e8b <alltraps>

80105552 <vector75>:
.globl vector75
vector75:
  pushl $0
80105552:	6a 00                	push   $0x0
  pushl $75
80105554:	6a 4b                	push   $0x4b
  jmp alltraps
80105556:	e9 30 f9 ff ff       	jmp    80104e8b <alltraps>

8010555b <vector76>:
.globl vector76
vector76:
  pushl $0
8010555b:	6a 00                	push   $0x0
  pushl $76
8010555d:	6a 4c                	push   $0x4c
  jmp alltraps
8010555f:	e9 27 f9 ff ff       	jmp    80104e8b <alltraps>

80105564 <vector77>:
.globl vector77
vector77:
  pushl $0
80105564:	6a 00                	push   $0x0
  pushl $77
80105566:	6a 4d                	push   $0x4d
  jmp alltraps
80105568:	e9 1e f9 ff ff       	jmp    80104e8b <alltraps>

8010556d <vector78>:
.globl vector78
vector78:
  pushl $0
8010556d:	6a 00                	push   $0x0
  pushl $78
8010556f:	6a 4e                	push   $0x4e
  jmp alltraps
80105571:	e9 15 f9 ff ff       	jmp    80104e8b <alltraps>

80105576 <vector79>:
.globl vector79
vector79:
  pushl $0
80105576:	6a 00                	push   $0x0
  pushl $79
80105578:	6a 4f                	push   $0x4f
  jmp alltraps
8010557a:	e9 0c f9 ff ff       	jmp    80104e8b <alltraps>

8010557f <vector80>:
.globl vector80
vector80:
  pushl $0
8010557f:	6a 00                	push   $0x0
  pushl $80
80105581:	6a 50                	push   $0x50
  jmp alltraps
80105583:	e9 03 f9 ff ff       	jmp    80104e8b <alltraps>

80105588 <vector81>:
.globl vector81
vector81:
  pushl $0
80105588:	6a 00                	push   $0x0
  pushl $81
8010558a:	6a 51                	push   $0x51
  jmp alltraps
8010558c:	e9 fa f8 ff ff       	jmp    80104e8b <alltraps>

80105591 <vector82>:
.globl vector82
vector82:
  pushl $0
80105591:	6a 00                	push   $0x0
  pushl $82
80105593:	6a 52                	push   $0x52
  jmp alltraps
80105595:	e9 f1 f8 ff ff       	jmp    80104e8b <alltraps>

8010559a <vector83>:
.globl vector83
vector83:
  pushl $0
8010559a:	6a 00                	push   $0x0
  pushl $83
8010559c:	6a 53                	push   $0x53
  jmp alltraps
8010559e:	e9 e8 f8 ff ff       	jmp    80104e8b <alltraps>

801055a3 <vector84>:
.globl vector84
vector84:
  pushl $0
801055a3:	6a 00                	push   $0x0
  pushl $84
801055a5:	6a 54                	push   $0x54
  jmp alltraps
801055a7:	e9 df f8 ff ff       	jmp    80104e8b <alltraps>

801055ac <vector85>:
.globl vector85
vector85:
  pushl $0
801055ac:	6a 00                	push   $0x0
  pushl $85
801055ae:	6a 55                	push   $0x55
  jmp alltraps
801055b0:	e9 d6 f8 ff ff       	jmp    80104e8b <alltraps>

801055b5 <vector86>:
.globl vector86
vector86:
  pushl $0
801055b5:	6a 00                	push   $0x0
  pushl $86
801055b7:	6a 56                	push   $0x56
  jmp alltraps
801055b9:	e9 cd f8 ff ff       	jmp    80104e8b <alltraps>

801055be <vector87>:
.globl vector87
vector87:
  pushl $0
801055be:	6a 00                	push   $0x0
  pushl $87
801055c0:	6a 57                	push   $0x57
  jmp alltraps
801055c2:	e9 c4 f8 ff ff       	jmp    80104e8b <alltraps>

801055c7 <vector88>:
.globl vector88
vector88:
  pushl $0
801055c7:	6a 00                	push   $0x0
  pushl $88
801055c9:	6a 58                	push   $0x58
  jmp alltraps
801055cb:	e9 bb f8 ff ff       	jmp    80104e8b <alltraps>

801055d0 <vector89>:
.globl vector89
vector89:
  pushl $0
801055d0:	6a 00                	push   $0x0
  pushl $89
801055d2:	6a 59                	push   $0x59
  jmp alltraps
801055d4:	e9 b2 f8 ff ff       	jmp    80104e8b <alltraps>

801055d9 <vector90>:
.globl vector90
vector90:
  pushl $0
801055d9:	6a 00                	push   $0x0
  pushl $90
801055db:	6a 5a                	push   $0x5a
  jmp alltraps
801055dd:	e9 a9 f8 ff ff       	jmp    80104e8b <alltraps>

801055e2 <vector91>:
.globl vector91
vector91:
  pushl $0
801055e2:	6a 00                	push   $0x0
  pushl $91
801055e4:	6a 5b                	push   $0x5b
  jmp alltraps
801055e6:	e9 a0 f8 ff ff       	jmp    80104e8b <alltraps>

801055eb <vector92>:
.globl vector92
vector92:
  pushl $0
801055eb:	6a 00                	push   $0x0
  pushl $92
801055ed:	6a 5c                	push   $0x5c
  jmp alltraps
801055ef:	e9 97 f8 ff ff       	jmp    80104e8b <alltraps>

801055f4 <vector93>:
.globl vector93
vector93:
  pushl $0
801055f4:	6a 00                	push   $0x0
  pushl $93
801055f6:	6a 5d                	push   $0x5d
  jmp alltraps
801055f8:	e9 8e f8 ff ff       	jmp    80104e8b <alltraps>

801055fd <vector94>:
.globl vector94
vector94:
  pushl $0
801055fd:	6a 00                	push   $0x0
  pushl $94
801055ff:	6a 5e                	push   $0x5e
  jmp alltraps
80105601:	e9 85 f8 ff ff       	jmp    80104e8b <alltraps>

80105606 <vector95>:
.globl vector95
vector95:
  pushl $0
80105606:	6a 00                	push   $0x0
  pushl $95
80105608:	6a 5f                	push   $0x5f
  jmp alltraps
8010560a:	e9 7c f8 ff ff       	jmp    80104e8b <alltraps>

8010560f <vector96>:
.globl vector96
vector96:
  pushl $0
8010560f:	6a 00                	push   $0x0
  pushl $96
80105611:	6a 60                	push   $0x60
  jmp alltraps
80105613:	e9 73 f8 ff ff       	jmp    80104e8b <alltraps>

80105618 <vector97>:
.globl vector97
vector97:
  pushl $0
80105618:	6a 00                	push   $0x0
  pushl $97
8010561a:	6a 61                	push   $0x61
  jmp alltraps
8010561c:	e9 6a f8 ff ff       	jmp    80104e8b <alltraps>

80105621 <vector98>:
.globl vector98
vector98:
  pushl $0
80105621:	6a 00                	push   $0x0
  pushl $98
80105623:	6a 62                	push   $0x62
  jmp alltraps
80105625:	e9 61 f8 ff ff       	jmp    80104e8b <alltraps>

8010562a <vector99>:
.globl vector99
vector99:
  pushl $0
8010562a:	6a 00                	push   $0x0
  pushl $99
8010562c:	6a 63                	push   $0x63
  jmp alltraps
8010562e:	e9 58 f8 ff ff       	jmp    80104e8b <alltraps>

80105633 <vector100>:
.globl vector100
vector100:
  pushl $0
80105633:	6a 00                	push   $0x0
  pushl $100
80105635:	6a 64                	push   $0x64
  jmp alltraps
80105637:	e9 4f f8 ff ff       	jmp    80104e8b <alltraps>

8010563c <vector101>:
.globl vector101
vector101:
  pushl $0
8010563c:	6a 00                	push   $0x0
  pushl $101
8010563e:	6a 65                	push   $0x65
  jmp alltraps
80105640:	e9 46 f8 ff ff       	jmp    80104e8b <alltraps>

80105645 <vector102>:
.globl vector102
vector102:
  pushl $0
80105645:	6a 00                	push   $0x0
  pushl $102
80105647:	6a 66                	push   $0x66
  jmp alltraps
80105649:	e9 3d f8 ff ff       	jmp    80104e8b <alltraps>

8010564e <vector103>:
.globl vector103
vector103:
  pushl $0
8010564e:	6a 00                	push   $0x0
  pushl $103
80105650:	6a 67                	push   $0x67
  jmp alltraps
80105652:	e9 34 f8 ff ff       	jmp    80104e8b <alltraps>

80105657 <vector104>:
.globl vector104
vector104:
  pushl $0
80105657:	6a 00                	push   $0x0
  pushl $104
80105659:	6a 68                	push   $0x68
  jmp alltraps
8010565b:	e9 2b f8 ff ff       	jmp    80104e8b <alltraps>

80105660 <vector105>:
.globl vector105
vector105:
  pushl $0
80105660:	6a 00                	push   $0x0
  pushl $105
80105662:	6a 69                	push   $0x69
  jmp alltraps
80105664:	e9 22 f8 ff ff       	jmp    80104e8b <alltraps>

80105669 <vector106>:
.globl vector106
vector106:
  pushl $0
80105669:	6a 00                	push   $0x0
  pushl $106
8010566b:	6a 6a                	push   $0x6a
  jmp alltraps
8010566d:	e9 19 f8 ff ff       	jmp    80104e8b <alltraps>

80105672 <vector107>:
.globl vector107
vector107:
  pushl $0
80105672:	6a 00                	push   $0x0
  pushl $107
80105674:	6a 6b                	push   $0x6b
  jmp alltraps
80105676:	e9 10 f8 ff ff       	jmp    80104e8b <alltraps>

8010567b <vector108>:
.globl vector108
vector108:
  pushl $0
8010567b:	6a 00                	push   $0x0
  pushl $108
8010567d:	6a 6c                	push   $0x6c
  jmp alltraps
8010567f:	e9 07 f8 ff ff       	jmp    80104e8b <alltraps>

80105684 <vector109>:
.globl vector109
vector109:
  pushl $0
80105684:	6a 00                	push   $0x0
  pushl $109
80105686:	6a 6d                	push   $0x6d
  jmp alltraps
80105688:	e9 fe f7 ff ff       	jmp    80104e8b <alltraps>

8010568d <vector110>:
.globl vector110
vector110:
  pushl $0
8010568d:	6a 00                	push   $0x0
  pushl $110
8010568f:	6a 6e                	push   $0x6e
  jmp alltraps
80105691:	e9 f5 f7 ff ff       	jmp    80104e8b <alltraps>

80105696 <vector111>:
.globl vector111
vector111:
  pushl $0
80105696:	6a 00                	push   $0x0
  pushl $111
80105698:	6a 6f                	push   $0x6f
  jmp alltraps
8010569a:	e9 ec f7 ff ff       	jmp    80104e8b <alltraps>

8010569f <vector112>:
.globl vector112
vector112:
  pushl $0
8010569f:	6a 00                	push   $0x0
  pushl $112
801056a1:	6a 70                	push   $0x70
  jmp alltraps
801056a3:	e9 e3 f7 ff ff       	jmp    80104e8b <alltraps>

801056a8 <vector113>:
.globl vector113
vector113:
  pushl $0
801056a8:	6a 00                	push   $0x0
  pushl $113
801056aa:	6a 71                	push   $0x71
  jmp alltraps
801056ac:	e9 da f7 ff ff       	jmp    80104e8b <alltraps>

801056b1 <vector114>:
.globl vector114
vector114:
  pushl $0
801056b1:	6a 00                	push   $0x0
  pushl $114
801056b3:	6a 72                	push   $0x72
  jmp alltraps
801056b5:	e9 d1 f7 ff ff       	jmp    80104e8b <alltraps>

801056ba <vector115>:
.globl vector115
vector115:
  pushl $0
801056ba:	6a 00                	push   $0x0
  pushl $115
801056bc:	6a 73                	push   $0x73
  jmp alltraps
801056be:	e9 c8 f7 ff ff       	jmp    80104e8b <alltraps>

801056c3 <vector116>:
.globl vector116
vector116:
  pushl $0
801056c3:	6a 00                	push   $0x0
  pushl $116
801056c5:	6a 74                	push   $0x74
  jmp alltraps
801056c7:	e9 bf f7 ff ff       	jmp    80104e8b <alltraps>

801056cc <vector117>:
.globl vector117
vector117:
  pushl $0
801056cc:	6a 00                	push   $0x0
  pushl $117
801056ce:	6a 75                	push   $0x75
  jmp alltraps
801056d0:	e9 b6 f7 ff ff       	jmp    80104e8b <alltraps>

801056d5 <vector118>:
.globl vector118
vector118:
  pushl $0
801056d5:	6a 00                	push   $0x0
  pushl $118
801056d7:	6a 76                	push   $0x76
  jmp alltraps
801056d9:	e9 ad f7 ff ff       	jmp    80104e8b <alltraps>

801056de <vector119>:
.globl vector119
vector119:
  pushl $0
801056de:	6a 00                	push   $0x0
  pushl $119
801056e0:	6a 77                	push   $0x77
  jmp alltraps
801056e2:	e9 a4 f7 ff ff       	jmp    80104e8b <alltraps>

801056e7 <vector120>:
.globl vector120
vector120:
  pushl $0
801056e7:	6a 00                	push   $0x0
  pushl $120
801056e9:	6a 78                	push   $0x78
  jmp alltraps
801056eb:	e9 9b f7 ff ff       	jmp    80104e8b <alltraps>

801056f0 <vector121>:
.globl vector121
vector121:
  pushl $0
801056f0:	6a 00                	push   $0x0
  pushl $121
801056f2:	6a 79                	push   $0x79
  jmp alltraps
801056f4:	e9 92 f7 ff ff       	jmp    80104e8b <alltraps>

801056f9 <vector122>:
.globl vector122
vector122:
  pushl $0
801056f9:	6a 00                	push   $0x0
  pushl $122
801056fb:	6a 7a                	push   $0x7a
  jmp alltraps
801056fd:	e9 89 f7 ff ff       	jmp    80104e8b <alltraps>

80105702 <vector123>:
.globl vector123
vector123:
  pushl $0
80105702:	6a 00                	push   $0x0
  pushl $123
80105704:	6a 7b                	push   $0x7b
  jmp alltraps
80105706:	e9 80 f7 ff ff       	jmp    80104e8b <alltraps>

8010570b <vector124>:
.globl vector124
vector124:
  pushl $0
8010570b:	6a 00                	push   $0x0
  pushl $124
8010570d:	6a 7c                	push   $0x7c
  jmp alltraps
8010570f:	e9 77 f7 ff ff       	jmp    80104e8b <alltraps>

80105714 <vector125>:
.globl vector125
vector125:
  pushl $0
80105714:	6a 00                	push   $0x0
  pushl $125
80105716:	6a 7d                	push   $0x7d
  jmp alltraps
80105718:	e9 6e f7 ff ff       	jmp    80104e8b <alltraps>

8010571d <vector126>:
.globl vector126
vector126:
  pushl $0
8010571d:	6a 00                	push   $0x0
  pushl $126
8010571f:	6a 7e                	push   $0x7e
  jmp alltraps
80105721:	e9 65 f7 ff ff       	jmp    80104e8b <alltraps>

80105726 <vector127>:
.globl vector127
vector127:
  pushl $0
80105726:	6a 00                	push   $0x0
  pushl $127
80105728:	6a 7f                	push   $0x7f
  jmp alltraps
8010572a:	e9 5c f7 ff ff       	jmp    80104e8b <alltraps>

8010572f <vector128>:
.globl vector128
vector128:
  pushl $0
8010572f:	6a 00                	push   $0x0
  pushl $128
80105731:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105736:	e9 50 f7 ff ff       	jmp    80104e8b <alltraps>

8010573b <vector129>:
.globl vector129
vector129:
  pushl $0
8010573b:	6a 00                	push   $0x0
  pushl $129
8010573d:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105742:	e9 44 f7 ff ff       	jmp    80104e8b <alltraps>

80105747 <vector130>:
.globl vector130
vector130:
  pushl $0
80105747:	6a 00                	push   $0x0
  pushl $130
80105749:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010574e:	e9 38 f7 ff ff       	jmp    80104e8b <alltraps>

80105753 <vector131>:
.globl vector131
vector131:
  pushl $0
80105753:	6a 00                	push   $0x0
  pushl $131
80105755:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010575a:	e9 2c f7 ff ff       	jmp    80104e8b <alltraps>

8010575f <vector132>:
.globl vector132
vector132:
  pushl $0
8010575f:	6a 00                	push   $0x0
  pushl $132
80105761:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105766:	e9 20 f7 ff ff       	jmp    80104e8b <alltraps>

8010576b <vector133>:
.globl vector133
vector133:
  pushl $0
8010576b:	6a 00                	push   $0x0
  pushl $133
8010576d:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105772:	e9 14 f7 ff ff       	jmp    80104e8b <alltraps>

80105777 <vector134>:
.globl vector134
vector134:
  pushl $0
80105777:	6a 00                	push   $0x0
  pushl $134
80105779:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010577e:	e9 08 f7 ff ff       	jmp    80104e8b <alltraps>

80105783 <vector135>:
.globl vector135
vector135:
  pushl $0
80105783:	6a 00                	push   $0x0
  pushl $135
80105785:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010578a:	e9 fc f6 ff ff       	jmp    80104e8b <alltraps>

8010578f <vector136>:
.globl vector136
vector136:
  pushl $0
8010578f:	6a 00                	push   $0x0
  pushl $136
80105791:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105796:	e9 f0 f6 ff ff       	jmp    80104e8b <alltraps>

8010579b <vector137>:
.globl vector137
vector137:
  pushl $0
8010579b:	6a 00                	push   $0x0
  pushl $137
8010579d:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801057a2:	e9 e4 f6 ff ff       	jmp    80104e8b <alltraps>

801057a7 <vector138>:
.globl vector138
vector138:
  pushl $0
801057a7:	6a 00                	push   $0x0
  pushl $138
801057a9:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801057ae:	e9 d8 f6 ff ff       	jmp    80104e8b <alltraps>

801057b3 <vector139>:
.globl vector139
vector139:
  pushl $0
801057b3:	6a 00                	push   $0x0
  pushl $139
801057b5:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801057ba:	e9 cc f6 ff ff       	jmp    80104e8b <alltraps>

801057bf <vector140>:
.globl vector140
vector140:
  pushl $0
801057bf:	6a 00                	push   $0x0
  pushl $140
801057c1:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801057c6:	e9 c0 f6 ff ff       	jmp    80104e8b <alltraps>

801057cb <vector141>:
.globl vector141
vector141:
  pushl $0
801057cb:	6a 00                	push   $0x0
  pushl $141
801057cd:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801057d2:	e9 b4 f6 ff ff       	jmp    80104e8b <alltraps>

801057d7 <vector142>:
.globl vector142
vector142:
  pushl $0
801057d7:	6a 00                	push   $0x0
  pushl $142
801057d9:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801057de:	e9 a8 f6 ff ff       	jmp    80104e8b <alltraps>

801057e3 <vector143>:
.globl vector143
vector143:
  pushl $0
801057e3:	6a 00                	push   $0x0
  pushl $143
801057e5:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801057ea:	e9 9c f6 ff ff       	jmp    80104e8b <alltraps>

801057ef <vector144>:
.globl vector144
vector144:
  pushl $0
801057ef:	6a 00                	push   $0x0
  pushl $144
801057f1:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801057f6:	e9 90 f6 ff ff       	jmp    80104e8b <alltraps>

801057fb <vector145>:
.globl vector145
vector145:
  pushl $0
801057fb:	6a 00                	push   $0x0
  pushl $145
801057fd:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105802:	e9 84 f6 ff ff       	jmp    80104e8b <alltraps>

80105807 <vector146>:
.globl vector146
vector146:
  pushl $0
80105807:	6a 00                	push   $0x0
  pushl $146
80105809:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010580e:	e9 78 f6 ff ff       	jmp    80104e8b <alltraps>

80105813 <vector147>:
.globl vector147
vector147:
  pushl $0
80105813:	6a 00                	push   $0x0
  pushl $147
80105815:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010581a:	e9 6c f6 ff ff       	jmp    80104e8b <alltraps>

8010581f <vector148>:
.globl vector148
vector148:
  pushl $0
8010581f:	6a 00                	push   $0x0
  pushl $148
80105821:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105826:	e9 60 f6 ff ff       	jmp    80104e8b <alltraps>

8010582b <vector149>:
.globl vector149
vector149:
  pushl $0
8010582b:	6a 00                	push   $0x0
  pushl $149
8010582d:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105832:	e9 54 f6 ff ff       	jmp    80104e8b <alltraps>

80105837 <vector150>:
.globl vector150
vector150:
  pushl $0
80105837:	6a 00                	push   $0x0
  pushl $150
80105839:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010583e:	e9 48 f6 ff ff       	jmp    80104e8b <alltraps>

80105843 <vector151>:
.globl vector151
vector151:
  pushl $0
80105843:	6a 00                	push   $0x0
  pushl $151
80105845:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010584a:	e9 3c f6 ff ff       	jmp    80104e8b <alltraps>

8010584f <vector152>:
.globl vector152
vector152:
  pushl $0
8010584f:	6a 00                	push   $0x0
  pushl $152
80105851:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105856:	e9 30 f6 ff ff       	jmp    80104e8b <alltraps>

8010585b <vector153>:
.globl vector153
vector153:
  pushl $0
8010585b:	6a 00                	push   $0x0
  pushl $153
8010585d:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105862:	e9 24 f6 ff ff       	jmp    80104e8b <alltraps>

80105867 <vector154>:
.globl vector154
vector154:
  pushl $0
80105867:	6a 00                	push   $0x0
  pushl $154
80105869:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010586e:	e9 18 f6 ff ff       	jmp    80104e8b <alltraps>

80105873 <vector155>:
.globl vector155
vector155:
  pushl $0
80105873:	6a 00                	push   $0x0
  pushl $155
80105875:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
8010587a:	e9 0c f6 ff ff       	jmp    80104e8b <alltraps>

8010587f <vector156>:
.globl vector156
vector156:
  pushl $0
8010587f:	6a 00                	push   $0x0
  pushl $156
80105881:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105886:	e9 00 f6 ff ff       	jmp    80104e8b <alltraps>

8010588b <vector157>:
.globl vector157
vector157:
  pushl $0
8010588b:	6a 00                	push   $0x0
  pushl $157
8010588d:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105892:	e9 f4 f5 ff ff       	jmp    80104e8b <alltraps>

80105897 <vector158>:
.globl vector158
vector158:
  pushl $0
80105897:	6a 00                	push   $0x0
  pushl $158
80105899:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010589e:	e9 e8 f5 ff ff       	jmp    80104e8b <alltraps>

801058a3 <vector159>:
.globl vector159
vector159:
  pushl $0
801058a3:	6a 00                	push   $0x0
  pushl $159
801058a5:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801058aa:	e9 dc f5 ff ff       	jmp    80104e8b <alltraps>

801058af <vector160>:
.globl vector160
vector160:
  pushl $0
801058af:	6a 00                	push   $0x0
  pushl $160
801058b1:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801058b6:	e9 d0 f5 ff ff       	jmp    80104e8b <alltraps>

801058bb <vector161>:
.globl vector161
vector161:
  pushl $0
801058bb:	6a 00                	push   $0x0
  pushl $161
801058bd:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801058c2:	e9 c4 f5 ff ff       	jmp    80104e8b <alltraps>

801058c7 <vector162>:
.globl vector162
vector162:
  pushl $0
801058c7:	6a 00                	push   $0x0
  pushl $162
801058c9:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801058ce:	e9 b8 f5 ff ff       	jmp    80104e8b <alltraps>

801058d3 <vector163>:
.globl vector163
vector163:
  pushl $0
801058d3:	6a 00                	push   $0x0
  pushl $163
801058d5:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801058da:	e9 ac f5 ff ff       	jmp    80104e8b <alltraps>

801058df <vector164>:
.globl vector164
vector164:
  pushl $0
801058df:	6a 00                	push   $0x0
  pushl $164
801058e1:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801058e6:	e9 a0 f5 ff ff       	jmp    80104e8b <alltraps>

801058eb <vector165>:
.globl vector165
vector165:
  pushl $0
801058eb:	6a 00                	push   $0x0
  pushl $165
801058ed:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801058f2:	e9 94 f5 ff ff       	jmp    80104e8b <alltraps>

801058f7 <vector166>:
.globl vector166
vector166:
  pushl $0
801058f7:	6a 00                	push   $0x0
  pushl $166
801058f9:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801058fe:	e9 88 f5 ff ff       	jmp    80104e8b <alltraps>

80105903 <vector167>:
.globl vector167
vector167:
  pushl $0
80105903:	6a 00                	push   $0x0
  pushl $167
80105905:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010590a:	e9 7c f5 ff ff       	jmp    80104e8b <alltraps>

8010590f <vector168>:
.globl vector168
vector168:
  pushl $0
8010590f:	6a 00                	push   $0x0
  pushl $168
80105911:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105916:	e9 70 f5 ff ff       	jmp    80104e8b <alltraps>

8010591b <vector169>:
.globl vector169
vector169:
  pushl $0
8010591b:	6a 00                	push   $0x0
  pushl $169
8010591d:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105922:	e9 64 f5 ff ff       	jmp    80104e8b <alltraps>

80105927 <vector170>:
.globl vector170
vector170:
  pushl $0
80105927:	6a 00                	push   $0x0
  pushl $170
80105929:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010592e:	e9 58 f5 ff ff       	jmp    80104e8b <alltraps>

80105933 <vector171>:
.globl vector171
vector171:
  pushl $0
80105933:	6a 00                	push   $0x0
  pushl $171
80105935:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010593a:	e9 4c f5 ff ff       	jmp    80104e8b <alltraps>

8010593f <vector172>:
.globl vector172
vector172:
  pushl $0
8010593f:	6a 00                	push   $0x0
  pushl $172
80105941:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105946:	e9 40 f5 ff ff       	jmp    80104e8b <alltraps>

8010594b <vector173>:
.globl vector173
vector173:
  pushl $0
8010594b:	6a 00                	push   $0x0
  pushl $173
8010594d:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105952:	e9 34 f5 ff ff       	jmp    80104e8b <alltraps>

80105957 <vector174>:
.globl vector174
vector174:
  pushl $0
80105957:	6a 00                	push   $0x0
  pushl $174
80105959:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010595e:	e9 28 f5 ff ff       	jmp    80104e8b <alltraps>

80105963 <vector175>:
.globl vector175
vector175:
  pushl $0
80105963:	6a 00                	push   $0x0
  pushl $175
80105965:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010596a:	e9 1c f5 ff ff       	jmp    80104e8b <alltraps>

8010596f <vector176>:
.globl vector176
vector176:
  pushl $0
8010596f:	6a 00                	push   $0x0
  pushl $176
80105971:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80105976:	e9 10 f5 ff ff       	jmp    80104e8b <alltraps>

8010597b <vector177>:
.globl vector177
vector177:
  pushl $0
8010597b:	6a 00                	push   $0x0
  pushl $177
8010597d:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80105982:	e9 04 f5 ff ff       	jmp    80104e8b <alltraps>

80105987 <vector178>:
.globl vector178
vector178:
  pushl $0
80105987:	6a 00                	push   $0x0
  pushl $178
80105989:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010598e:	e9 f8 f4 ff ff       	jmp    80104e8b <alltraps>

80105993 <vector179>:
.globl vector179
vector179:
  pushl $0
80105993:	6a 00                	push   $0x0
  pushl $179
80105995:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010599a:	e9 ec f4 ff ff       	jmp    80104e8b <alltraps>

8010599f <vector180>:
.globl vector180
vector180:
  pushl $0
8010599f:	6a 00                	push   $0x0
  pushl $180
801059a1:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801059a6:	e9 e0 f4 ff ff       	jmp    80104e8b <alltraps>

801059ab <vector181>:
.globl vector181
vector181:
  pushl $0
801059ab:	6a 00                	push   $0x0
  pushl $181
801059ad:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801059b2:	e9 d4 f4 ff ff       	jmp    80104e8b <alltraps>

801059b7 <vector182>:
.globl vector182
vector182:
  pushl $0
801059b7:	6a 00                	push   $0x0
  pushl $182
801059b9:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801059be:	e9 c8 f4 ff ff       	jmp    80104e8b <alltraps>

801059c3 <vector183>:
.globl vector183
vector183:
  pushl $0
801059c3:	6a 00                	push   $0x0
  pushl $183
801059c5:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801059ca:	e9 bc f4 ff ff       	jmp    80104e8b <alltraps>

801059cf <vector184>:
.globl vector184
vector184:
  pushl $0
801059cf:	6a 00                	push   $0x0
  pushl $184
801059d1:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801059d6:	e9 b0 f4 ff ff       	jmp    80104e8b <alltraps>

801059db <vector185>:
.globl vector185
vector185:
  pushl $0
801059db:	6a 00                	push   $0x0
  pushl $185
801059dd:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801059e2:	e9 a4 f4 ff ff       	jmp    80104e8b <alltraps>

801059e7 <vector186>:
.globl vector186
vector186:
  pushl $0
801059e7:	6a 00                	push   $0x0
  pushl $186
801059e9:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801059ee:	e9 98 f4 ff ff       	jmp    80104e8b <alltraps>

801059f3 <vector187>:
.globl vector187
vector187:
  pushl $0
801059f3:	6a 00                	push   $0x0
  pushl $187
801059f5:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801059fa:	e9 8c f4 ff ff       	jmp    80104e8b <alltraps>

801059ff <vector188>:
.globl vector188
vector188:
  pushl $0
801059ff:	6a 00                	push   $0x0
  pushl $188
80105a01:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105a06:	e9 80 f4 ff ff       	jmp    80104e8b <alltraps>

80105a0b <vector189>:
.globl vector189
vector189:
  pushl $0
80105a0b:	6a 00                	push   $0x0
  pushl $189
80105a0d:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105a12:	e9 74 f4 ff ff       	jmp    80104e8b <alltraps>

80105a17 <vector190>:
.globl vector190
vector190:
  pushl $0
80105a17:	6a 00                	push   $0x0
  pushl $190
80105a19:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105a1e:	e9 68 f4 ff ff       	jmp    80104e8b <alltraps>

80105a23 <vector191>:
.globl vector191
vector191:
  pushl $0
80105a23:	6a 00                	push   $0x0
  pushl $191
80105a25:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105a2a:	e9 5c f4 ff ff       	jmp    80104e8b <alltraps>

80105a2f <vector192>:
.globl vector192
vector192:
  pushl $0
80105a2f:	6a 00                	push   $0x0
  pushl $192
80105a31:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105a36:	e9 50 f4 ff ff       	jmp    80104e8b <alltraps>

80105a3b <vector193>:
.globl vector193
vector193:
  pushl $0
80105a3b:	6a 00                	push   $0x0
  pushl $193
80105a3d:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105a42:	e9 44 f4 ff ff       	jmp    80104e8b <alltraps>

80105a47 <vector194>:
.globl vector194
vector194:
  pushl $0
80105a47:	6a 00                	push   $0x0
  pushl $194
80105a49:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105a4e:	e9 38 f4 ff ff       	jmp    80104e8b <alltraps>

80105a53 <vector195>:
.globl vector195
vector195:
  pushl $0
80105a53:	6a 00                	push   $0x0
  pushl $195
80105a55:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105a5a:	e9 2c f4 ff ff       	jmp    80104e8b <alltraps>

80105a5f <vector196>:
.globl vector196
vector196:
  pushl $0
80105a5f:	6a 00                	push   $0x0
  pushl $196
80105a61:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105a66:	e9 20 f4 ff ff       	jmp    80104e8b <alltraps>

80105a6b <vector197>:
.globl vector197
vector197:
  pushl $0
80105a6b:	6a 00                	push   $0x0
  pushl $197
80105a6d:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105a72:	e9 14 f4 ff ff       	jmp    80104e8b <alltraps>

80105a77 <vector198>:
.globl vector198
vector198:
  pushl $0
80105a77:	6a 00                	push   $0x0
  pushl $198
80105a79:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105a7e:	e9 08 f4 ff ff       	jmp    80104e8b <alltraps>

80105a83 <vector199>:
.globl vector199
vector199:
  pushl $0
80105a83:	6a 00                	push   $0x0
  pushl $199
80105a85:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105a8a:	e9 fc f3 ff ff       	jmp    80104e8b <alltraps>

80105a8f <vector200>:
.globl vector200
vector200:
  pushl $0
80105a8f:	6a 00                	push   $0x0
  pushl $200
80105a91:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105a96:	e9 f0 f3 ff ff       	jmp    80104e8b <alltraps>

80105a9b <vector201>:
.globl vector201
vector201:
  pushl $0
80105a9b:	6a 00                	push   $0x0
  pushl $201
80105a9d:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105aa2:	e9 e4 f3 ff ff       	jmp    80104e8b <alltraps>

80105aa7 <vector202>:
.globl vector202
vector202:
  pushl $0
80105aa7:	6a 00                	push   $0x0
  pushl $202
80105aa9:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105aae:	e9 d8 f3 ff ff       	jmp    80104e8b <alltraps>

80105ab3 <vector203>:
.globl vector203
vector203:
  pushl $0
80105ab3:	6a 00                	push   $0x0
  pushl $203
80105ab5:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105aba:	e9 cc f3 ff ff       	jmp    80104e8b <alltraps>

80105abf <vector204>:
.globl vector204
vector204:
  pushl $0
80105abf:	6a 00                	push   $0x0
  pushl $204
80105ac1:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105ac6:	e9 c0 f3 ff ff       	jmp    80104e8b <alltraps>

80105acb <vector205>:
.globl vector205
vector205:
  pushl $0
80105acb:	6a 00                	push   $0x0
  pushl $205
80105acd:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105ad2:	e9 b4 f3 ff ff       	jmp    80104e8b <alltraps>

80105ad7 <vector206>:
.globl vector206
vector206:
  pushl $0
80105ad7:	6a 00                	push   $0x0
  pushl $206
80105ad9:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105ade:	e9 a8 f3 ff ff       	jmp    80104e8b <alltraps>

80105ae3 <vector207>:
.globl vector207
vector207:
  pushl $0
80105ae3:	6a 00                	push   $0x0
  pushl $207
80105ae5:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105aea:	e9 9c f3 ff ff       	jmp    80104e8b <alltraps>

80105aef <vector208>:
.globl vector208
vector208:
  pushl $0
80105aef:	6a 00                	push   $0x0
  pushl $208
80105af1:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105af6:	e9 90 f3 ff ff       	jmp    80104e8b <alltraps>

80105afb <vector209>:
.globl vector209
vector209:
  pushl $0
80105afb:	6a 00                	push   $0x0
  pushl $209
80105afd:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105b02:	e9 84 f3 ff ff       	jmp    80104e8b <alltraps>

80105b07 <vector210>:
.globl vector210
vector210:
  pushl $0
80105b07:	6a 00                	push   $0x0
  pushl $210
80105b09:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105b0e:	e9 78 f3 ff ff       	jmp    80104e8b <alltraps>

80105b13 <vector211>:
.globl vector211
vector211:
  pushl $0
80105b13:	6a 00                	push   $0x0
  pushl $211
80105b15:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105b1a:	e9 6c f3 ff ff       	jmp    80104e8b <alltraps>

80105b1f <vector212>:
.globl vector212
vector212:
  pushl $0
80105b1f:	6a 00                	push   $0x0
  pushl $212
80105b21:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105b26:	e9 60 f3 ff ff       	jmp    80104e8b <alltraps>

80105b2b <vector213>:
.globl vector213
vector213:
  pushl $0
80105b2b:	6a 00                	push   $0x0
  pushl $213
80105b2d:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105b32:	e9 54 f3 ff ff       	jmp    80104e8b <alltraps>

80105b37 <vector214>:
.globl vector214
vector214:
  pushl $0
80105b37:	6a 00                	push   $0x0
  pushl $214
80105b39:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105b3e:	e9 48 f3 ff ff       	jmp    80104e8b <alltraps>

80105b43 <vector215>:
.globl vector215
vector215:
  pushl $0
80105b43:	6a 00                	push   $0x0
  pushl $215
80105b45:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105b4a:	e9 3c f3 ff ff       	jmp    80104e8b <alltraps>

80105b4f <vector216>:
.globl vector216
vector216:
  pushl $0
80105b4f:	6a 00                	push   $0x0
  pushl $216
80105b51:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105b56:	e9 30 f3 ff ff       	jmp    80104e8b <alltraps>

80105b5b <vector217>:
.globl vector217
vector217:
  pushl $0
80105b5b:	6a 00                	push   $0x0
  pushl $217
80105b5d:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105b62:	e9 24 f3 ff ff       	jmp    80104e8b <alltraps>

80105b67 <vector218>:
.globl vector218
vector218:
  pushl $0
80105b67:	6a 00                	push   $0x0
  pushl $218
80105b69:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105b6e:	e9 18 f3 ff ff       	jmp    80104e8b <alltraps>

80105b73 <vector219>:
.globl vector219
vector219:
  pushl $0
80105b73:	6a 00                	push   $0x0
  pushl $219
80105b75:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105b7a:	e9 0c f3 ff ff       	jmp    80104e8b <alltraps>

80105b7f <vector220>:
.globl vector220
vector220:
  pushl $0
80105b7f:	6a 00                	push   $0x0
  pushl $220
80105b81:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105b86:	e9 00 f3 ff ff       	jmp    80104e8b <alltraps>

80105b8b <vector221>:
.globl vector221
vector221:
  pushl $0
80105b8b:	6a 00                	push   $0x0
  pushl $221
80105b8d:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105b92:	e9 f4 f2 ff ff       	jmp    80104e8b <alltraps>

80105b97 <vector222>:
.globl vector222
vector222:
  pushl $0
80105b97:	6a 00                	push   $0x0
  pushl $222
80105b99:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105b9e:	e9 e8 f2 ff ff       	jmp    80104e8b <alltraps>

80105ba3 <vector223>:
.globl vector223
vector223:
  pushl $0
80105ba3:	6a 00                	push   $0x0
  pushl $223
80105ba5:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105baa:	e9 dc f2 ff ff       	jmp    80104e8b <alltraps>

80105baf <vector224>:
.globl vector224
vector224:
  pushl $0
80105baf:	6a 00                	push   $0x0
  pushl $224
80105bb1:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105bb6:	e9 d0 f2 ff ff       	jmp    80104e8b <alltraps>

80105bbb <vector225>:
.globl vector225
vector225:
  pushl $0
80105bbb:	6a 00                	push   $0x0
  pushl $225
80105bbd:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105bc2:	e9 c4 f2 ff ff       	jmp    80104e8b <alltraps>

80105bc7 <vector226>:
.globl vector226
vector226:
  pushl $0
80105bc7:	6a 00                	push   $0x0
  pushl $226
80105bc9:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105bce:	e9 b8 f2 ff ff       	jmp    80104e8b <alltraps>

80105bd3 <vector227>:
.globl vector227
vector227:
  pushl $0
80105bd3:	6a 00                	push   $0x0
  pushl $227
80105bd5:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105bda:	e9 ac f2 ff ff       	jmp    80104e8b <alltraps>

80105bdf <vector228>:
.globl vector228
vector228:
  pushl $0
80105bdf:	6a 00                	push   $0x0
  pushl $228
80105be1:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105be6:	e9 a0 f2 ff ff       	jmp    80104e8b <alltraps>

80105beb <vector229>:
.globl vector229
vector229:
  pushl $0
80105beb:	6a 00                	push   $0x0
  pushl $229
80105bed:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105bf2:	e9 94 f2 ff ff       	jmp    80104e8b <alltraps>

80105bf7 <vector230>:
.globl vector230
vector230:
  pushl $0
80105bf7:	6a 00                	push   $0x0
  pushl $230
80105bf9:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105bfe:	e9 88 f2 ff ff       	jmp    80104e8b <alltraps>

80105c03 <vector231>:
.globl vector231
vector231:
  pushl $0
80105c03:	6a 00                	push   $0x0
  pushl $231
80105c05:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105c0a:	e9 7c f2 ff ff       	jmp    80104e8b <alltraps>

80105c0f <vector232>:
.globl vector232
vector232:
  pushl $0
80105c0f:	6a 00                	push   $0x0
  pushl $232
80105c11:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105c16:	e9 70 f2 ff ff       	jmp    80104e8b <alltraps>

80105c1b <vector233>:
.globl vector233
vector233:
  pushl $0
80105c1b:	6a 00                	push   $0x0
  pushl $233
80105c1d:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105c22:	e9 64 f2 ff ff       	jmp    80104e8b <alltraps>

80105c27 <vector234>:
.globl vector234
vector234:
  pushl $0
80105c27:	6a 00                	push   $0x0
  pushl $234
80105c29:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105c2e:	e9 58 f2 ff ff       	jmp    80104e8b <alltraps>

80105c33 <vector235>:
.globl vector235
vector235:
  pushl $0
80105c33:	6a 00                	push   $0x0
  pushl $235
80105c35:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105c3a:	e9 4c f2 ff ff       	jmp    80104e8b <alltraps>

80105c3f <vector236>:
.globl vector236
vector236:
  pushl $0
80105c3f:	6a 00                	push   $0x0
  pushl $236
80105c41:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105c46:	e9 40 f2 ff ff       	jmp    80104e8b <alltraps>

80105c4b <vector237>:
.globl vector237
vector237:
  pushl $0
80105c4b:	6a 00                	push   $0x0
  pushl $237
80105c4d:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105c52:	e9 34 f2 ff ff       	jmp    80104e8b <alltraps>

80105c57 <vector238>:
.globl vector238
vector238:
  pushl $0
80105c57:	6a 00                	push   $0x0
  pushl $238
80105c59:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105c5e:	e9 28 f2 ff ff       	jmp    80104e8b <alltraps>

80105c63 <vector239>:
.globl vector239
vector239:
  pushl $0
80105c63:	6a 00                	push   $0x0
  pushl $239
80105c65:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105c6a:	e9 1c f2 ff ff       	jmp    80104e8b <alltraps>

80105c6f <vector240>:
.globl vector240
vector240:
  pushl $0
80105c6f:	6a 00                	push   $0x0
  pushl $240
80105c71:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105c76:	e9 10 f2 ff ff       	jmp    80104e8b <alltraps>

80105c7b <vector241>:
.globl vector241
vector241:
  pushl $0
80105c7b:	6a 00                	push   $0x0
  pushl $241
80105c7d:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105c82:	e9 04 f2 ff ff       	jmp    80104e8b <alltraps>

80105c87 <vector242>:
.globl vector242
vector242:
  pushl $0
80105c87:	6a 00                	push   $0x0
  pushl $242
80105c89:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105c8e:	e9 f8 f1 ff ff       	jmp    80104e8b <alltraps>

80105c93 <vector243>:
.globl vector243
vector243:
  pushl $0
80105c93:	6a 00                	push   $0x0
  pushl $243
80105c95:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105c9a:	e9 ec f1 ff ff       	jmp    80104e8b <alltraps>

80105c9f <vector244>:
.globl vector244
vector244:
  pushl $0
80105c9f:	6a 00                	push   $0x0
  pushl $244
80105ca1:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105ca6:	e9 e0 f1 ff ff       	jmp    80104e8b <alltraps>

80105cab <vector245>:
.globl vector245
vector245:
  pushl $0
80105cab:	6a 00                	push   $0x0
  pushl $245
80105cad:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105cb2:	e9 d4 f1 ff ff       	jmp    80104e8b <alltraps>

80105cb7 <vector246>:
.globl vector246
vector246:
  pushl $0
80105cb7:	6a 00                	push   $0x0
  pushl $246
80105cb9:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105cbe:	e9 c8 f1 ff ff       	jmp    80104e8b <alltraps>

80105cc3 <vector247>:
.globl vector247
vector247:
  pushl $0
80105cc3:	6a 00                	push   $0x0
  pushl $247
80105cc5:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105cca:	e9 bc f1 ff ff       	jmp    80104e8b <alltraps>

80105ccf <vector248>:
.globl vector248
vector248:
  pushl $0
80105ccf:	6a 00                	push   $0x0
  pushl $248
80105cd1:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105cd6:	e9 b0 f1 ff ff       	jmp    80104e8b <alltraps>

80105cdb <vector249>:
.globl vector249
vector249:
  pushl $0
80105cdb:	6a 00                	push   $0x0
  pushl $249
80105cdd:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105ce2:	e9 a4 f1 ff ff       	jmp    80104e8b <alltraps>

80105ce7 <vector250>:
.globl vector250
vector250:
  pushl $0
80105ce7:	6a 00                	push   $0x0
  pushl $250
80105ce9:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105cee:	e9 98 f1 ff ff       	jmp    80104e8b <alltraps>

80105cf3 <vector251>:
.globl vector251
vector251:
  pushl $0
80105cf3:	6a 00                	push   $0x0
  pushl $251
80105cf5:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105cfa:	e9 8c f1 ff ff       	jmp    80104e8b <alltraps>

80105cff <vector252>:
.globl vector252
vector252:
  pushl $0
80105cff:	6a 00                	push   $0x0
  pushl $252
80105d01:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105d06:	e9 80 f1 ff ff       	jmp    80104e8b <alltraps>

80105d0b <vector253>:
.globl vector253
vector253:
  pushl $0
80105d0b:	6a 00                	push   $0x0
  pushl $253
80105d0d:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105d12:	e9 74 f1 ff ff       	jmp    80104e8b <alltraps>

80105d17 <vector254>:
.globl vector254
vector254:
  pushl $0
80105d17:	6a 00                	push   $0x0
  pushl $254
80105d19:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105d1e:	e9 68 f1 ff ff       	jmp    80104e8b <alltraps>

80105d23 <vector255>:
.globl vector255
vector255:
  pushl $0
80105d23:	6a 00                	push   $0x0
  pushl $255
80105d25:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105d2a:	e9 5c f1 ff ff       	jmp    80104e8b <alltraps>

80105d2f <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105d2f:	55                   	push   %ebp
80105d30:	89 e5                	mov    %esp,%ebp
80105d32:	57                   	push   %edi
80105d33:	56                   	push   %esi
80105d34:	53                   	push   %ebx
80105d35:	83 ec 0c             	sub    $0xc,%esp
80105d38:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105d3a:	c1 ea 16             	shr    $0x16,%edx
80105d3d:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80105d40:	8b 37                	mov    (%edi),%esi
80105d42:	f7 c6 01 00 00 00    	test   $0x1,%esi
80105d48:	74 20                	je     80105d6a <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105d4a:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80105d50:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105d56:	c1 eb 0c             	shr    $0xc,%ebx
80105d59:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
80105d5f:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
}
80105d62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d65:	5b                   	pop    %ebx
80105d66:	5e                   	pop    %esi
80105d67:	5f                   	pop    %edi
80105d68:	5d                   	pop    %ebp
80105d69:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105d6a:	85 c9                	test   %ecx,%ecx
80105d6c:	74 2b                	je     80105d99 <walkpgdir+0x6a>
80105d6e:	e8 89 c3 ff ff       	call   801020fc <kalloc>
80105d73:	89 c6                	mov    %eax,%esi
80105d75:	85 c0                	test   %eax,%eax
80105d77:	74 20                	je     80105d99 <walkpgdir+0x6a>
    memset(pgtab, 0, PGSIZE);
80105d79:	83 ec 04             	sub    $0x4,%esp
80105d7c:	68 00 10 00 00       	push   $0x1000
80105d81:	6a 00                	push   $0x0
80105d83:	50                   	push   %eax
80105d84:	e8 77 df ff ff       	call   80103d00 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105d89:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80105d8f:	83 c8 07             	or     $0x7,%eax
80105d92:	89 07                	mov    %eax,(%edi)
80105d94:	83 c4 10             	add    $0x10,%esp
80105d97:	eb bd                	jmp    80105d56 <walkpgdir+0x27>
      return 0;
80105d99:	b8 00 00 00 00       	mov    $0x0,%eax
80105d9e:	eb c2                	jmp    80105d62 <walkpgdir+0x33>

80105da0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	57                   	push   %edi
80105da4:	56                   	push   %esi
80105da5:	53                   	push   %ebx
80105da6:	83 ec 1c             	sub    $0x1c,%esp
80105da9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105dac:	8b 75 08             	mov    0x8(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80105daf:	89 d3                	mov    %edx,%ebx
80105db1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80105db7:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
80105dbb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105dc1:	b9 01 00 00 00       	mov    $0x1,%ecx
80105dc6:	89 da                	mov    %ebx,%edx
80105dc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105dcb:	e8 5f ff ff ff       	call   80105d2f <walkpgdir>
80105dd0:	85 c0                	test   %eax,%eax
80105dd2:	74 2e                	je     80105e02 <mappages+0x62>
      return -1;
    if(*pte & PTE_P)
80105dd4:	f6 00 01             	testb  $0x1,(%eax)
80105dd7:	75 1c                	jne    80105df5 <mappages+0x55>
      panic("remap");
    *pte = pa | perm | PTE_P;
80105dd9:	89 f2                	mov    %esi,%edx
80105ddb:	0b 55 0c             	or     0xc(%ebp),%edx
80105dde:	83 ca 01             	or     $0x1,%edx
80105de1:	89 10                	mov    %edx,(%eax)
    if(a == last)
80105de3:	39 fb                	cmp    %edi,%ebx
80105de5:	74 28                	je     80105e0f <mappages+0x6f>
      break;
    a += PGSIZE;
80105de7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
80105ded:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105df3:	eb cc                	jmp    80105dc1 <mappages+0x21>
      panic("remap");
80105df5:	83 ec 0c             	sub    $0xc,%esp
80105df8:	68 f0 6e 10 80       	push   $0x80106ef0
80105dfd:	e8 53 a5 ff ff       	call   80100355 <panic>
      return -1;
80105e02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80105e07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e0a:	5b                   	pop    %ebx
80105e0b:	5e                   	pop    %esi
80105e0c:	5f                   	pop    %edi
80105e0d:	5d                   	pop    %ebp
80105e0e:	c3                   	ret    
  return 0;
80105e0f:	b8 00 00 00 00       	mov    $0x0,%eax
80105e14:	eb f1                	jmp    80105e07 <mappages+0x67>

80105e16 <seginit>:
{
80105e16:	f3 0f 1e fb          	endbr32 
80105e1a:	55                   	push   %ebp
80105e1b:	89 e5                	mov    %esp,%ebp
80105e1d:	57                   	push   %edi
80105e1e:	56                   	push   %esi
80105e1f:	53                   	push   %ebx
80105e20:	83 ec 1c             	sub    $0x1c,%esp
  c = &cpus[cpuid()];
80105e23:	e8 f4 d3 ff ff       	call   8010321c <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80105e28:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80105e2b:	8d 3c 09             	lea    (%ecx,%ecx,1),%edi
80105e2e:	8d 14 07             	lea    (%edi,%eax,1),%edx
80105e31:	c1 e2 04             	shl    $0x4,%edx
80105e34:	66 c7 82 f8 27 11 80 	movw   $0xffff,-0x7feed808(%edx)
80105e3b:	ff ff 
80105e3d:	66 c7 82 fa 27 11 80 	movw   $0x0,-0x7feed806(%edx)
80105e44:	00 00 
80105e46:	c6 82 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%edx)
80105e4d:	8d 34 07             	lea    (%edi,%eax,1),%esi
80105e50:	c1 e6 04             	shl    $0x4,%esi
80105e53:	8a 9e fd 27 11 80    	mov    -0x7feed803(%esi),%bl
80105e59:	83 e3 f0             	and    $0xfffffff0,%ebx
80105e5c:	83 cb 1a             	or     $0x1a,%ebx
80105e5f:	83 e3 9f             	and    $0xffffff9f,%ebx
80105e62:	83 cb 80             	or     $0xffffff80,%ebx
80105e65:	88 9e fd 27 11 80    	mov    %bl,-0x7feed803(%esi)
80105e6b:	8a 9e fe 27 11 80    	mov    -0x7feed802(%esi),%bl
80105e71:	83 cb 0f             	or     $0xf,%ebx
80105e74:	83 e3 cf             	and    $0xffffffcf,%ebx
80105e77:	83 cb c0             	or     $0xffffffc0,%ebx
80105e7a:	88 9e fe 27 11 80    	mov    %bl,-0x7feed802(%esi)
80105e80:	c6 82 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80105e87:	66 c7 82 00 28 11 80 	movw   $0xffff,-0x7feed800(%edx)
80105e8e:	ff ff 
80105e90:	66 c7 82 02 28 11 80 	movw   $0x0,-0x7feed7fe(%edx)
80105e97:	00 00 
80105e99:	c6 82 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%edx)
80105ea0:	8d 34 07             	lea    (%edi,%eax,1),%esi
80105ea3:	c1 e6 04             	shl    $0x4,%esi
80105ea6:	8a 9e 05 28 11 80    	mov    -0x7feed7fb(%esi),%bl
80105eac:	83 e3 f0             	and    $0xfffffff0,%ebx
80105eaf:	83 cb 12             	or     $0x12,%ebx
80105eb2:	83 e3 9f             	and    $0xffffff9f,%ebx
80105eb5:	83 cb 80             	or     $0xffffff80,%ebx
80105eb8:	88 9e 05 28 11 80    	mov    %bl,-0x7feed7fb(%esi)
80105ebe:	8a 9e 06 28 11 80    	mov    -0x7feed7fa(%esi),%bl
80105ec4:	83 cb 0f             	or     $0xf,%ebx
80105ec7:	83 e3 cf             	and    $0xffffffcf,%ebx
80105eca:	83 cb c0             	or     $0xffffffc0,%ebx
80105ecd:	88 9e 06 28 11 80    	mov    %bl,-0x7feed7fa(%esi)
80105ed3:	c6 82 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80105eda:	66 c7 82 08 28 11 80 	movw   $0xffff,-0x7feed7f8(%edx)
80105ee1:	ff ff 
80105ee3:	66 c7 82 0a 28 11 80 	movw   $0x0,-0x7feed7f6(%edx)
80105eea:	00 00 
80105eec:	c6 82 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%edx)
80105ef3:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
80105ef6:	c1 e3 04             	shl    $0x4,%ebx
80105ef9:	c6 83 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%ebx)
80105f00:	0f b6 b3 0e 28 11 80 	movzbl -0x7feed7f2(%ebx),%esi
80105f07:	83 ce 0f             	or     $0xf,%esi
80105f0a:	83 e6 cf             	and    $0xffffffcf,%esi
80105f0d:	83 ce c0             	or     $0xffffffc0,%esi
80105f10:	89 f1                	mov    %esi,%ecx
80105f12:	88 8b 0e 28 11 80    	mov    %cl,-0x7feed7f2(%ebx)
80105f18:	c6 82 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80105f1f:	66 c7 82 10 28 11 80 	movw   $0xffff,-0x7feed7f0(%edx)
80105f26:	ff ff 
80105f28:	66 c7 82 12 28 11 80 	movw   $0x0,-0x7feed7ee(%edx)
80105f2f:	00 00 
80105f31:	c6 82 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%edx)
80105f38:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
80105f3b:	c1 e3 04             	shl    $0x4,%ebx
80105f3e:	c6 83 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%ebx)
80105f45:	0f b6 b3 16 28 11 80 	movzbl -0x7feed7ea(%ebx),%esi
80105f4c:	83 ce 0f             	or     $0xf,%esi
80105f4f:	83 e6 cf             	and    $0xffffffcf,%esi
80105f52:	83 ce c0             	or     $0xffffffc0,%esi
80105f55:	89 f1                	mov    %esi,%ecx
80105f57:	88 8b 16 28 11 80    	mov    %cl,-0x7feed7ea(%ebx)
80105f5d:	c6 82 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%edx)
  lgdt(c->gdt, sizeof(c->gdt));
80105f64:	8d 0c 07             	lea    (%edi,%eax,1),%ecx
80105f67:	c1 e1 04             	shl    $0x4,%ecx
80105f6a:	81 c1 f0 27 11 80    	add    $0x801127f0,%ecx
  pd[0] = size-1;
80105f70:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
80105f76:	66 89 4d e4          	mov    %cx,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
80105f7a:	c1 e9 10             	shr    $0x10,%ecx
80105f7d:	66 89 4d e6          	mov    %cx,-0x1a(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80105f81:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105f84:	0f 01 10             	lgdtl  (%eax)
}
80105f87:	83 c4 1c             	add    $0x1c,%esp
80105f8a:	5b                   	pop    %ebx
80105f8b:	5e                   	pop    %esi
80105f8c:	5f                   	pop    %edi
80105f8d:	5d                   	pop    %ebp
80105f8e:	c3                   	ret    

80105f8f <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80105f8f:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80105f93:	a1 a4 54 11 80       	mov    0x801154a4,%eax
80105f98:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105f9d:	0f 22 d8             	mov    %eax,%cr3
}
80105fa0:	c3                   	ret    

80105fa1 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80105fa1:	f3 0f 1e fb          	endbr32 
80105fa5:	55                   	push   %ebp
80105fa6:	89 e5                	mov    %esp,%ebp
80105fa8:	57                   	push   %edi
80105fa9:	56                   	push   %esi
80105faa:	53                   	push   %ebx
80105fab:	83 ec 1c             	sub    $0x1c,%esp
80105fae:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80105fb1:	85 f6                	test   %esi,%esi
80105fb3:	0f 84 da 00 00 00    	je     80106093 <switchuvm+0xf2>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80105fb9:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
80105fbd:	0f 84 dd 00 00 00    	je     801060a0 <switchuvm+0xff>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80105fc3:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
80105fc7:	0f 84 e0 00 00 00    	je     801060ad <switchuvm+0x10c>
    panic("switchuvm: no pgdir");

  pushcli();
80105fcd:	e8 92 db ff ff       	call   80103b64 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80105fd2:	e8 de d1 ff ff       	call   801031b5 <mycpu>
80105fd7:	89 c3                	mov    %eax,%ebx
80105fd9:	e8 d7 d1 ff ff       	call   801031b5 <mycpu>
80105fde:	8d 78 08             	lea    0x8(%eax),%edi
80105fe1:	e8 cf d1 ff ff       	call   801031b5 <mycpu>
80105fe6:	83 c0 08             	add    $0x8,%eax
80105fe9:	c1 e8 10             	shr    $0x10,%eax
80105fec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105fef:	e8 c1 d1 ff ff       	call   801031b5 <mycpu>
80105ff4:	83 c0 08             	add    $0x8,%eax
80105ff7:	c1 e8 18             	shr    $0x18,%eax
80105ffa:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80106001:	67 00 
80106003:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010600a:	8a 4d e4             	mov    -0x1c(%ebp),%cl
8010600d:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106013:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
80106019:	83 e2 f0             	and    $0xfffffff0,%edx
8010601c:	83 ca 19             	or     $0x19,%edx
8010601f:	83 e2 9f             	and    $0xffffff9f,%edx
80106022:	83 ca 80             	or     $0xffffff80,%edx
80106025:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
8010602b:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106032:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106038:	e8 78 d1 ff ff       	call   801031b5 <mycpu>
8010603d:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80106043:	83 e2 ef             	and    $0xffffffef,%edx
80106046:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010604c:	e8 64 d1 ff ff       	call   801031b5 <mycpu>
80106051:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106057:	8b 5e 08             	mov    0x8(%esi),%ebx
8010605a:	e8 56 d1 ff ff       	call   801031b5 <mycpu>
8010605f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106065:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106068:	e8 48 d1 ff ff       	call   801031b5 <mycpu>
8010606d:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106073:	b8 28 00 00 00       	mov    $0x28,%eax
80106078:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010607b:	8b 46 04             	mov    0x4(%esi),%eax
8010607e:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106083:	0f 22 d8             	mov    %eax,%cr3
  popcli();
80106086:	e8 19 db ff ff       	call   80103ba4 <popcli>
}
8010608b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010608e:	5b                   	pop    %ebx
8010608f:	5e                   	pop    %esi
80106090:	5f                   	pop    %edi
80106091:	5d                   	pop    %ebp
80106092:	c3                   	ret    
    panic("switchuvm: no process");
80106093:	83 ec 0c             	sub    $0xc,%esp
80106096:	68 f6 6e 10 80       	push   $0x80106ef6
8010609b:	e8 b5 a2 ff ff       	call   80100355 <panic>
    panic("switchuvm: no kstack");
801060a0:	83 ec 0c             	sub    $0xc,%esp
801060a3:	68 0c 6f 10 80       	push   $0x80106f0c
801060a8:	e8 a8 a2 ff ff       	call   80100355 <panic>
    panic("switchuvm: no pgdir");
801060ad:	83 ec 0c             	sub    $0xc,%esp
801060b0:	68 21 6f 10 80       	push   $0x80106f21
801060b5:	e8 9b a2 ff ff       	call   80100355 <panic>

801060ba <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801060ba:	f3 0f 1e fb          	endbr32 
801060be:	55                   	push   %ebp
801060bf:	89 e5                	mov    %esp,%ebp
801060c1:	56                   	push   %esi
801060c2:	53                   	push   %ebx
801060c3:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
801060c6:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801060cc:	77 4c                	ja     8010611a <inituvm+0x60>
    panic("inituvm: more than a page");
  mem = kalloc();
801060ce:	e8 29 c0 ff ff       	call   801020fc <kalloc>
801060d3:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801060d5:	83 ec 04             	sub    $0x4,%esp
801060d8:	68 00 10 00 00       	push   $0x1000
801060dd:	6a 00                	push   $0x0
801060df:	50                   	push   %eax
801060e0:	e8 1b dc ff ff       	call   80103d00 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801060e5:	83 c4 08             	add    $0x8,%esp
801060e8:	6a 06                	push   $0x6
801060ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801060f0:	50                   	push   %eax
801060f1:	b9 00 10 00 00       	mov    $0x1000,%ecx
801060f6:	ba 00 00 00 00       	mov    $0x0,%edx
801060fb:	8b 45 08             	mov    0x8(%ebp),%eax
801060fe:	e8 9d fc ff ff       	call   80105da0 <mappages>
  memmove(mem, init, sz);
80106103:	83 c4 0c             	add    $0xc,%esp
80106106:	56                   	push   %esi
80106107:	ff 75 0c             	pushl  0xc(%ebp)
8010610a:	53                   	push   %ebx
8010610b:	e8 6e dc ff ff       	call   80103d7e <memmove>
}
80106110:	83 c4 10             	add    $0x10,%esp
80106113:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106116:	5b                   	pop    %ebx
80106117:	5e                   	pop    %esi
80106118:	5d                   	pop    %ebp
80106119:	c3                   	ret    
    panic("inituvm: more than a page");
8010611a:	83 ec 0c             	sub    $0xc,%esp
8010611d:	68 35 6f 10 80       	push   $0x80106f35
80106122:	e8 2e a2 ff ff       	call   80100355 <panic>

80106127 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106127:	f3 0f 1e fb          	endbr32 
8010612b:	55                   	push   %ebp
8010612c:	89 e5                	mov    %esp,%ebp
8010612e:	57                   	push   %edi
8010612f:	56                   	push   %esi
80106130:	53                   	push   %ebx
80106131:	83 ec 0c             	sub    $0xc,%esp
80106134:	8b 7d 0c             	mov    0xc(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106137:	89 fb                	mov    %edi,%ebx
80106139:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
8010613f:	74 3c                	je     8010617d <loaduvm+0x56>
    panic("loaduvm: addr must be page aligned");
80106141:	83 ec 0c             	sub    $0xc,%esp
80106144:	68 f0 6f 10 80       	push   $0x80106ff0
80106149:	e8 07 a2 ff ff       	call   80100355 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
8010614e:	83 ec 0c             	sub    $0xc,%esp
80106151:	68 4f 6f 10 80       	push   $0x80106f4f
80106156:	e8 fa a1 ff ff       	call   80100355 <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010615b:	05 00 00 00 80       	add    $0x80000000,%eax
80106160:	56                   	push   %esi
80106161:	89 da                	mov    %ebx,%edx
80106163:	03 55 14             	add    0x14(%ebp),%edx
80106166:	52                   	push   %edx
80106167:	50                   	push   %eax
80106168:	ff 75 10             	pushl  0x10(%ebp)
8010616b:	e8 17 b6 ff ff       	call   80101787 <readi>
80106170:	83 c4 10             	add    $0x10,%esp
80106173:	39 f0                	cmp    %esi,%eax
80106175:	75 47                	jne    801061be <loaduvm+0x97>
  for(i = 0; i < sz; i += PGSIZE){
80106177:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010617d:	3b 5d 18             	cmp    0x18(%ebp),%ebx
80106180:	73 2f                	jae    801061b1 <loaduvm+0x8a>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106182:	8d 14 1f             	lea    (%edi,%ebx,1),%edx
80106185:	b9 00 00 00 00       	mov    $0x0,%ecx
8010618a:	8b 45 08             	mov    0x8(%ebp),%eax
8010618d:	e8 9d fb ff ff       	call   80105d2f <walkpgdir>
80106192:	85 c0                	test   %eax,%eax
80106194:	74 b8                	je     8010614e <loaduvm+0x27>
    pa = PTE_ADDR(*pte);
80106196:	8b 00                	mov    (%eax),%eax
80106198:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010619d:	8b 75 18             	mov    0x18(%ebp),%esi
801061a0:	29 de                	sub    %ebx,%esi
801061a2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801061a8:	76 b1                	jbe    8010615b <loaduvm+0x34>
      n = PGSIZE;
801061aa:	be 00 10 00 00       	mov    $0x1000,%esi
801061af:	eb aa                	jmp    8010615b <loaduvm+0x34>
      return -1;
  }
  return 0;
801061b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061b9:	5b                   	pop    %ebx
801061ba:	5e                   	pop    %esi
801061bb:	5f                   	pop    %edi
801061bc:	5d                   	pop    %ebp
801061bd:	c3                   	ret    
      return -1;
801061be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061c3:	eb f1                	jmp    801061b6 <loaduvm+0x8f>

801061c5 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801061c5:	f3 0f 1e fb          	endbr32 
801061c9:	55                   	push   %ebp
801061ca:	89 e5                	mov    %esp,%ebp
801061cc:	57                   	push   %edi
801061cd:	56                   	push   %esi
801061ce:	53                   	push   %ebx
801061cf:	83 ec 0c             	sub    $0xc,%esp
801061d2:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801061d5:	39 7d 10             	cmp    %edi,0x10(%ebp)
801061d8:	73 11                	jae    801061eb <deallocuvm+0x26>
    return oldsz;

  a = PGROUNDUP(newsz);
801061da:	8b 45 10             	mov    0x10(%ebp),%eax
801061dd:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801061e3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801061e9:	eb 17                	jmp    80106202 <deallocuvm+0x3d>
    return oldsz;
801061eb:	89 f8                	mov    %edi,%eax
801061ed:	eb 62                	jmp    80106251 <deallocuvm+0x8c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801061ef:	c1 eb 16             	shr    $0x16,%ebx
801061f2:	43                   	inc    %ebx
801061f3:	c1 e3 16             	shl    $0x16,%ebx
801061f6:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801061fc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106202:	39 fb                	cmp    %edi,%ebx
80106204:	73 48                	jae    8010624e <deallocuvm+0x89>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106206:	b9 00 00 00 00       	mov    $0x0,%ecx
8010620b:	89 da                	mov    %ebx,%edx
8010620d:	8b 45 08             	mov    0x8(%ebp),%eax
80106210:	e8 1a fb ff ff       	call   80105d2f <walkpgdir>
80106215:	89 c6                	mov    %eax,%esi
    if(!pte)
80106217:	85 c0                	test   %eax,%eax
80106219:	74 d4                	je     801061ef <deallocuvm+0x2a>
    else if((*pte & PTE_P) != 0){
8010621b:	8b 00                	mov    (%eax),%eax
8010621d:	a8 01                	test   $0x1,%al
8010621f:	74 db                	je     801061fc <deallocuvm+0x37>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106221:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106226:	74 19                	je     80106241 <deallocuvm+0x7c>
        panic("kfree");
      char *v = P2V(pa);
80106228:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010622d:	83 ec 0c             	sub    $0xc,%esp
80106230:	50                   	push   %eax
80106231:	e8 9f bd ff ff       	call   80101fd5 <kfree>
      *pte = 0;
80106236:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010623c:	83 c4 10             	add    $0x10,%esp
8010623f:	eb bb                	jmp    801061fc <deallocuvm+0x37>
        panic("kfree");
80106241:	83 ec 0c             	sub    $0xc,%esp
80106244:	68 a6 68 10 80       	push   $0x801068a6
80106249:	e8 07 a1 ff ff       	call   80100355 <panic>
    }
  }
  return newsz;
8010624e:	8b 45 10             	mov    0x10(%ebp),%eax
}
80106251:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106254:	5b                   	pop    %ebx
80106255:	5e                   	pop    %esi
80106256:	5f                   	pop    %edi
80106257:	5d                   	pop    %ebp
80106258:	c3                   	ret    

80106259 <allocuvm>:
{
80106259:	f3 0f 1e fb          	endbr32 
8010625d:	55                   	push   %ebp
8010625e:	89 e5                	mov    %esp,%ebp
80106260:	57                   	push   %edi
80106261:	56                   	push   %esi
80106262:	53                   	push   %ebx
80106263:	83 ec 1c             	sub    $0x1c,%esp
80106266:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
80106269:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010626c:	85 ff                	test   %edi,%edi
8010626e:	0f 88 c0 00 00 00    	js     80106334 <allocuvm+0xdb>
  if(newsz < oldsz)
80106274:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106277:	72 11                	jb     8010628a <allocuvm+0x31>
  a = PGROUNDUP(oldsz);
80106279:	8b 45 0c             	mov    0xc(%ebp),%eax
8010627c:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106282:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106288:	eb 39                	jmp    801062c3 <allocuvm+0x6a>
    return oldsz;
8010628a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010628d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106290:	e9 a6 00 00 00       	jmp    8010633b <allocuvm+0xe2>
      cprintf("allocuvm out of memory\n");
80106295:	83 ec 0c             	sub    $0xc,%esp
80106298:	68 6d 6f 10 80       	push   $0x80106f6d
8010629d:	e8 5b a3 ff ff       	call   801005fd <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801062a2:	83 c4 0c             	add    $0xc,%esp
801062a5:	ff 75 0c             	pushl  0xc(%ebp)
801062a8:	57                   	push   %edi
801062a9:	ff 75 08             	pushl  0x8(%ebp)
801062ac:	e8 14 ff ff ff       	call   801061c5 <deallocuvm>
      return 0;
801062b1:	83 c4 10             	add    $0x10,%esp
801062b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801062bb:	eb 7e                	jmp    8010633b <allocuvm+0xe2>
  for(; a < newsz; a += PGSIZE){
801062bd:	81 c6 00 10 00 00    	add    $0x1000,%esi
801062c3:	39 fe                	cmp    %edi,%esi
801062c5:	73 74                	jae    8010633b <allocuvm+0xe2>
    mem = kalloc();
801062c7:	e8 30 be ff ff       	call   801020fc <kalloc>
801062cc:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801062ce:	85 c0                	test   %eax,%eax
801062d0:	74 c3                	je     80106295 <allocuvm+0x3c>
    memset(mem, 0, PGSIZE);
801062d2:	83 ec 04             	sub    $0x4,%esp
801062d5:	68 00 10 00 00       	push   $0x1000
801062da:	6a 00                	push   $0x0
801062dc:	50                   	push   %eax
801062dd:	e8 1e da ff ff       	call   80103d00 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801062e2:	83 c4 08             	add    $0x8,%esp
801062e5:	6a 06                	push   $0x6
801062e7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801062ed:	50                   	push   %eax
801062ee:	b9 00 10 00 00       	mov    $0x1000,%ecx
801062f3:	89 f2                	mov    %esi,%edx
801062f5:	8b 45 08             	mov    0x8(%ebp),%eax
801062f8:	e8 a3 fa ff ff       	call   80105da0 <mappages>
801062fd:	83 c4 10             	add    $0x10,%esp
80106300:	85 c0                	test   %eax,%eax
80106302:	79 b9                	jns    801062bd <allocuvm+0x64>
      cprintf("allocuvm out of memory (2)\n");
80106304:	83 ec 0c             	sub    $0xc,%esp
80106307:	68 85 6f 10 80       	push   $0x80106f85
8010630c:	e8 ec a2 ff ff       	call   801005fd <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106311:	83 c4 0c             	add    $0xc,%esp
80106314:	ff 75 0c             	pushl  0xc(%ebp)
80106317:	57                   	push   %edi
80106318:	ff 75 08             	pushl  0x8(%ebp)
8010631b:	e8 a5 fe ff ff       	call   801061c5 <deallocuvm>
      kfree(mem);
80106320:	89 1c 24             	mov    %ebx,(%esp)
80106323:	e8 ad bc ff ff       	call   80101fd5 <kfree>
      return 0;
80106328:	83 c4 10             	add    $0x10,%esp
8010632b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106332:	eb 07                	jmp    8010633b <allocuvm+0xe2>
    return 0;
80106334:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
8010633b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010633e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106341:	5b                   	pop    %ebx
80106342:	5e                   	pop    %esi
80106343:	5f                   	pop    %edi
80106344:	5d                   	pop    %ebp
80106345:	c3                   	ret    

80106346 <freevm>:

// Free a page table and all the physical memory pages
// in the user part if dodeallocuvm is not zero
void
freevm(pde_t *pgdir, int dodeallocuvm)
{
80106346:	f3 0f 1e fb          	endbr32 
8010634a:	55                   	push   %ebp
8010634b:	89 e5                	mov    %esp,%ebp
8010634d:	56                   	push   %esi
8010634e:	53                   	push   %ebx
8010634f:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106352:	85 f6                	test   %esi,%esi
80106354:	74 0d                	je     80106363 <freevm+0x1d>
    panic("freevm: no pgdir");
  if (dodeallocuvm)
80106356:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010635a:	75 14                	jne    80106370 <freevm+0x2a>
{
8010635c:	bb 00 00 00 00       	mov    $0x0,%ebx
80106361:	eb 39                	jmp    8010639c <freevm+0x56>
    panic("freevm: no pgdir");
80106363:	83 ec 0c             	sub    $0xc,%esp
80106366:	68 a1 6f 10 80       	push   $0x80106fa1
8010636b:	e8 e5 9f ff ff       	call   80100355 <panic>
    deallocuvm(pgdir, KERNBASE, 0);
80106370:	83 ec 04             	sub    $0x4,%esp
80106373:	6a 00                	push   $0x0
80106375:	68 00 00 00 80       	push   $0x80000000
8010637a:	56                   	push   %esi
8010637b:	e8 45 fe ff ff       	call   801061c5 <deallocuvm>
80106380:	83 c4 10             	add    $0x10,%esp
80106383:	eb d7                	jmp    8010635c <freevm+0x16>
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106385:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010638a:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010638f:	83 ec 0c             	sub    $0xc,%esp
80106392:	50                   	push   %eax
80106393:	e8 3d bc ff ff       	call   80101fd5 <kfree>
80106398:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010639b:	43                   	inc    %ebx
8010639c:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
801063a2:	77 09                	ja     801063ad <freevm+0x67>
    if(pgdir[i] & PTE_P){
801063a4:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
801063a7:	a8 01                	test   $0x1,%al
801063a9:	74 f0                	je     8010639b <freevm+0x55>
801063ab:	eb d8                	jmp    80106385 <freevm+0x3f>
    }
  }
  kfree((char*)pgdir);
801063ad:	83 ec 0c             	sub    $0xc,%esp
801063b0:	56                   	push   %esi
801063b1:	e8 1f bc ff ff       	call   80101fd5 <kfree>
}
801063b6:	83 c4 10             	add    $0x10,%esp
801063b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801063bc:	5b                   	pop    %ebx
801063bd:	5e                   	pop    %esi
801063be:	5d                   	pop    %ebp
801063bf:	c3                   	ret    

801063c0 <setupkvm>:
{
801063c0:	f3 0f 1e fb          	endbr32 
801063c4:	55                   	push   %ebp
801063c5:	89 e5                	mov    %esp,%ebp
801063c7:	56                   	push   %esi
801063c8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801063c9:	e8 2e bd ff ff       	call   801020fc <kalloc>
801063ce:	89 c6                	mov    %eax,%esi
801063d0:	85 c0                	test   %eax,%eax
801063d2:	74 57                	je     8010642b <setupkvm+0x6b>
  memset(pgdir, 0, PGSIZE);
801063d4:	83 ec 04             	sub    $0x4,%esp
801063d7:	68 00 10 00 00       	push   $0x1000
801063dc:	6a 00                	push   $0x0
801063de:	50                   	push   %eax
801063df:	e8 1c d9 ff ff       	call   80103d00 <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801063e4:	83 c4 10             	add    $0x10,%esp
801063e7:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
801063ec:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801063f2:	73 37                	jae    8010642b <setupkvm+0x6b>
                (uint)k->phys_start, k->perm) < 0) {
801063f4:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801063f7:	8b 4b 08             	mov    0x8(%ebx),%ecx
801063fa:	29 c1                	sub    %eax,%ecx
801063fc:	83 ec 08             	sub    $0x8,%esp
801063ff:	ff 73 0c             	pushl  0xc(%ebx)
80106402:	50                   	push   %eax
80106403:	8b 13                	mov    (%ebx),%edx
80106405:	89 f0                	mov    %esi,%eax
80106407:	e8 94 f9 ff ff       	call   80105da0 <mappages>
8010640c:	83 c4 10             	add    $0x10,%esp
8010640f:	85 c0                	test   %eax,%eax
80106411:	78 05                	js     80106418 <setupkvm+0x58>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106413:	83 c3 10             	add    $0x10,%ebx
80106416:	eb d4                	jmp    801063ec <setupkvm+0x2c>
      freevm(pgdir, 0);
80106418:	83 ec 08             	sub    $0x8,%esp
8010641b:	6a 00                	push   $0x0
8010641d:	56                   	push   %esi
8010641e:	e8 23 ff ff ff       	call   80106346 <freevm>
      return 0;
80106423:	83 c4 10             	add    $0x10,%esp
80106426:	be 00 00 00 00       	mov    $0x0,%esi
}
8010642b:	89 f0                	mov    %esi,%eax
8010642d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106430:	5b                   	pop    %ebx
80106431:	5e                   	pop    %esi
80106432:	5d                   	pop    %ebp
80106433:	c3                   	ret    

80106434 <kvmalloc>:
{
80106434:	f3 0f 1e fb          	endbr32 
80106438:	55                   	push   %ebp
80106439:	89 e5                	mov    %esp,%ebp
8010643b:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010643e:	e8 7d ff ff ff       	call   801063c0 <setupkvm>
80106443:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  switchkvm();
80106448:	e8 42 fb ff ff       	call   80105f8f <switchkvm>
}
8010644d:	c9                   	leave  
8010644e:	c3                   	ret    

8010644f <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010644f:	f3 0f 1e fb          	endbr32 
80106453:	55                   	push   %ebp
80106454:	89 e5                	mov    %esp,%ebp
80106456:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106459:	b9 00 00 00 00       	mov    $0x0,%ecx
8010645e:	8b 55 0c             	mov    0xc(%ebp),%edx
80106461:	8b 45 08             	mov    0x8(%ebp),%eax
80106464:	e8 c6 f8 ff ff       	call   80105d2f <walkpgdir>
  if(pte == 0)
80106469:	85 c0                	test   %eax,%eax
8010646b:	74 05                	je     80106472 <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010646d:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106470:	c9                   	leave  
80106471:	c3                   	ret    
    panic("clearpteu");
80106472:	83 ec 0c             	sub    $0xc,%esp
80106475:	68 b2 6f 10 80       	push   $0x80106fb2
8010647a:	e8 d6 9e ff ff       	call   80100355 <panic>

8010647f <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010647f:	f3 0f 1e fb          	endbr32 
80106483:	55                   	push   %ebp
80106484:	89 e5                	mov    %esp,%ebp
80106486:	57                   	push   %edi
80106487:	56                   	push   %esi
80106488:	53                   	push   %ebx
80106489:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010648c:	e8 2f ff ff ff       	call   801063c0 <setupkvm>
80106491:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106494:	85 c0                	test   %eax,%eax
80106496:	0f 84 c6 00 00 00    	je     80106562 <copyuvm+0xe3>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010649c:	bb 00 00 00 00       	mov    $0x0,%ebx
801064a1:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
801064a4:	0f 83 b8 00 00 00    	jae    80106562 <copyuvm+0xe3>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801064aa:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801064ad:	b9 00 00 00 00       	mov    $0x0,%ecx
801064b2:	89 da                	mov    %ebx,%edx
801064b4:	8b 45 08             	mov    0x8(%ebp),%eax
801064b7:	e8 73 f8 ff ff       	call   80105d2f <walkpgdir>
801064bc:	85 c0                	test   %eax,%eax
801064be:	74 65                	je     80106525 <copyuvm+0xa6>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801064c0:	8b 00                	mov    (%eax),%eax
801064c2:	a8 01                	test   $0x1,%al
801064c4:	74 6c                	je     80106532 <copyuvm+0xb3>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801064c6:	89 c6                	mov    %eax,%esi
801064c8:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
801064ce:	25 ff 0f 00 00       	and    $0xfff,%eax
801064d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
801064d6:	e8 21 bc ff ff       	call   801020fc <kalloc>
801064db:	89 c7                	mov    %eax,%edi
801064dd:	85 c0                	test   %eax,%eax
801064df:	74 6a                	je     8010654b <copyuvm+0xcc>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801064e1:	81 c6 00 00 00 80    	add    $0x80000000,%esi
801064e7:	83 ec 04             	sub    $0x4,%esp
801064ea:	68 00 10 00 00       	push   $0x1000
801064ef:	56                   	push   %esi
801064f0:	50                   	push   %eax
801064f1:	e8 88 d8 ff ff       	call   80103d7e <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801064f6:	83 c4 08             	add    $0x8,%esp
801064f9:	ff 75 e0             	pushl  -0x20(%ebp)
801064fc:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80106502:	50                   	push   %eax
80106503:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106508:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010650b:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010650e:	e8 8d f8 ff ff       	call   80105da0 <mappages>
80106513:	83 c4 10             	add    $0x10,%esp
80106516:	85 c0                	test   %eax,%eax
80106518:	78 25                	js     8010653f <copyuvm+0xc0>
  for(i = 0; i < sz; i += PGSIZE){
8010651a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106520:	e9 7c ff ff ff       	jmp    801064a1 <copyuvm+0x22>
      panic("copyuvm: pte should exist");
80106525:	83 ec 0c             	sub    $0xc,%esp
80106528:	68 bc 6f 10 80       	push   $0x80106fbc
8010652d:	e8 23 9e ff ff       	call   80100355 <panic>
      panic("copyuvm: page not present");
80106532:	83 ec 0c             	sub    $0xc,%esp
80106535:	68 d6 6f 10 80       	push   $0x80106fd6
8010653a:	e8 16 9e ff ff       	call   80100355 <panic>
      kfree(mem);
8010653f:	83 ec 0c             	sub    $0xc,%esp
80106542:	57                   	push   %edi
80106543:	e8 8d ba ff ff       	call   80101fd5 <kfree>
      goto bad;
80106548:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d, 1);
8010654b:	83 ec 08             	sub    $0x8,%esp
8010654e:	6a 01                	push   $0x1
80106550:	ff 75 dc             	pushl  -0x24(%ebp)
80106553:	e8 ee fd ff ff       	call   80106346 <freevm>
  return 0;
80106558:	83 c4 10             	add    $0x10,%esp
8010655b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
80106562:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106565:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106568:	5b                   	pop    %ebx
80106569:	5e                   	pop    %esi
8010656a:	5f                   	pop    %edi
8010656b:	5d                   	pop    %ebp
8010656c:	c3                   	ret    

8010656d <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010656d:	f3 0f 1e fb          	endbr32 
80106571:	55                   	push   %ebp
80106572:	89 e5                	mov    %esp,%ebp
80106574:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106577:	b9 00 00 00 00       	mov    $0x0,%ecx
8010657c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010657f:	8b 45 08             	mov    0x8(%ebp),%eax
80106582:	e8 a8 f7 ff ff       	call   80105d2f <walkpgdir>
  if((*pte & PTE_P) == 0)
80106587:	8b 00                	mov    (%eax),%eax
80106589:	a8 01                	test   $0x1,%al
8010658b:	74 10                	je     8010659d <uva2ka+0x30>
    return 0;
  if((*pte & PTE_U) == 0)
8010658d:	a8 04                	test   $0x4,%al
8010658f:	74 13                	je     801065a4 <uva2ka+0x37>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106591:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106596:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010659b:	c9                   	leave  
8010659c:	c3                   	ret    
    return 0;
8010659d:	b8 00 00 00 00       	mov    $0x0,%eax
801065a2:	eb f7                	jmp    8010659b <uva2ka+0x2e>
    return 0;
801065a4:	b8 00 00 00 00       	mov    $0x0,%eax
801065a9:	eb f0                	jmp    8010659b <uva2ka+0x2e>

801065ab <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801065ab:	f3 0f 1e fb          	endbr32 
801065af:	55                   	push   %ebp
801065b0:	89 e5                	mov    %esp,%ebp
801065b2:	57                   	push   %edi
801065b3:	56                   	push   %esi
801065b4:	53                   	push   %ebx
801065b5:	83 ec 0c             	sub    $0xc,%esp
801065b8:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801065bb:	eb 25                	jmp    801065e2 <copyout+0x37>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801065bd:	8b 55 0c             	mov    0xc(%ebp),%edx
801065c0:	29 f2                	sub    %esi,%edx
801065c2:	01 d0                	add    %edx,%eax
801065c4:	83 ec 04             	sub    $0x4,%esp
801065c7:	53                   	push   %ebx
801065c8:	ff 75 10             	pushl  0x10(%ebp)
801065cb:	50                   	push   %eax
801065cc:	e8 ad d7 ff ff       	call   80103d7e <memmove>
    len -= n;
801065d1:	29 df                	sub    %ebx,%edi
    buf += n;
801065d3:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801065d6:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
801065dc:	89 45 0c             	mov    %eax,0xc(%ebp)
801065df:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
801065e2:	85 ff                	test   %edi,%edi
801065e4:	74 2f                	je     80106615 <copyout+0x6a>
    va0 = (uint)PGROUNDDOWN(va);
801065e6:	8b 75 0c             	mov    0xc(%ebp),%esi
801065e9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801065ef:	83 ec 08             	sub    $0x8,%esp
801065f2:	56                   	push   %esi
801065f3:	ff 75 08             	pushl  0x8(%ebp)
801065f6:	e8 72 ff ff ff       	call   8010656d <uva2ka>
    if(pa0 == 0)
801065fb:	83 c4 10             	add    $0x10,%esp
801065fe:	85 c0                	test   %eax,%eax
80106600:	74 20                	je     80106622 <copyout+0x77>
    n = PGSIZE - (va - va0);
80106602:	89 f3                	mov    %esi,%ebx
80106604:	2b 5d 0c             	sub    0xc(%ebp),%ebx
80106607:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010660d:	39 df                	cmp    %ebx,%edi
8010660f:	73 ac                	jae    801065bd <copyout+0x12>
      n = len;
80106611:	89 fb                	mov    %edi,%ebx
80106613:	eb a8                	jmp    801065bd <copyout+0x12>
  }
  return 0;
80106615:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010661a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010661d:	5b                   	pop    %ebx
8010661e:	5e                   	pop    %esi
8010661f:	5f                   	pop    %edi
80106620:	5d                   	pop    %ebp
80106621:	c3                   	ret    
      return -1;
80106622:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106627:	eb f1                	jmp    8010661a <copyout+0x6f>
