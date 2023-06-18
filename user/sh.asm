
sh:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
   9:	8b 5d 08             	mov    0x8(%ebp),%ebx
   c:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
   f:	83 ec 08             	sub    $0x8,%esp
  12:	68 f8 0f 00 00       	push   $0xff8
  17:	6a 02                	push   $0x2
  19:	e8 31 0d 00 00       	call   d4f <printf>
  memset(buf, 0, nbuf);
  1e:	83 c4 0c             	add    $0xc,%esp
  21:	56                   	push   %esi
  22:	6a 00                	push   $0x0
  24:	53                   	push   %ebx
  25:	e8 a9 0a 00 00       	call   ad3 <memset>
  gets(buf, nbuf);
  2a:	83 c4 08             	add    $0x8,%esp
  2d:	56                   	push   %esi
  2e:	53                   	push   %ebx
  2f:	e8 da 0a 00 00       	call   b0e <gets>
  if(buf[0] == 0) // EOF
  34:	83 c4 10             	add    $0x10,%esp
  37:	80 3b 00             	cmpb   $0x0,(%ebx)
  3a:	74 0c                	je     48 <getcmd+0x48>
    return -1;
  return 0;
  3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  44:	5b                   	pop    %ebx
  45:	5e                   	pop    %esi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    
    return -1;
  48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4d:	eb f2                	jmp    41 <getcmd+0x41>

0000004f <panic>:
  exit(0);
}

void
panic(char *s)
{
  4f:	f3 0f 1e fb          	endbr32 
  53:	55                   	push   %ebp
  54:	89 e5                	mov    %esp,%ebp
  56:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
  59:	ff 75 08             	pushl  0x8(%ebp)
  5c:	68 95 10 00 00       	push   $0x1095
  61:	6a 02                	push   $0x2
  63:	e8 e7 0c 00 00       	call   d4f <printf>
  exit(0);
  68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  6f:	e8 9c 0b 00 00       	call   c10 <exit>

00000074 <fork1>:
}

int
fork1(void)
{
  74:	f3 0f 1e fb          	endbr32 
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  7b:	83 ec 08             	sub    $0x8,%esp
  int pid;

  pid = fork();
  7e:	e8 85 0b 00 00       	call   c08 <fork>
  if(pid == -1)
  83:	83 f8 ff             	cmp    $0xffffffff,%eax
  86:	74 02                	je     8a <fork1+0x16>
    panic("fork");
  return pid;
}
  88:	c9                   	leave  
  89:	c3                   	ret    
    panic("fork");
  8a:	83 ec 0c             	sub    $0xc,%esp
  8d:	68 fb 0f 00 00       	push   $0xffb
  92:	e8 b8 ff ff ff       	call   4f <panic>

00000097 <runcmd>:
{
  97:	f3 0f 1e fb          	endbr32 
  9b:	55                   	push   %ebp
  9c:	89 e5                	mov    %esp,%ebp
  9e:	53                   	push   %ebx
  9f:	83 ec 14             	sub    $0x14,%esp
  a2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
  a5:	85 db                	test   %ebx,%ebx
  a7:	74 0f                	je     b8 <runcmd+0x21>
  switch(cmd->type){
  a9:	8b 03                	mov    (%ebx),%eax
  ab:	83 f8 05             	cmp    $0x5,%eax
  ae:	77 12                	ja     c2 <runcmd+0x2b>
  b0:	3e ff 24 85 c0 10 00 	notrack jmp *0x10c0(,%eax,4)
  b7:	00 
    exit(0);
  b8:	83 ec 0c             	sub    $0xc,%esp
  bb:	6a 00                	push   $0x0
  bd:	e8 4e 0b 00 00       	call   c10 <exit>
    panic("runcmd");
  c2:	83 ec 0c             	sub    $0xc,%esp
  c5:	68 00 10 00 00       	push   $0x1000
  ca:	e8 80 ff ff ff       	call   4f <panic>
    if(ecmd->argv[0] == 0)
  cf:	8b 43 04             	mov    0x4(%ebx),%eax
  d2:	85 c0                	test   %eax,%eax
  d4:	74 2c                	je     102 <runcmd+0x6b>
    exec(ecmd->argv[0], ecmd->argv);
  d6:	8d 53 04             	lea    0x4(%ebx),%edx
  d9:	83 ec 08             	sub    $0x8,%esp
  dc:	52                   	push   %edx
  dd:	50                   	push   %eax
  de:	e8 65 0b 00 00       	call   c48 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
  e3:	83 c4 0c             	add    $0xc,%esp
  e6:	ff 73 04             	pushl  0x4(%ebx)
  e9:	68 07 10 00 00       	push   $0x1007
  ee:	6a 02                	push   $0x2
  f0:	e8 5a 0c 00 00       	call   d4f <printf>
    break;
  f5:	83 c4 10             	add    $0x10,%esp
  exit(0);
  f8:	83 ec 0c             	sub    $0xc,%esp
  fb:	6a 00                	push   $0x0
  fd:	e8 0e 0b 00 00       	call   c10 <exit>
      exit(0);
 102:	83 ec 0c             	sub    $0xc,%esp
 105:	6a 00                	push   $0x0
 107:	e8 04 0b 00 00       	call   c10 <exit>
    close(rcmd->fd);
 10c:	83 ec 0c             	sub    $0xc,%esp
 10f:	ff 73 14             	pushl  0x14(%ebx)
 112:	e8 21 0b 00 00       	call   c38 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
 117:	83 c4 08             	add    $0x8,%esp
 11a:	ff 73 10             	pushl  0x10(%ebx)
 11d:	ff 73 08             	pushl  0x8(%ebx)
 120:	e8 2b 0b 00 00       	call   c50 <open>
 125:	83 c4 10             	add    $0x10,%esp
 128:	85 c0                	test   %eax,%eax
 12a:	78 0b                	js     137 <runcmd+0xa0>
    runcmd(rcmd->cmd);
 12c:	83 ec 0c             	sub    $0xc,%esp
 12f:	ff 73 04             	pushl  0x4(%ebx)
 132:	e8 60 ff ff ff       	call   97 <runcmd>
      printf(2, "open %s failed\n", rcmd->file);
 137:	83 ec 04             	sub    $0x4,%esp
 13a:	ff 73 08             	pushl  0x8(%ebx)
 13d:	68 17 10 00 00       	push   $0x1017
 142:	6a 02                	push   $0x2
 144:	e8 06 0c 00 00       	call   d4f <printf>
      exit(0);
 149:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 150:	e8 bb 0a 00 00       	call   c10 <exit>
    if(fork1() == 0)
 155:	e8 1a ff ff ff       	call   74 <fork1>
 15a:	85 c0                	test   %eax,%eax
 15c:	74 15                	je     173 <runcmd+0xdc>
    wait(NULL);
 15e:	83 ec 0c             	sub    $0xc,%esp
 161:	6a 00                	push   $0x0
 163:	e8 b0 0a 00 00       	call   c18 <wait>
    runcmd(lcmd->right);
 168:	83 c4 04             	add    $0x4,%esp
 16b:	ff 73 08             	pushl  0x8(%ebx)
 16e:	e8 24 ff ff ff       	call   97 <runcmd>
      runcmd(lcmd->left);
 173:	83 ec 0c             	sub    $0xc,%esp
 176:	ff 73 04             	pushl  0x4(%ebx)
 179:	e8 19 ff ff ff       	call   97 <runcmd>
    if(pipe(p) < 0)
 17e:	83 ec 0c             	sub    $0xc,%esp
 181:	8d 45 f0             	lea    -0x10(%ebp),%eax
 184:	50                   	push   %eax
 185:	e8 96 0a 00 00       	call   c20 <pipe>
 18a:	83 c4 10             	add    $0x10,%esp
 18d:	85 c0                	test   %eax,%eax
 18f:	78 48                	js     1d9 <runcmd+0x142>
    if(fork1() == 0){
 191:	e8 de fe ff ff       	call   74 <fork1>
 196:	85 c0                	test   %eax,%eax
 198:	74 4c                	je     1e6 <runcmd+0x14f>
    if(fork1() == 0){
 19a:	e8 d5 fe ff ff       	call   74 <fork1>
 19f:	85 c0                	test   %eax,%eax
 1a1:	74 71                	je     214 <runcmd+0x17d>
    close(p[0]);
 1a3:	83 ec 0c             	sub    $0xc,%esp
 1a6:	ff 75 f0             	pushl  -0x10(%ebp)
 1a9:	e8 8a 0a 00 00       	call   c38 <close>
    close(p[1]);
 1ae:	83 c4 04             	add    $0x4,%esp
 1b1:	ff 75 f4             	pushl  -0xc(%ebp)
 1b4:	e8 7f 0a 00 00       	call   c38 <close>
    wait(NULL);
 1b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1c0:	e8 53 0a 00 00       	call   c18 <wait>
    wait(NULL);
 1c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1cc:	e8 47 0a 00 00       	call   c18 <wait>
    break;
 1d1:	83 c4 10             	add    $0x10,%esp
 1d4:	e9 1f ff ff ff       	jmp    f8 <runcmd+0x61>
      panic("pipe");
 1d9:	83 ec 0c             	sub    $0xc,%esp
 1dc:	68 27 10 00 00       	push   $0x1027
 1e1:	e8 69 fe ff ff       	call   4f <panic>
      dup2(p[1],1);
 1e6:	83 ec 08             	sub    $0x8,%esp
 1e9:	6a 01                	push   $0x1
 1eb:	ff 75 f4             	pushl  -0xc(%ebp)
 1ee:	e8 c5 0a 00 00       	call   cb8 <dup2>
      close(p[0]);
 1f3:	83 c4 04             	add    $0x4,%esp
 1f6:	ff 75 f0             	pushl  -0x10(%ebp)
 1f9:	e8 3a 0a 00 00       	call   c38 <close>
      close(p[1]);
 1fe:	83 c4 04             	add    $0x4,%esp
 201:	ff 75 f4             	pushl  -0xc(%ebp)
 204:	e8 2f 0a 00 00       	call   c38 <close>
      runcmd(pcmd->left);
 209:	83 c4 04             	add    $0x4,%esp
 20c:	ff 73 04             	pushl  0x4(%ebx)
 20f:	e8 83 fe ff ff       	call   97 <runcmd>
      dup2(p[0],0);
 214:	83 ec 08             	sub    $0x8,%esp
 217:	6a 00                	push   $0x0
 219:	ff 75 f0             	pushl  -0x10(%ebp)
 21c:	e8 97 0a 00 00       	call   cb8 <dup2>
      close(p[0]);
 221:	83 c4 04             	add    $0x4,%esp
 224:	ff 75 f0             	pushl  -0x10(%ebp)
 227:	e8 0c 0a 00 00       	call   c38 <close>
      close(p[1]);
 22c:	83 c4 04             	add    $0x4,%esp
 22f:	ff 75 f4             	pushl  -0xc(%ebp)
 232:	e8 01 0a 00 00       	call   c38 <close>
      runcmd(pcmd->right);
 237:	83 c4 04             	add    $0x4,%esp
 23a:	ff 73 08             	pushl  0x8(%ebx)
 23d:	e8 55 fe ff ff       	call   97 <runcmd>
    if(fork1() == 0)
 242:	e8 2d fe ff ff       	call   74 <fork1>
 247:	85 c0                	test   %eax,%eax
 249:	0f 85 a9 fe ff ff    	jne    f8 <runcmd+0x61>
      runcmd(bcmd->cmd);
 24f:	83 ec 0c             	sub    $0xc,%esp
 252:	ff 73 04             	pushl  0x4(%ebx)
 255:	e8 3d fe ff ff       	call   97 <runcmd>

0000025a <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
 25a:	f3 0f 1e fb          	endbr32 
 25e:	55                   	push   %ebp
 25f:	89 e5                	mov    %esp,%ebp
 261:	53                   	push   %ebx
 262:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 265:	6a 54                	push   $0x54
 267:	e8 01 0d 00 00       	call   f6d <malloc>
 26c:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 26e:	83 c4 0c             	add    $0xc,%esp
 271:	6a 54                	push   $0x54
 273:	6a 00                	push   $0x0
 275:	50                   	push   %eax
 276:	e8 58 08 00 00       	call   ad3 <memset>
  cmd->type = EXEC;
 27b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
 281:	89 d8                	mov    %ebx,%eax
 283:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 286:	c9                   	leave  
 287:	c3                   	ret    

00000288 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
 288:	f3 0f 1e fb          	endbr32 
 28c:	55                   	push   %ebp
 28d:	89 e5                	mov    %esp,%ebp
 28f:	53                   	push   %ebx
 290:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
 293:	6a 18                	push   $0x18
 295:	e8 d3 0c 00 00       	call   f6d <malloc>
 29a:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 29c:	83 c4 0c             	add    $0xc,%esp
 29f:	6a 18                	push   $0x18
 2a1:	6a 00                	push   $0x0
 2a3:	50                   	push   %eax
 2a4:	e8 2a 08 00 00       	call   ad3 <memset>
  cmd->type = REDIR;
 2a9:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
 2b2:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
 2b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b8:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
 2bb:	8b 45 10             	mov    0x10(%ebp),%eax
 2be:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
 2c1:	8b 45 14             	mov    0x14(%ebp),%eax
 2c4:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
 2c7:	8b 45 18             	mov    0x18(%ebp),%eax
 2ca:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
 2cd:	89 d8                	mov    %ebx,%eax
 2cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2d2:	c9                   	leave  
 2d3:	c3                   	ret    

000002d4 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
 2d4:	f3 0f 1e fb          	endbr32 
 2d8:	55                   	push   %ebp
 2d9:	89 e5                	mov    %esp,%ebp
 2db:	53                   	push   %ebx
 2dc:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
 2df:	6a 0c                	push   $0xc
 2e1:	e8 87 0c 00 00       	call   f6d <malloc>
 2e6:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 2e8:	83 c4 0c             	add    $0xc,%esp
 2eb:	6a 0c                	push   $0xc
 2ed:	6a 00                	push   $0x0
 2ef:	50                   	push   %eax
 2f0:	e8 de 07 00 00       	call   ad3 <memset>
  cmd->type = PIPE;
 2f5:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
 2fb:	8b 45 08             	mov    0x8(%ebp),%eax
 2fe:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
 301:	8b 45 0c             	mov    0xc(%ebp),%eax
 304:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
 307:	89 d8                	mov    %ebx,%eax
 309:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 30c:	c9                   	leave  
 30d:	c3                   	ret    

0000030e <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
 30e:	f3 0f 1e fb          	endbr32 
 312:	55                   	push   %ebp
 313:	89 e5                	mov    %esp,%ebp
 315:	53                   	push   %ebx
 316:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 319:	6a 0c                	push   $0xc
 31b:	e8 4d 0c 00 00       	call   f6d <malloc>
 320:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 322:	83 c4 0c             	add    $0xc,%esp
 325:	6a 0c                	push   $0xc
 327:	6a 00                	push   $0x0
 329:	50                   	push   %eax
 32a:	e8 a4 07 00 00       	call   ad3 <memset>
  cmd->type = LIST;
 32f:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
 335:	8b 45 08             	mov    0x8(%ebp),%eax
 338:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
 33b:	8b 45 0c             	mov    0xc(%ebp),%eax
 33e:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
 341:	89 d8                	mov    %ebx,%eax
 343:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 346:	c9                   	leave  
 347:	c3                   	ret    

00000348 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
 348:	f3 0f 1e fb          	endbr32 
 34c:	55                   	push   %ebp
 34d:	89 e5                	mov    %esp,%ebp
 34f:	53                   	push   %ebx
 350:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 353:	6a 08                	push   $0x8
 355:	e8 13 0c 00 00       	call   f6d <malloc>
 35a:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 35c:	83 c4 0c             	add    $0xc,%esp
 35f:	6a 08                	push   $0x8
 361:	6a 00                	push   $0x0
 363:	50                   	push   %eax
 364:	e8 6a 07 00 00       	call   ad3 <memset>
  cmd->type = BACK;
 369:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
 36f:	8b 45 08             	mov    0x8(%ebp),%eax
 372:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
 375:	89 d8                	mov    %ebx,%eax
 377:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 37a:	c9                   	leave  
 37b:	c3                   	ret    

0000037c <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
 37c:	f3 0f 1e fb          	endbr32 
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	57                   	push   %edi
 384:	56                   	push   %esi
 385:	53                   	push   %ebx
 386:	83 ec 0c             	sub    $0xc,%esp
 389:	8b 75 0c             	mov    0xc(%ebp),%esi
 38c:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *s;
  int ret;

  s = *ps;
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	8b 18                	mov    (%eax),%ebx
  while(s < es && strchr(whitespace, *s))
 394:	39 f3                	cmp    %esi,%ebx
 396:	73 1b                	jae    3b3 <gettoken+0x37>
 398:	83 ec 08             	sub    $0x8,%esp
 39b:	0f be 03             	movsbl (%ebx),%eax
 39e:	50                   	push   %eax
 39f:	68 88 16 00 00       	push   $0x1688
 3a4:	e8 44 07 00 00       	call   aed <strchr>
 3a9:	83 c4 10             	add    $0x10,%esp
 3ac:	85 c0                	test   %eax,%eax
 3ae:	74 03                	je     3b3 <gettoken+0x37>
    s++;
 3b0:	43                   	inc    %ebx
 3b1:	eb e1                	jmp    394 <gettoken+0x18>
  if(q)
 3b3:	85 ff                	test   %edi,%edi
 3b5:	74 02                	je     3b9 <gettoken+0x3d>
    *q = s;
 3b7:	89 1f                	mov    %ebx,(%edi)
  ret = *s;
 3b9:	8a 03                	mov    (%ebx),%al
 3bb:	0f be f8             	movsbl %al,%edi
  switch(*s){
 3be:	3c 3c                	cmp    $0x3c,%al
 3c0:	7f 25                	jg     3e7 <gettoken+0x6b>
 3c2:	3c 3b                	cmp    $0x3b,%al
 3c4:	7d 13                	jge    3d9 <gettoken+0x5d>
 3c6:	84 c0                	test   %al,%al
 3c8:	74 10                	je     3da <gettoken+0x5e>
 3ca:	78 3d                	js     409 <gettoken+0x8d>
 3cc:	3c 26                	cmp    $0x26,%al
 3ce:	74 09                	je     3d9 <gettoken+0x5d>
 3d0:	7c 37                	jl     409 <gettoken+0x8d>
 3d2:	83 e8 28             	sub    $0x28,%eax
 3d5:	3c 01                	cmp    $0x1,%al
 3d7:	77 30                	ja     409 <gettoken+0x8d>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
 3d9:	43                   	inc    %ebx
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
 3da:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3de:	74 73                	je     453 <gettoken+0xd7>
    *eq = s;
 3e0:	8b 45 14             	mov    0x14(%ebp),%eax
 3e3:	89 18                	mov    %ebx,(%eax)
 3e5:	eb 6c                	jmp    453 <gettoken+0xd7>
  switch(*s){
 3e7:	3c 3e                	cmp    $0x3e,%al
 3e9:	75 0d                	jne    3f8 <gettoken+0x7c>
    s++;
 3eb:	8d 43 01             	lea    0x1(%ebx),%eax
    if(*s == '>'){
 3ee:	80 7b 01 3e          	cmpb   $0x3e,0x1(%ebx)
 3f2:	74 0a                	je     3fe <gettoken+0x82>
    s++;
 3f4:	89 c3                	mov    %eax,%ebx
 3f6:	eb e2                	jmp    3da <gettoken+0x5e>
  switch(*s){
 3f8:	3c 7c                	cmp    $0x7c,%al
 3fa:	75 0d                	jne    409 <gettoken+0x8d>
 3fc:	eb db                	jmp    3d9 <gettoken+0x5d>
      s++;
 3fe:	83 c3 02             	add    $0x2,%ebx
      ret = '+';
 401:	bf 2b 00 00 00       	mov    $0x2b,%edi
 406:	eb d2                	jmp    3da <gettoken+0x5e>
      s++;
 408:	43                   	inc    %ebx
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
 409:	39 f3                	cmp    %esi,%ebx
 40b:	73 37                	jae    444 <gettoken+0xc8>
 40d:	83 ec 08             	sub    $0x8,%esp
 410:	0f be 03             	movsbl (%ebx),%eax
 413:	50                   	push   %eax
 414:	68 88 16 00 00       	push   $0x1688
 419:	e8 cf 06 00 00       	call   aed <strchr>
 41e:	83 c4 10             	add    $0x10,%esp
 421:	85 c0                	test   %eax,%eax
 423:	75 26                	jne    44b <gettoken+0xcf>
 425:	83 ec 08             	sub    $0x8,%esp
 428:	0f be 03             	movsbl (%ebx),%eax
 42b:	50                   	push   %eax
 42c:	68 80 16 00 00       	push   $0x1680
 431:	e8 b7 06 00 00       	call   aed <strchr>
 436:	83 c4 10             	add    $0x10,%esp
 439:	85 c0                	test   %eax,%eax
 43b:	74 cb                	je     408 <gettoken+0x8c>
    ret = 'a';
 43d:	bf 61 00 00 00       	mov    $0x61,%edi
 442:	eb 96                	jmp    3da <gettoken+0x5e>
 444:	bf 61 00 00 00       	mov    $0x61,%edi
 449:	eb 8f                	jmp    3da <gettoken+0x5e>
 44b:	bf 61 00 00 00       	mov    $0x61,%edi
 450:	eb 88                	jmp    3da <gettoken+0x5e>

  while(s < es && strchr(whitespace, *s))
    s++;
 452:	43                   	inc    %ebx
  while(s < es && strchr(whitespace, *s))
 453:	39 f3                	cmp    %esi,%ebx
 455:	73 18                	jae    46f <gettoken+0xf3>
 457:	83 ec 08             	sub    $0x8,%esp
 45a:	0f be 03             	movsbl (%ebx),%eax
 45d:	50                   	push   %eax
 45e:	68 88 16 00 00       	push   $0x1688
 463:	e8 85 06 00 00       	call   aed <strchr>
 468:	83 c4 10             	add    $0x10,%esp
 46b:	85 c0                	test   %eax,%eax
 46d:	75 e3                	jne    452 <gettoken+0xd6>
  *ps = s;
 46f:	8b 45 08             	mov    0x8(%ebp),%eax
 472:	89 18                	mov    %ebx,(%eax)
  return ret;
}
 474:	89 f8                	mov    %edi,%eax
 476:	8d 65 f4             	lea    -0xc(%ebp),%esp
 479:	5b                   	pop    %ebx
 47a:	5e                   	pop    %esi
 47b:	5f                   	pop    %edi
 47c:	5d                   	pop    %ebp
 47d:	c3                   	ret    

0000047e <peek>:

int
peek(char **ps, char *es, char *toks)
{
 47e:	f3 0f 1e fb          	endbr32 
 482:	55                   	push   %ebp
 483:	89 e5                	mov    %esp,%ebp
 485:	57                   	push   %edi
 486:	56                   	push   %esi
 487:	53                   	push   %ebx
 488:	83 ec 0c             	sub    $0xc,%esp
 48b:	8b 7d 08             	mov    0x8(%ebp),%edi
 48e:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
 491:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
 493:	39 f3                	cmp    %esi,%ebx
 495:	73 1b                	jae    4b2 <peek+0x34>
 497:	83 ec 08             	sub    $0x8,%esp
 49a:	0f be 03             	movsbl (%ebx),%eax
 49d:	50                   	push   %eax
 49e:	68 88 16 00 00       	push   $0x1688
 4a3:	e8 45 06 00 00       	call   aed <strchr>
 4a8:	83 c4 10             	add    $0x10,%esp
 4ab:	85 c0                	test   %eax,%eax
 4ad:	74 03                	je     4b2 <peek+0x34>
    s++;
 4af:	43                   	inc    %ebx
 4b0:	eb e1                	jmp    493 <peek+0x15>
  *ps = s;
 4b2:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
 4b4:	8a 03                	mov    (%ebx),%al
 4b6:	84 c0                	test   %al,%al
 4b8:	75 0d                	jne    4c7 <peek+0x49>
 4ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4c2:	5b                   	pop    %ebx
 4c3:	5e                   	pop    %esi
 4c4:	5f                   	pop    %edi
 4c5:	5d                   	pop    %ebp
 4c6:	c3                   	ret    
  return *s && strchr(toks, *s);
 4c7:	83 ec 08             	sub    $0x8,%esp
 4ca:	0f be c0             	movsbl %al,%eax
 4cd:	50                   	push   %eax
 4ce:	ff 75 10             	pushl  0x10(%ebp)
 4d1:	e8 17 06 00 00       	call   aed <strchr>
 4d6:	83 c4 10             	add    $0x10,%esp
 4d9:	85 c0                	test   %eax,%eax
 4db:	74 07                	je     4e4 <peek+0x66>
 4dd:	b8 01 00 00 00       	mov    $0x1,%eax
 4e2:	eb db                	jmp    4bf <peek+0x41>
 4e4:	b8 00 00 00 00       	mov    $0x0,%eax
 4e9:	eb d4                	jmp    4bf <peek+0x41>

000004eb <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
 4eb:	f3 0f 1e fb          	endbr32 
 4ef:	55                   	push   %ebp
 4f0:	89 e5                	mov    %esp,%ebp
 4f2:	57                   	push   %edi
 4f3:	56                   	push   %esi
 4f4:	53                   	push   %ebx
 4f5:	83 ec 1c             	sub    $0x1c,%esp
 4f8:	8b 7d 0c             	mov    0xc(%ebp),%edi
 4fb:	8b 75 10             	mov    0x10(%ebp),%esi
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
 4fe:	eb 28                	jmp    528 <parseredirs+0x3d>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
 500:	83 ec 0c             	sub    $0xc,%esp
 503:	68 2c 10 00 00       	push   $0x102c
 508:	e8 42 fb ff ff       	call   4f <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
 50d:	83 ec 0c             	sub    $0xc,%esp
 510:	6a 00                	push   $0x0
 512:	6a 00                	push   $0x0
 514:	ff 75 e0             	pushl  -0x20(%ebp)
 517:	ff 75 e4             	pushl  -0x1c(%ebp)
 51a:	ff 75 08             	pushl  0x8(%ebp)
 51d:	e8 66 fd ff ff       	call   288 <redircmd>
 522:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
 525:	83 c4 20             	add    $0x20,%esp
  while(peek(ps, es, "<>")){
 528:	83 ec 04             	sub    $0x4,%esp
 52b:	68 49 10 00 00       	push   $0x1049
 530:	56                   	push   %esi
 531:	57                   	push   %edi
 532:	e8 47 ff ff ff       	call   47e <peek>
 537:	83 c4 10             	add    $0x10,%esp
 53a:	85 c0                	test   %eax,%eax
 53c:	74 76                	je     5b4 <parseredirs+0xc9>
    tok = gettoken(ps, es, 0, 0);
 53e:	6a 00                	push   $0x0
 540:	6a 00                	push   $0x0
 542:	56                   	push   %esi
 543:	57                   	push   %edi
 544:	e8 33 fe ff ff       	call   37c <gettoken>
 549:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
 54b:	8d 45 e0             	lea    -0x20(%ebp),%eax
 54e:	50                   	push   %eax
 54f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 552:	50                   	push   %eax
 553:	56                   	push   %esi
 554:	57                   	push   %edi
 555:	e8 22 fe ff ff       	call   37c <gettoken>
 55a:	83 c4 20             	add    $0x20,%esp
 55d:	83 f8 61             	cmp    $0x61,%eax
 560:	75 9e                	jne    500 <parseredirs+0x15>
    switch(tok){
 562:	83 fb 3c             	cmp    $0x3c,%ebx
 565:	74 a6                	je     50d <parseredirs+0x22>
 567:	83 fb 3e             	cmp    $0x3e,%ebx
 56a:	74 25                	je     591 <parseredirs+0xa6>
 56c:	83 fb 2b             	cmp    $0x2b,%ebx
 56f:	75 b7                	jne    528 <parseredirs+0x3d>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
 571:	83 ec 0c             	sub    $0xc,%esp
 574:	6a 01                	push   $0x1
 576:	68 01 02 00 00       	push   $0x201
 57b:	ff 75 e0             	pushl  -0x20(%ebp)
 57e:	ff 75 e4             	pushl  -0x1c(%ebp)
 581:	ff 75 08             	pushl  0x8(%ebp)
 584:	e8 ff fc ff ff       	call   288 <redircmd>
 589:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
 58c:	83 c4 20             	add    $0x20,%esp
 58f:	eb 97                	jmp    528 <parseredirs+0x3d>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
 591:	83 ec 0c             	sub    $0xc,%esp
 594:	6a 01                	push   $0x1
 596:	68 01 02 00 00       	push   $0x201
 59b:	ff 75 e0             	pushl  -0x20(%ebp)
 59e:	ff 75 e4             	pushl  -0x1c(%ebp)
 5a1:	ff 75 08             	pushl  0x8(%ebp)
 5a4:	e8 df fc ff ff       	call   288 <redircmd>
 5a9:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
 5ac:	83 c4 20             	add    $0x20,%esp
 5af:	e9 74 ff ff ff       	jmp    528 <parseredirs+0x3d>
    }
  }
  return cmd;
}
 5b4:	8b 45 08             	mov    0x8(%ebp),%eax
 5b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ba:	5b                   	pop    %ebx
 5bb:	5e                   	pop    %esi
 5bc:	5f                   	pop    %edi
 5bd:	5d                   	pop    %ebp
 5be:	c3                   	ret    

000005bf <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
 5bf:	f3 0f 1e fb          	endbr32 
 5c3:	55                   	push   %ebp
 5c4:	89 e5                	mov    %esp,%ebp
 5c6:	57                   	push   %edi
 5c7:	56                   	push   %esi
 5c8:	53                   	push   %ebx
 5c9:	83 ec 30             	sub    $0x30,%esp
 5cc:	8b 75 08             	mov    0x8(%ebp),%esi
 5cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
 5d2:	68 4c 10 00 00       	push   $0x104c
 5d7:	57                   	push   %edi
 5d8:	56                   	push   %esi
 5d9:	e8 a0 fe ff ff       	call   47e <peek>
 5de:	83 c4 10             	add    $0x10,%esp
 5e1:	85 c0                	test   %eax,%eax
 5e3:	75 1d                	jne    602 <parseexec+0x43>
 5e5:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
 5e7:	e8 6e fc ff ff       	call   25a <execcmd>
 5ec:	89 45 d0             	mov    %eax,-0x30(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
 5ef:	83 ec 04             	sub    $0x4,%esp
 5f2:	57                   	push   %edi
 5f3:	56                   	push   %esi
 5f4:	50                   	push   %eax
 5f5:	e8 f1 fe ff ff       	call   4eb <parseredirs>
 5fa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
 5fd:	83 c4 10             	add    $0x10,%esp
 600:	eb 3b                	jmp    63d <parseexec+0x7e>
    return parseblock(ps, es);
 602:	83 ec 08             	sub    $0x8,%esp
 605:	57                   	push   %edi
 606:	56                   	push   %esi
 607:	e8 95 01 00 00       	call   7a1 <parseblock>
 60c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 60f:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
 612:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 615:	8d 65 f4             	lea    -0xc(%ebp),%esp
 618:	5b                   	pop    %ebx
 619:	5e                   	pop    %esi
 61a:	5f                   	pop    %edi
 61b:	5d                   	pop    %ebp
 61c:	c3                   	ret    
      panic("syntax");
 61d:	83 ec 0c             	sub    $0xc,%esp
 620:	68 4e 10 00 00       	push   $0x104e
 625:	e8 25 fa ff ff       	call   4f <panic>
    ret = parseredirs(ret, ps, es);
 62a:	83 ec 04             	sub    $0x4,%esp
 62d:	57                   	push   %edi
 62e:	56                   	push   %esi
 62f:	ff 75 d4             	pushl  -0x2c(%ebp)
 632:	e8 b4 fe ff ff       	call   4eb <parseredirs>
 637:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 63a:	83 c4 10             	add    $0x10,%esp
  while(!peek(ps, es, "|)&;")){
 63d:	83 ec 04             	sub    $0x4,%esp
 640:	68 63 10 00 00       	push   $0x1063
 645:	57                   	push   %edi
 646:	56                   	push   %esi
 647:	e8 32 fe ff ff       	call   47e <peek>
 64c:	83 c4 10             	add    $0x10,%esp
 64f:	85 c0                	test   %eax,%eax
 651:	75 3f                	jne    692 <parseexec+0xd3>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
 653:	8d 45 e0             	lea    -0x20(%ebp),%eax
 656:	50                   	push   %eax
 657:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 65a:	50                   	push   %eax
 65b:	57                   	push   %edi
 65c:	56                   	push   %esi
 65d:	e8 1a fd ff ff       	call   37c <gettoken>
 662:	83 c4 10             	add    $0x10,%esp
 665:	85 c0                	test   %eax,%eax
 667:	74 29                	je     692 <parseexec+0xd3>
    if(tok != 'a')
 669:	83 f8 61             	cmp    $0x61,%eax
 66c:	75 af                	jne    61d <parseexec+0x5e>
    cmd->argv[argc] = q;
 66e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 671:	8b 55 d0             	mov    -0x30(%ebp),%edx
 674:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
 678:	8b 45 e0             	mov    -0x20(%ebp),%eax
 67b:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
 67f:	43                   	inc    %ebx
    if(argc >= MAXARGS)
 680:	83 fb 09             	cmp    $0x9,%ebx
 683:	7e a5                	jle    62a <parseexec+0x6b>
      panic("too many args");
 685:	83 ec 0c             	sub    $0xc,%esp
 688:	68 55 10 00 00       	push   $0x1055
 68d:	e8 bd f9 ff ff       	call   4f <panic>
  cmd->argv[argc] = 0;
 692:	8b 45 d0             	mov    -0x30(%ebp),%eax
 695:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
 69c:	00 
  cmd->eargv[argc] = 0;
 69d:	c7 44 98 2c 00 00 00 	movl   $0x0,0x2c(%eax,%ebx,4)
 6a4:	00 
  return ret;
 6a5:	e9 68 ff ff ff       	jmp    612 <parseexec+0x53>

000006aa <parsepipe>:
{
 6aa:	f3 0f 1e fb          	endbr32 
 6ae:	55                   	push   %ebp
 6af:	89 e5                	mov    %esp,%ebp
 6b1:	57                   	push   %edi
 6b2:	56                   	push   %esi
 6b3:	53                   	push   %ebx
 6b4:	83 ec 14             	sub    $0x14,%esp
 6b7:	8b 75 08             	mov    0x8(%ebp),%esi
 6ba:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
 6bd:	57                   	push   %edi
 6be:	56                   	push   %esi
 6bf:	e8 fb fe ff ff       	call   5bf <parseexec>
 6c4:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
 6c6:	83 c4 0c             	add    $0xc,%esp
 6c9:	68 68 10 00 00       	push   $0x1068
 6ce:	57                   	push   %edi
 6cf:	56                   	push   %esi
 6d0:	e8 a9 fd ff ff       	call   47e <peek>
 6d5:	83 c4 10             	add    $0x10,%esp
 6d8:	85 c0                	test   %eax,%eax
 6da:	75 0a                	jne    6e6 <parsepipe+0x3c>
}
 6dc:	89 d8                	mov    %ebx,%eax
 6de:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6e1:	5b                   	pop    %ebx
 6e2:	5e                   	pop    %esi
 6e3:	5f                   	pop    %edi
 6e4:	5d                   	pop    %ebp
 6e5:	c3                   	ret    
    gettoken(ps, es, 0, 0);
 6e6:	6a 00                	push   $0x0
 6e8:	6a 00                	push   $0x0
 6ea:	57                   	push   %edi
 6eb:	56                   	push   %esi
 6ec:	e8 8b fc ff ff       	call   37c <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
 6f1:	83 c4 08             	add    $0x8,%esp
 6f4:	57                   	push   %edi
 6f5:	56                   	push   %esi
 6f6:	e8 af ff ff ff       	call   6aa <parsepipe>
 6fb:	83 c4 08             	add    $0x8,%esp
 6fe:	50                   	push   %eax
 6ff:	53                   	push   %ebx
 700:	e8 cf fb ff ff       	call   2d4 <pipecmd>
 705:	89 c3                	mov    %eax,%ebx
 707:	83 c4 10             	add    $0x10,%esp
  return cmd;
 70a:	eb d0                	jmp    6dc <parsepipe+0x32>

0000070c <parseline>:
{
 70c:	f3 0f 1e fb          	endbr32 
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	57                   	push   %edi
 714:	56                   	push   %esi
 715:	53                   	push   %ebx
 716:	83 ec 14             	sub    $0x14,%esp
 719:	8b 75 08             	mov    0x8(%ebp),%esi
 71c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
 71f:	57                   	push   %edi
 720:	56                   	push   %esi
 721:	e8 84 ff ff ff       	call   6aa <parsepipe>
 726:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
 728:	83 c4 10             	add    $0x10,%esp
 72b:	83 ec 04             	sub    $0x4,%esp
 72e:	68 6a 10 00 00       	push   $0x106a
 733:	57                   	push   %edi
 734:	56                   	push   %esi
 735:	e8 44 fd ff ff       	call   47e <peek>
 73a:	83 c4 10             	add    $0x10,%esp
 73d:	85 c0                	test   %eax,%eax
 73f:	74 1a                	je     75b <parseline+0x4f>
    gettoken(ps, es, 0, 0);
 741:	6a 00                	push   $0x0
 743:	6a 00                	push   $0x0
 745:	57                   	push   %edi
 746:	56                   	push   %esi
 747:	e8 30 fc ff ff       	call   37c <gettoken>
    cmd = backcmd(cmd);
 74c:	89 1c 24             	mov    %ebx,(%esp)
 74f:	e8 f4 fb ff ff       	call   348 <backcmd>
 754:	89 c3                	mov    %eax,%ebx
 756:	83 c4 10             	add    $0x10,%esp
 759:	eb d0                	jmp    72b <parseline+0x1f>
  if(peek(ps, es, ";")){
 75b:	83 ec 04             	sub    $0x4,%esp
 75e:	68 66 10 00 00       	push   $0x1066
 763:	57                   	push   %edi
 764:	56                   	push   %esi
 765:	e8 14 fd ff ff       	call   47e <peek>
 76a:	83 c4 10             	add    $0x10,%esp
 76d:	85 c0                	test   %eax,%eax
 76f:	75 0a                	jne    77b <parseline+0x6f>
}
 771:	89 d8                	mov    %ebx,%eax
 773:	8d 65 f4             	lea    -0xc(%ebp),%esp
 776:	5b                   	pop    %ebx
 777:	5e                   	pop    %esi
 778:	5f                   	pop    %edi
 779:	5d                   	pop    %ebp
 77a:	c3                   	ret    
    gettoken(ps, es, 0, 0);
 77b:	6a 00                	push   $0x0
 77d:	6a 00                	push   $0x0
 77f:	57                   	push   %edi
 780:	56                   	push   %esi
 781:	e8 f6 fb ff ff       	call   37c <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
 786:	83 c4 08             	add    $0x8,%esp
 789:	57                   	push   %edi
 78a:	56                   	push   %esi
 78b:	e8 7c ff ff ff       	call   70c <parseline>
 790:	83 c4 08             	add    $0x8,%esp
 793:	50                   	push   %eax
 794:	53                   	push   %ebx
 795:	e8 74 fb ff ff       	call   30e <listcmd>
 79a:	89 c3                	mov    %eax,%ebx
 79c:	83 c4 10             	add    $0x10,%esp
  return cmd;
 79f:	eb d0                	jmp    771 <parseline+0x65>

000007a1 <parseblock>:
{
 7a1:	f3 0f 1e fb          	endbr32 
 7a5:	55                   	push   %ebp
 7a6:	89 e5                	mov    %esp,%ebp
 7a8:	57                   	push   %edi
 7a9:	56                   	push   %esi
 7aa:	53                   	push   %ebx
 7ab:	83 ec 10             	sub    $0x10,%esp
 7ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
 7b4:	68 4c 10 00 00       	push   $0x104c
 7b9:	56                   	push   %esi
 7ba:	53                   	push   %ebx
 7bb:	e8 be fc ff ff       	call   47e <peek>
 7c0:	83 c4 10             	add    $0x10,%esp
 7c3:	85 c0                	test   %eax,%eax
 7c5:	74 4b                	je     812 <parseblock+0x71>
  gettoken(ps, es, 0, 0);
 7c7:	6a 00                	push   $0x0
 7c9:	6a 00                	push   $0x0
 7cb:	56                   	push   %esi
 7cc:	53                   	push   %ebx
 7cd:	e8 aa fb ff ff       	call   37c <gettoken>
  cmd = parseline(ps, es);
 7d2:	83 c4 08             	add    $0x8,%esp
 7d5:	56                   	push   %esi
 7d6:	53                   	push   %ebx
 7d7:	e8 30 ff ff ff       	call   70c <parseline>
 7dc:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
 7de:	83 c4 0c             	add    $0xc,%esp
 7e1:	68 88 10 00 00       	push   $0x1088
 7e6:	56                   	push   %esi
 7e7:	53                   	push   %ebx
 7e8:	e8 91 fc ff ff       	call   47e <peek>
 7ed:	83 c4 10             	add    $0x10,%esp
 7f0:	85 c0                	test   %eax,%eax
 7f2:	74 2b                	je     81f <parseblock+0x7e>
  gettoken(ps, es, 0, 0);
 7f4:	6a 00                	push   $0x0
 7f6:	6a 00                	push   $0x0
 7f8:	56                   	push   %esi
 7f9:	53                   	push   %ebx
 7fa:	e8 7d fb ff ff       	call   37c <gettoken>
  cmd = parseredirs(cmd, ps, es);
 7ff:	83 c4 0c             	add    $0xc,%esp
 802:	56                   	push   %esi
 803:	53                   	push   %ebx
 804:	57                   	push   %edi
 805:	e8 e1 fc ff ff       	call   4eb <parseredirs>
}
 80a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 80d:	5b                   	pop    %ebx
 80e:	5e                   	pop    %esi
 80f:	5f                   	pop    %edi
 810:	5d                   	pop    %ebp
 811:	c3                   	ret    
    panic("parseblock");
 812:	83 ec 0c             	sub    $0xc,%esp
 815:	68 6c 10 00 00       	push   $0x106c
 81a:	e8 30 f8 ff ff       	call   4f <panic>
    panic("syntax - missing )");
 81f:	83 ec 0c             	sub    $0xc,%esp
 822:	68 77 10 00 00       	push   $0x1077
 827:	e8 23 f8 ff ff       	call   4f <panic>

0000082c <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
 82c:	f3 0f 1e fb          	endbr32 
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp
 833:	53                   	push   %ebx
 834:	83 ec 04             	sub    $0x4,%esp
 837:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
 83a:	85 db                	test   %ebx,%ebx
 83c:	74 39                	je     877 <nulterminate+0x4b>
    return 0;

  switch(cmd->type){
 83e:	8b 03                	mov    (%ebx),%eax
 840:	83 f8 05             	cmp    $0x5,%eax
 843:	77 32                	ja     877 <nulterminate+0x4b>
 845:	3e ff 24 85 d8 10 00 	notrack jmp *0x10d8(,%eax,4)
 84c:	00 
 84d:	b8 00 00 00 00       	mov    $0x0,%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
 852:	83 7c 83 04 00       	cmpl   $0x0,0x4(%ebx,%eax,4)
 857:	74 1e                	je     877 <nulterminate+0x4b>
      *ecmd->eargv[i] = 0;
 859:	8b 54 83 2c          	mov    0x2c(%ebx,%eax,4),%edx
 85d:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
 860:	40                   	inc    %eax
 861:	eb ef                	jmp    852 <nulterminate+0x26>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
 863:	83 ec 0c             	sub    $0xc,%esp
 866:	ff 73 04             	pushl  0x4(%ebx)
 869:	e8 be ff ff ff       	call   82c <nulterminate>
    *rcmd->efile = 0;
 86e:	8b 43 0c             	mov    0xc(%ebx),%eax
 871:	c6 00 00             	movb   $0x0,(%eax)
    break;
 874:	83 c4 10             	add    $0x10,%esp
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
 877:	89 d8                	mov    %ebx,%eax
 879:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 87c:	c9                   	leave  
 87d:	c3                   	ret    
    nulterminate(pcmd->left);
 87e:	83 ec 0c             	sub    $0xc,%esp
 881:	ff 73 04             	pushl  0x4(%ebx)
 884:	e8 a3 ff ff ff       	call   82c <nulterminate>
    nulterminate(pcmd->right);
 889:	83 c4 04             	add    $0x4,%esp
 88c:	ff 73 08             	pushl  0x8(%ebx)
 88f:	e8 98 ff ff ff       	call   82c <nulterminate>
    break;
 894:	83 c4 10             	add    $0x10,%esp
 897:	eb de                	jmp    877 <nulterminate+0x4b>
    nulterminate(lcmd->left);
 899:	83 ec 0c             	sub    $0xc,%esp
 89c:	ff 73 04             	pushl  0x4(%ebx)
 89f:	e8 88 ff ff ff       	call   82c <nulterminate>
    nulterminate(lcmd->right);
 8a4:	83 c4 04             	add    $0x4,%esp
 8a7:	ff 73 08             	pushl  0x8(%ebx)
 8aa:	e8 7d ff ff ff       	call   82c <nulterminate>
    break;
 8af:	83 c4 10             	add    $0x10,%esp
 8b2:	eb c3                	jmp    877 <nulterminate+0x4b>
    nulterminate(bcmd->cmd);
 8b4:	83 ec 0c             	sub    $0xc,%esp
 8b7:	ff 73 04             	pushl  0x4(%ebx)
 8ba:	e8 6d ff ff ff       	call   82c <nulterminate>
    break;
 8bf:	83 c4 10             	add    $0x10,%esp
 8c2:	eb b3                	jmp    877 <nulterminate+0x4b>

000008c4 <parsecmd>:
{
 8c4:	f3 0f 1e fb          	endbr32 
 8c8:	55                   	push   %ebp
 8c9:	89 e5                	mov    %esp,%ebp
 8cb:	56                   	push   %esi
 8cc:	53                   	push   %ebx
  es = s + strlen(s);
 8cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8d0:	83 ec 0c             	sub    $0xc,%esp
 8d3:	53                   	push   %ebx
 8d4:	e8 e0 01 00 00       	call   ab9 <strlen>
 8d9:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
 8db:	83 c4 08             	add    $0x8,%esp
 8de:	53                   	push   %ebx
 8df:	8d 45 08             	lea    0x8(%ebp),%eax
 8e2:	50                   	push   %eax
 8e3:	e8 24 fe ff ff       	call   70c <parseline>
 8e8:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
 8ea:	83 c4 0c             	add    $0xc,%esp
 8ed:	68 bf 10 00 00       	push   $0x10bf
 8f2:	53                   	push   %ebx
 8f3:	8d 45 08             	lea    0x8(%ebp),%eax
 8f6:	50                   	push   %eax
 8f7:	e8 82 fb ff ff       	call   47e <peek>
  if(s != es){
 8fc:	8b 45 08             	mov    0x8(%ebp),%eax
 8ff:	83 c4 10             	add    $0x10,%esp
 902:	39 d8                	cmp    %ebx,%eax
 904:	75 12                	jne    918 <parsecmd+0x54>
  nulterminate(cmd);
 906:	83 ec 0c             	sub    $0xc,%esp
 909:	56                   	push   %esi
 90a:	e8 1d ff ff ff       	call   82c <nulterminate>
}
 90f:	89 f0                	mov    %esi,%eax
 911:	8d 65 f8             	lea    -0x8(%ebp),%esp
 914:	5b                   	pop    %ebx
 915:	5e                   	pop    %esi
 916:	5d                   	pop    %ebp
 917:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
 918:	83 ec 04             	sub    $0x4,%esp
 91b:	50                   	push   %eax
 91c:	68 8a 10 00 00       	push   $0x108a
 921:	6a 02                	push   $0x2
 923:	e8 27 04 00 00       	call   d4f <printf>
    panic("syntax");
 928:	c7 04 24 4e 10 00 00 	movl   $0x104e,(%esp)
 92f:	e8 1b f7 ff ff       	call   4f <panic>

00000934 <main>:
{
 934:	f3 0f 1e fb          	endbr32 
 938:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 93c:	83 e4 f0             	and    $0xfffffff0,%esp
 93f:	ff 71 fc             	pushl  -0x4(%ecx)
 942:	55                   	push   %ebp
 943:	89 e5                	mov    %esp,%ebp
 945:	51                   	push   %ecx
 946:	83 ec 14             	sub    $0x14,%esp
  while((fd = open("console", O_RDWR)) >= 0){
 949:	83 ec 08             	sub    $0x8,%esp
 94c:	6a 02                	push   $0x2
 94e:	68 99 10 00 00       	push   $0x1099
 953:	e8 f8 02 00 00       	call   c50 <open>
 958:	83 c4 10             	add    $0x10,%esp
 95b:	85 c0                	test   %eax,%eax
 95d:	78 45                	js     9a4 <main+0x70>
    if(fd >= 3){
 95f:	83 f8 02             	cmp    $0x2,%eax
 962:	7e e5                	jle    949 <main+0x15>
      close(fd);
 964:	83 ec 0c             	sub    $0xc,%esp
 967:	50                   	push   %eax
 968:	e8 cb 02 00 00       	call   c38 <close>
      break;
 96d:	83 c4 10             	add    $0x10,%esp
 970:	eb 32                	jmp    9a4 <main+0x70>
    if(fork1() == 0)
 972:	e8 fd f6 ff ff       	call   74 <fork1>
 977:	85 c0                	test   %eax,%eax
 979:	0f 84 9a 00 00 00    	je     a19 <main+0xe5>
    wait(&status);
 97f:	83 ec 0c             	sub    $0xc,%esp
 982:	8d 45 f4             	lea    -0xc(%ebp),%eax
 985:	50                   	push   %eax
 986:	e8 8d 02 00 00       	call   c18 <wait>
    if (WIFEXITED(status)) {
 98b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98e:	83 c4 10             	add    $0x10,%esp
 991:	89 c2                	mov    %eax,%edx
 993:	83 e2 7f             	and    $0x7f,%edx
 996:	0f 84 92 00 00 00    	je     a2e <main+0xfa>
    } else if (WIFSIGNALED(status)) {
 99c:	85 d2                	test   %edx,%edx
 99e:	0f 85 a5 00 00 00    	jne    a49 <main+0x115>
  while(getcmd(buf, sizeof(buf)) >= 0){
 9a4:	83 ec 08             	sub    $0x8,%esp
 9a7:	6a 64                	push   $0x64
 9a9:	68 a0 16 00 00       	push   $0x16a0
 9ae:	e8 4d f6 ff ff       	call   0 <getcmd>
 9b3:	83 c4 10             	add    $0x10,%esp
 9b6:	85 c0                	test   %eax,%eax
 9b8:	0f 88 a4 00 00 00    	js     a62 <main+0x12e>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
 9be:	80 3d a0 16 00 00 63 	cmpb   $0x63,0x16a0
 9c5:	75 ab                	jne    972 <main+0x3e>
 9c7:	80 3d a1 16 00 00 64 	cmpb   $0x64,0x16a1
 9ce:	75 a2                	jne    972 <main+0x3e>
 9d0:	80 3d a2 16 00 00 20 	cmpb   $0x20,0x16a2
 9d7:	75 99                	jne    972 <main+0x3e>
      buf[strlen(buf)-1] = 0;  // chop \n
 9d9:	83 ec 0c             	sub    $0xc,%esp
 9dc:	68 a0 16 00 00       	push   $0x16a0
 9e1:	e8 d3 00 00 00       	call   ab9 <strlen>
 9e6:	c6 80 9f 16 00 00 00 	movb   $0x0,0x169f(%eax)
      if(chdir(buf+3) < 0)
 9ed:	c7 04 24 a3 16 00 00 	movl   $0x16a3,(%esp)
 9f4:	e8 87 02 00 00       	call   c80 <chdir>
 9f9:	83 c4 10             	add    $0x10,%esp
 9fc:	85 c0                	test   %eax,%eax
 9fe:	79 a4                	jns    9a4 <main+0x70>
        printf(2, "cannot cd %s\n", buf+3);
 a00:	83 ec 04             	sub    $0x4,%esp
 a03:	68 a3 16 00 00       	push   $0x16a3
 a08:	68 a1 10 00 00       	push   $0x10a1
 a0d:	6a 02                	push   $0x2
 a0f:	e8 3b 03 00 00       	call   d4f <printf>
 a14:	83 c4 10             	add    $0x10,%esp
      continue;
 a17:	eb 8b                	jmp    9a4 <main+0x70>
      runcmd(parsecmd(buf));
 a19:	83 ec 0c             	sub    $0xc,%esp
 a1c:	68 a0 16 00 00       	push   $0x16a0
 a21:	e8 9e fe ff ff       	call   8c4 <parsecmd>
 a26:	89 04 24             	mov    %eax,(%esp)
 a29:	e8 69 f6 ff ff       	call   97 <runcmd>
      printf(1,"Output code: %d\n", WEXITSTATUS(status));
 a2e:	83 ec 04             	sub    $0x4,%esp
 a31:	0f b6 c4             	movzbl %ah,%eax
 a34:	50                   	push   %eax
 a35:	68 af 10 00 00       	push   $0x10af
 a3a:	6a 01                	push   $0x1
 a3c:	e8 0e 03 00 00       	call   d4f <printf>
 a41:	83 c4 10             	add    $0x10,%esp
 a44:	e9 5b ff ff ff       	jmp    9a4 <main+0x70>
      printf(1,"Output code: %d\n", WEXITTRAP(status));
 a49:	83 ec 04             	sub    $0x4,%esp
 a4c:	4a                   	dec    %edx
 a4d:	52                   	push   %edx
 a4e:	68 af 10 00 00       	push   $0x10af
 a53:	6a 01                	push   $0x1
 a55:	e8 f5 02 00 00       	call   d4f <printf>
 a5a:	83 c4 10             	add    $0x10,%esp
 a5d:	e9 42 ff ff ff       	jmp    9a4 <main+0x70>
  exit(0);
 a62:	83 ec 0c             	sub    $0xc,%esp
 a65:	6a 00                	push   $0x0
 a67:	e8 a4 01 00 00       	call   c10 <exit>

00000a6c <start>:
#include <x86.h>

// Entry point of the library	
void
start()
{
 a6c:	f3 0f 1e fb          	endbr32 
}
 a70:	c3                   	ret    

00000a71 <strcpy>:

char*
strcpy(char *s, const char *t)
{
 a71:	f3 0f 1e fb          	endbr32 
 a75:	55                   	push   %ebp
 a76:	89 e5                	mov    %esp,%ebp
 a78:	56                   	push   %esi
 a79:	53                   	push   %ebx
 a7a:	8b 45 08             	mov    0x8(%ebp),%eax
 a7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 a80:	89 c2                	mov    %eax,%edx
 a82:	89 cb                	mov    %ecx,%ebx
 a84:	41                   	inc    %ecx
 a85:	89 d6                	mov    %edx,%esi
 a87:	42                   	inc    %edx
 a88:	8a 1b                	mov    (%ebx),%bl
 a8a:	88 1e                	mov    %bl,(%esi)
 a8c:	84 db                	test   %bl,%bl
 a8e:	75 f2                	jne    a82 <strcpy+0x11>
    ;
  return os;
}
 a90:	5b                   	pop    %ebx
 a91:	5e                   	pop    %esi
 a92:	5d                   	pop    %ebp
 a93:	c3                   	ret    

00000a94 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 a94:	f3 0f 1e fb          	endbr32 
 a98:	55                   	push   %ebp
 a99:	89 e5                	mov    %esp,%ebp
 a9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 aa1:	8a 01                	mov    (%ecx),%al
 aa3:	84 c0                	test   %al,%al
 aa5:	74 08                	je     aaf <strcmp+0x1b>
 aa7:	3a 02                	cmp    (%edx),%al
 aa9:	75 04                	jne    aaf <strcmp+0x1b>
    p++, q++;
 aab:	41                   	inc    %ecx
 aac:	42                   	inc    %edx
 aad:	eb f2                	jmp    aa1 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 aaf:	0f b6 c0             	movzbl %al,%eax
 ab2:	0f b6 12             	movzbl (%edx),%edx
 ab5:	29 d0                	sub    %edx,%eax
}
 ab7:	5d                   	pop    %ebp
 ab8:	c3                   	ret    

00000ab9 <strlen>:

uint
strlen(const char *s)
{
 ab9:	f3 0f 1e fb          	endbr32 
 abd:	55                   	push   %ebp
 abe:	89 e5                	mov    %esp,%ebp
 ac0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 ac3:	b8 00 00 00 00       	mov    $0x0,%eax
 ac8:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 acc:	74 03                	je     ad1 <strlen+0x18>
 ace:	40                   	inc    %eax
 acf:	eb f7                	jmp    ac8 <strlen+0xf>
    ;
  return n;
}
 ad1:	5d                   	pop    %ebp
 ad2:	c3                   	ret    

00000ad3 <memset>:

void*
memset(void *dst, int c, uint n)
{
 ad3:	f3 0f 1e fb          	endbr32 
 ad7:	55                   	push   %ebp
 ad8:	89 e5                	mov    %esp,%ebp
 ada:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 adb:	8b 7d 08             	mov    0x8(%ebp),%edi
 ade:	8b 4d 10             	mov    0x10(%ebp),%ecx
 ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
 ae4:	fc                   	cld    
 ae5:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 ae7:	8b 45 08             	mov    0x8(%ebp),%eax
 aea:	5f                   	pop    %edi
 aeb:	5d                   	pop    %ebp
 aec:	c3                   	ret    

00000aed <strchr>:

char*
strchr(const char *s, char c)
{
 aed:	f3 0f 1e fb          	endbr32 
 af1:	55                   	push   %ebp
 af2:	89 e5                	mov    %esp,%ebp
 af4:	8b 45 08             	mov    0x8(%ebp),%eax
 af7:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 afa:	8a 10                	mov    (%eax),%dl
 afc:	84 d2                	test   %dl,%dl
 afe:	74 07                	je     b07 <strchr+0x1a>
    if(*s == c)
 b00:	38 ca                	cmp    %cl,%dl
 b02:	74 08                	je     b0c <strchr+0x1f>
  for(; *s; s++)
 b04:	40                   	inc    %eax
 b05:	eb f3                	jmp    afa <strchr+0xd>
      return (char*)s;
  return 0;
 b07:	b8 00 00 00 00       	mov    $0x0,%eax
}
 b0c:	5d                   	pop    %ebp
 b0d:	c3                   	ret    

00000b0e <gets>:

char*
gets(char *buf, int max)
{
 b0e:	f3 0f 1e fb          	endbr32 
 b12:	55                   	push   %ebp
 b13:	89 e5                	mov    %esp,%ebp
 b15:	57                   	push   %edi
 b16:	56                   	push   %esi
 b17:	53                   	push   %ebx
 b18:	83 ec 1c             	sub    $0x1c,%esp
 b1b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 b1e:	bb 00 00 00 00       	mov    $0x0,%ebx
 b23:	89 de                	mov    %ebx,%esi
 b25:	43                   	inc    %ebx
 b26:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 b29:	7d 2b                	jge    b56 <gets+0x48>
    cc = read(0, &c, 1);
 b2b:	83 ec 04             	sub    $0x4,%esp
 b2e:	6a 01                	push   $0x1
 b30:	8d 45 e7             	lea    -0x19(%ebp),%eax
 b33:	50                   	push   %eax
 b34:	6a 00                	push   $0x0
 b36:	e8 ed 00 00 00       	call   c28 <read>
    if(cc < 1)
 b3b:	83 c4 10             	add    $0x10,%esp
 b3e:	85 c0                	test   %eax,%eax
 b40:	7e 14                	jle    b56 <gets+0x48>
      break;
    buf[i++] = c;
 b42:	8a 45 e7             	mov    -0x19(%ebp),%al
 b45:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 b48:	3c 0a                	cmp    $0xa,%al
 b4a:	74 08                	je     b54 <gets+0x46>
 b4c:	3c 0d                	cmp    $0xd,%al
 b4e:	75 d3                	jne    b23 <gets+0x15>
    buf[i++] = c;
 b50:	89 de                	mov    %ebx,%esi
 b52:	eb 02                	jmp    b56 <gets+0x48>
 b54:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 b56:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 b5a:	89 f8                	mov    %edi,%eax
 b5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 b5f:	5b                   	pop    %ebx
 b60:	5e                   	pop    %esi
 b61:	5f                   	pop    %edi
 b62:	5d                   	pop    %ebp
 b63:	c3                   	ret    

00000b64 <stat>:

int
stat(const char *n, struct stat *st)
{
 b64:	f3 0f 1e fb          	endbr32 
 b68:	55                   	push   %ebp
 b69:	89 e5                	mov    %esp,%ebp
 b6b:	56                   	push   %esi
 b6c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 b6d:	83 ec 08             	sub    $0x8,%esp
 b70:	6a 00                	push   $0x0
 b72:	ff 75 08             	pushl  0x8(%ebp)
 b75:	e8 d6 00 00 00       	call   c50 <open>
  if(fd < 0)
 b7a:	83 c4 10             	add    $0x10,%esp
 b7d:	85 c0                	test   %eax,%eax
 b7f:	78 24                	js     ba5 <stat+0x41>
 b81:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 b83:	83 ec 08             	sub    $0x8,%esp
 b86:	ff 75 0c             	pushl  0xc(%ebp)
 b89:	50                   	push   %eax
 b8a:	e8 d9 00 00 00       	call   c68 <fstat>
 b8f:	89 c6                	mov    %eax,%esi
  close(fd);
 b91:	89 1c 24             	mov    %ebx,(%esp)
 b94:	e8 9f 00 00 00       	call   c38 <close>
  return r;
 b99:	83 c4 10             	add    $0x10,%esp
}
 b9c:	89 f0                	mov    %esi,%eax
 b9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 ba1:	5b                   	pop    %ebx
 ba2:	5e                   	pop    %esi
 ba3:	5d                   	pop    %ebp
 ba4:	c3                   	ret    
    return -1;
 ba5:	be ff ff ff ff       	mov    $0xffffffff,%esi
 baa:	eb f0                	jmp    b9c <stat+0x38>

00000bac <atoi>:

int
atoi(const char *s)
{
 bac:	f3 0f 1e fb          	endbr32 
 bb0:	55                   	push   %ebp
 bb1:	89 e5                	mov    %esp,%ebp
 bb3:	53                   	push   %ebx
 bb4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 bb7:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 bbc:	8a 01                	mov    (%ecx),%al
 bbe:	8d 58 d0             	lea    -0x30(%eax),%ebx
 bc1:	80 fb 09             	cmp    $0x9,%bl
 bc4:	77 10                	ja     bd6 <atoi+0x2a>
    n = n*10 + *s++ - '0';
 bc6:	8d 14 92             	lea    (%edx,%edx,4),%edx
 bc9:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 bcc:	41                   	inc    %ecx
 bcd:	0f be c0             	movsbl %al,%eax
 bd0:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
 bd4:	eb e6                	jmp    bbc <atoi+0x10>
  return n;
}
 bd6:	89 d0                	mov    %edx,%eax
 bd8:	5b                   	pop    %ebx
 bd9:	5d                   	pop    %ebp
 bda:	c3                   	ret    

00000bdb <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 bdb:	f3 0f 1e fb          	endbr32 
 bdf:	55                   	push   %ebp
 be0:	89 e5                	mov    %esp,%ebp
 be2:	56                   	push   %esi
 be3:	53                   	push   %ebx
 be4:	8b 45 08             	mov    0x8(%ebp),%eax
 be7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 bea:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 bed:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 bef:	8d 72 ff             	lea    -0x1(%edx),%esi
 bf2:	85 d2                	test   %edx,%edx
 bf4:	7e 0e                	jle    c04 <memmove+0x29>
    *dst++ = *src++;
 bf6:	8a 13                	mov    (%ebx),%dl
 bf8:	88 11                	mov    %dl,(%ecx)
 bfa:	8d 5b 01             	lea    0x1(%ebx),%ebx
 bfd:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 c00:	89 f2                	mov    %esi,%edx
 c02:	eb eb                	jmp    bef <memmove+0x14>
  return vdst;
}
 c04:	5b                   	pop    %ebx
 c05:	5e                   	pop    %esi
 c06:	5d                   	pop    %ebp
 c07:	c3                   	ret    

00000c08 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 c08:	b8 01 00 00 00       	mov    $0x1,%eax
 c0d:	cd 40                	int    $0x40
 c0f:	c3                   	ret    

00000c10 <exit>:
SYSCALL(exit)
 c10:	b8 02 00 00 00       	mov    $0x2,%eax
 c15:	cd 40                	int    $0x40
 c17:	c3                   	ret    

00000c18 <wait>:
SYSCALL(wait)
 c18:	b8 03 00 00 00       	mov    $0x3,%eax
 c1d:	cd 40                	int    $0x40
 c1f:	c3                   	ret    

00000c20 <pipe>:
SYSCALL(pipe)
 c20:	b8 04 00 00 00       	mov    $0x4,%eax
 c25:	cd 40                	int    $0x40
 c27:	c3                   	ret    

00000c28 <read>:
SYSCALL(read)
 c28:	b8 05 00 00 00       	mov    $0x5,%eax
 c2d:	cd 40                	int    $0x40
 c2f:	c3                   	ret    

00000c30 <write>:
SYSCALL(write)
 c30:	b8 10 00 00 00       	mov    $0x10,%eax
 c35:	cd 40                	int    $0x40
 c37:	c3                   	ret    

00000c38 <close>:
SYSCALL(close)
 c38:	b8 15 00 00 00       	mov    $0x15,%eax
 c3d:	cd 40                	int    $0x40
 c3f:	c3                   	ret    

00000c40 <kill>:
SYSCALL(kill)
 c40:	b8 06 00 00 00       	mov    $0x6,%eax
 c45:	cd 40                	int    $0x40
 c47:	c3                   	ret    

00000c48 <exec>:
SYSCALL(exec)
 c48:	b8 07 00 00 00       	mov    $0x7,%eax
 c4d:	cd 40                	int    $0x40
 c4f:	c3                   	ret    

00000c50 <open>:
SYSCALL(open)
 c50:	b8 0f 00 00 00       	mov    $0xf,%eax
 c55:	cd 40                	int    $0x40
 c57:	c3                   	ret    

00000c58 <mknod>:
SYSCALL(mknod)
 c58:	b8 11 00 00 00       	mov    $0x11,%eax
 c5d:	cd 40                	int    $0x40
 c5f:	c3                   	ret    

00000c60 <unlink>:
SYSCALL(unlink)
 c60:	b8 12 00 00 00       	mov    $0x12,%eax
 c65:	cd 40                	int    $0x40
 c67:	c3                   	ret    

00000c68 <fstat>:
SYSCALL(fstat)
 c68:	b8 08 00 00 00       	mov    $0x8,%eax
 c6d:	cd 40                	int    $0x40
 c6f:	c3                   	ret    

00000c70 <link>:
SYSCALL(link)
 c70:	b8 13 00 00 00       	mov    $0x13,%eax
 c75:	cd 40                	int    $0x40
 c77:	c3                   	ret    

00000c78 <mkdir>:
SYSCALL(mkdir)
 c78:	b8 14 00 00 00       	mov    $0x14,%eax
 c7d:	cd 40                	int    $0x40
 c7f:	c3                   	ret    

00000c80 <chdir>:
SYSCALL(chdir)
 c80:	b8 09 00 00 00       	mov    $0x9,%eax
 c85:	cd 40                	int    $0x40
 c87:	c3                   	ret    

00000c88 <dup>:
SYSCALL(dup)
 c88:	b8 0a 00 00 00       	mov    $0xa,%eax
 c8d:	cd 40                	int    $0x40
 c8f:	c3                   	ret    

00000c90 <getpid>:
SYSCALL(getpid)
 c90:	b8 0b 00 00 00       	mov    $0xb,%eax
 c95:	cd 40                	int    $0x40
 c97:	c3                   	ret    

00000c98 <sbrk>:
SYSCALL(sbrk)
 c98:	b8 0c 00 00 00       	mov    $0xc,%eax
 c9d:	cd 40                	int    $0x40
 c9f:	c3                   	ret    

00000ca0 <sleep>:
SYSCALL(sleep)
 ca0:	b8 0d 00 00 00       	mov    $0xd,%eax
 ca5:	cd 40                	int    $0x40
 ca7:	c3                   	ret    

00000ca8 <uptime>:
SYSCALL(uptime)
 ca8:	b8 0e 00 00 00       	mov    $0xe,%eax
 cad:	cd 40                	int    $0x40
 caf:	c3                   	ret    

00000cb0 <date>:
SYSCALL(date)
 cb0:	b8 16 00 00 00       	mov    $0x16,%eax
 cb5:	cd 40                	int    $0x40
 cb7:	c3                   	ret    

00000cb8 <dup2>:
 cb8:	b8 17 00 00 00       	mov    $0x17,%eax
 cbd:	cd 40                	int    $0x40
 cbf:	c3                   	ret    

00000cc0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 cc0:	55                   	push   %ebp
 cc1:	89 e5                	mov    %esp,%ebp
 cc3:	83 ec 1c             	sub    $0x1c,%esp
 cc6:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 cc9:	6a 01                	push   $0x1
 ccb:	8d 55 f4             	lea    -0xc(%ebp),%edx
 cce:	52                   	push   %edx
 ccf:	50                   	push   %eax
 cd0:	e8 5b ff ff ff       	call   c30 <write>
}
 cd5:	83 c4 10             	add    $0x10,%esp
 cd8:	c9                   	leave  
 cd9:	c3                   	ret    

00000cda <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 cda:	55                   	push   %ebp
 cdb:	89 e5                	mov    %esp,%ebp
 cdd:	57                   	push   %edi
 cde:	56                   	push   %esi
 cdf:	53                   	push   %ebx
 ce0:	83 ec 2c             	sub    $0x2c,%esp
 ce3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 ce6:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 ce8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 cec:	74 04                	je     cf2 <printint+0x18>
 cee:	85 d2                	test   %edx,%edx
 cf0:	78 3a                	js     d2c <printint+0x52>
  neg = 0;
 cf2:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 cf9:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 cfe:	89 f0                	mov    %esi,%eax
 d00:	ba 00 00 00 00       	mov    $0x0,%edx
 d05:	f7 f1                	div    %ecx
 d07:	89 df                	mov    %ebx,%edi
 d09:	43                   	inc    %ebx
 d0a:	8a 92 f8 10 00 00    	mov    0x10f8(%edx),%dl
 d10:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 d14:	89 f2                	mov    %esi,%edx
 d16:	89 c6                	mov    %eax,%esi
 d18:	39 d1                	cmp    %edx,%ecx
 d1a:	76 e2                	jbe    cfe <printint+0x24>
  if(neg)
 d1c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 d20:	74 22                	je     d44 <printint+0x6a>
    buf[i++] = '-';
 d22:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 d27:	8d 5f 02             	lea    0x2(%edi),%ebx
 d2a:	eb 18                	jmp    d44 <printint+0x6a>
    x = -xx;
 d2c:	f7 de                	neg    %esi
    neg = 1;
 d2e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 d35:	eb c2                	jmp    cf9 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 d37:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 d3c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 d3f:	e8 7c ff ff ff       	call   cc0 <putc>
  while(--i >= 0)
 d44:	4b                   	dec    %ebx
 d45:	79 f0                	jns    d37 <printint+0x5d>
}
 d47:	83 c4 2c             	add    $0x2c,%esp
 d4a:	5b                   	pop    %ebx
 d4b:	5e                   	pop    %esi
 d4c:	5f                   	pop    %edi
 d4d:	5d                   	pop    %ebp
 d4e:	c3                   	ret    

00000d4f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 d4f:	f3 0f 1e fb          	endbr32 
 d53:	55                   	push   %ebp
 d54:	89 e5                	mov    %esp,%ebp
 d56:	57                   	push   %edi
 d57:	56                   	push   %esi
 d58:	53                   	push   %ebx
 d59:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 d5c:	8d 45 10             	lea    0x10(%ebp),%eax
 d5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 d62:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 d67:	bb 00 00 00 00       	mov    $0x0,%ebx
 d6c:	eb 12                	jmp    d80 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 d6e:	89 fa                	mov    %edi,%edx
 d70:	8b 45 08             	mov    0x8(%ebp),%eax
 d73:	e8 48 ff ff ff       	call   cc0 <putc>
 d78:	eb 05                	jmp    d7f <printf+0x30>
      }
    } else if(state == '%'){
 d7a:	83 fe 25             	cmp    $0x25,%esi
 d7d:	74 22                	je     da1 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 d7f:	43                   	inc    %ebx
 d80:	8b 45 0c             	mov    0xc(%ebp),%eax
 d83:	8a 04 18             	mov    (%eax,%ebx,1),%al
 d86:	84 c0                	test   %al,%al
 d88:	0f 84 13 01 00 00    	je     ea1 <printf+0x152>
    c = fmt[i] & 0xff;
 d8e:	0f be f8             	movsbl %al,%edi
 d91:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 d94:	85 f6                	test   %esi,%esi
 d96:	75 e2                	jne    d7a <printf+0x2b>
      if(c == '%'){
 d98:	83 f8 25             	cmp    $0x25,%eax
 d9b:	75 d1                	jne    d6e <printf+0x1f>
        state = '%';
 d9d:	89 c6                	mov    %eax,%esi
 d9f:	eb de                	jmp    d7f <printf+0x30>
      if(c == 'd'){
 da1:	83 f8 64             	cmp    $0x64,%eax
 da4:	74 43                	je     de9 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 da6:	83 f8 78             	cmp    $0x78,%eax
 da9:	74 68                	je     e13 <printf+0xc4>
 dab:	83 f8 70             	cmp    $0x70,%eax
 dae:	74 63                	je     e13 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 db0:	83 f8 73             	cmp    $0x73,%eax
 db3:	0f 84 84 00 00 00    	je     e3d <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 db9:	83 f8 63             	cmp    $0x63,%eax
 dbc:	0f 84 ad 00 00 00    	je     e6f <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 dc2:	83 f8 25             	cmp    $0x25,%eax
 dc5:	0f 84 c2 00 00 00    	je     e8d <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 dcb:	ba 25 00 00 00       	mov    $0x25,%edx
 dd0:	8b 45 08             	mov    0x8(%ebp),%eax
 dd3:	e8 e8 fe ff ff       	call   cc0 <putc>
        putc(fd, c);
 dd8:	89 fa                	mov    %edi,%edx
 dda:	8b 45 08             	mov    0x8(%ebp),%eax
 ddd:	e8 de fe ff ff       	call   cc0 <putc>
      }
      state = 0;
 de2:	be 00 00 00 00       	mov    $0x0,%esi
 de7:	eb 96                	jmp    d7f <printf+0x30>
        printint(fd, *ap, 10, 1);
 de9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 dec:	8b 17                	mov    (%edi),%edx
 dee:	83 ec 0c             	sub    $0xc,%esp
 df1:	6a 01                	push   $0x1
 df3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 df8:	8b 45 08             	mov    0x8(%ebp),%eax
 dfb:	e8 da fe ff ff       	call   cda <printint>
        ap++;
 e00:	83 c7 04             	add    $0x4,%edi
 e03:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 e06:	83 c4 10             	add    $0x10,%esp
      state = 0;
 e09:	be 00 00 00 00       	mov    $0x0,%esi
 e0e:	e9 6c ff ff ff       	jmp    d7f <printf+0x30>
        printint(fd, *ap, 16, 0);
 e13:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 e16:	8b 17                	mov    (%edi),%edx
 e18:	83 ec 0c             	sub    $0xc,%esp
 e1b:	6a 00                	push   $0x0
 e1d:	b9 10 00 00 00       	mov    $0x10,%ecx
 e22:	8b 45 08             	mov    0x8(%ebp),%eax
 e25:	e8 b0 fe ff ff       	call   cda <printint>
        ap++;
 e2a:	83 c7 04             	add    $0x4,%edi
 e2d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 e30:	83 c4 10             	add    $0x10,%esp
      state = 0;
 e33:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 e38:	e9 42 ff ff ff       	jmp    d7f <printf+0x30>
        s = (char*)*ap;
 e3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 e40:	8b 30                	mov    (%eax),%esi
        ap++;
 e42:	83 c0 04             	add    $0x4,%eax
 e45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 e48:	85 f6                	test   %esi,%esi
 e4a:	75 13                	jne    e5f <printf+0x110>
          s = "(null)";
 e4c:	be f0 10 00 00       	mov    $0x10f0,%esi
 e51:	eb 0c                	jmp    e5f <printf+0x110>
          putc(fd, *s);
 e53:	0f be d2             	movsbl %dl,%edx
 e56:	8b 45 08             	mov    0x8(%ebp),%eax
 e59:	e8 62 fe ff ff       	call   cc0 <putc>
          s++;
 e5e:	46                   	inc    %esi
        while(*s != 0){
 e5f:	8a 16                	mov    (%esi),%dl
 e61:	84 d2                	test   %dl,%dl
 e63:	75 ee                	jne    e53 <printf+0x104>
      state = 0;
 e65:	be 00 00 00 00       	mov    $0x0,%esi
 e6a:	e9 10 ff ff ff       	jmp    d7f <printf+0x30>
        putc(fd, *ap);
 e6f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 e72:	0f be 17             	movsbl (%edi),%edx
 e75:	8b 45 08             	mov    0x8(%ebp),%eax
 e78:	e8 43 fe ff ff       	call   cc0 <putc>
        ap++;
 e7d:	83 c7 04             	add    $0x4,%edi
 e80:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 e83:	be 00 00 00 00       	mov    $0x0,%esi
 e88:	e9 f2 fe ff ff       	jmp    d7f <printf+0x30>
        putc(fd, c);
 e8d:	89 fa                	mov    %edi,%edx
 e8f:	8b 45 08             	mov    0x8(%ebp),%eax
 e92:	e8 29 fe ff ff       	call   cc0 <putc>
      state = 0;
 e97:	be 00 00 00 00       	mov    $0x0,%esi
 e9c:	e9 de fe ff ff       	jmp    d7f <printf+0x30>
    }
  }
}
 ea1:	8d 65 f4             	lea    -0xc(%ebp),%esp
 ea4:	5b                   	pop    %ebx
 ea5:	5e                   	pop    %esi
 ea6:	5f                   	pop    %edi
 ea7:	5d                   	pop    %ebp
 ea8:	c3                   	ret    

00000ea9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ea9:	f3 0f 1e fb          	endbr32 
 ead:	55                   	push   %ebp
 eae:	89 e5                	mov    %esp,%ebp
 eb0:	57                   	push   %edi
 eb1:	56                   	push   %esi
 eb2:	53                   	push   %ebx
 eb3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 eb6:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 eb9:	a1 04 17 00 00       	mov    0x1704,%eax
 ebe:	eb 02                	jmp    ec2 <free+0x19>
 ec0:	89 d0                	mov    %edx,%eax
 ec2:	39 c8                	cmp    %ecx,%eax
 ec4:	73 04                	jae    eca <free+0x21>
 ec6:	39 08                	cmp    %ecx,(%eax)
 ec8:	77 12                	ja     edc <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 eca:	8b 10                	mov    (%eax),%edx
 ecc:	39 c2                	cmp    %eax,%edx
 ece:	77 f0                	ja     ec0 <free+0x17>
 ed0:	39 c8                	cmp    %ecx,%eax
 ed2:	72 08                	jb     edc <free+0x33>
 ed4:	39 ca                	cmp    %ecx,%edx
 ed6:	77 04                	ja     edc <free+0x33>
 ed8:	89 d0                	mov    %edx,%eax
 eda:	eb e6                	jmp    ec2 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 edc:	8b 73 fc             	mov    -0x4(%ebx),%esi
 edf:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 ee2:	8b 10                	mov    (%eax),%edx
 ee4:	39 d7                	cmp    %edx,%edi
 ee6:	74 19                	je     f01 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 ee8:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 eeb:	8b 50 04             	mov    0x4(%eax),%edx
 eee:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 ef1:	39 ce                	cmp    %ecx,%esi
 ef3:	74 1b                	je     f10 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 ef5:	89 08                	mov    %ecx,(%eax)
  freep = p;
 ef7:	a3 04 17 00 00       	mov    %eax,0x1704
}
 efc:	5b                   	pop    %ebx
 efd:	5e                   	pop    %esi
 efe:	5f                   	pop    %edi
 eff:	5d                   	pop    %ebp
 f00:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 f01:	03 72 04             	add    0x4(%edx),%esi
 f04:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 f07:	8b 10                	mov    (%eax),%edx
 f09:	8b 12                	mov    (%edx),%edx
 f0b:	89 53 f8             	mov    %edx,-0x8(%ebx)
 f0e:	eb db                	jmp    eeb <free+0x42>
    p->s.size += bp->s.size;
 f10:	03 53 fc             	add    -0x4(%ebx),%edx
 f13:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 f16:	8b 53 f8             	mov    -0x8(%ebx),%edx
 f19:	89 10                	mov    %edx,(%eax)
 f1b:	eb da                	jmp    ef7 <free+0x4e>

00000f1d <morecore>:

static Header*
morecore(uint nu)
{
 f1d:	55                   	push   %ebp
 f1e:	89 e5                	mov    %esp,%ebp
 f20:	53                   	push   %ebx
 f21:	83 ec 04             	sub    $0x4,%esp
 f24:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 f26:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 f2b:	77 05                	ja     f32 <morecore+0x15>
    nu = 4096;
 f2d:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 f32:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 f39:	83 ec 0c             	sub    $0xc,%esp
 f3c:	50                   	push   %eax
 f3d:	e8 56 fd ff ff       	call   c98 <sbrk>
  if(p == (char*)-1)
 f42:	83 c4 10             	add    $0x10,%esp
 f45:	83 f8 ff             	cmp    $0xffffffff,%eax
 f48:	74 1c                	je     f66 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 f4a:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 f4d:	83 c0 08             	add    $0x8,%eax
 f50:	83 ec 0c             	sub    $0xc,%esp
 f53:	50                   	push   %eax
 f54:	e8 50 ff ff ff       	call   ea9 <free>
  return freep;
 f59:	a1 04 17 00 00       	mov    0x1704,%eax
 f5e:	83 c4 10             	add    $0x10,%esp
}
 f61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 f64:	c9                   	leave  
 f65:	c3                   	ret    
    return 0;
 f66:	b8 00 00 00 00       	mov    $0x0,%eax
 f6b:	eb f4                	jmp    f61 <morecore+0x44>

00000f6d <malloc>:

void*
malloc(uint nbytes)
{
 f6d:	f3 0f 1e fb          	endbr32 
 f71:	55                   	push   %ebp
 f72:	89 e5                	mov    %esp,%ebp
 f74:	53                   	push   %ebx
 f75:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 f78:	8b 45 08             	mov    0x8(%ebp),%eax
 f7b:	8d 58 07             	lea    0x7(%eax),%ebx
 f7e:	c1 eb 03             	shr    $0x3,%ebx
 f81:	43                   	inc    %ebx
  if((prevp = freep) == 0){
 f82:	8b 0d 04 17 00 00    	mov    0x1704,%ecx
 f88:	85 c9                	test   %ecx,%ecx
 f8a:	74 04                	je     f90 <malloc+0x23>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f8c:	8b 01                	mov    (%ecx),%eax
 f8e:	eb 4b                	jmp    fdb <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 f90:	c7 05 04 17 00 00 08 	movl   $0x1708,0x1704
 f97:	17 00 00 
 f9a:	c7 05 08 17 00 00 08 	movl   $0x1708,0x1708
 fa1:	17 00 00 
    base.s.size = 0;
 fa4:	c7 05 0c 17 00 00 00 	movl   $0x0,0x170c
 fab:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 fae:	b9 08 17 00 00       	mov    $0x1708,%ecx
 fb3:	eb d7                	jmp    f8c <malloc+0x1f>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 fb5:	74 1a                	je     fd1 <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 fb7:	29 da                	sub    %ebx,%edx
 fb9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 fbc:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 fbf:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 fc2:	89 0d 04 17 00 00    	mov    %ecx,0x1704
      return (void*)(p + 1);
 fc8:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 fcb:	83 c4 04             	add    $0x4,%esp
 fce:	5b                   	pop    %ebx
 fcf:	5d                   	pop    %ebp
 fd0:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 fd1:	8b 10                	mov    (%eax),%edx
 fd3:	89 11                	mov    %edx,(%ecx)
 fd5:	eb eb                	jmp    fc2 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 fd7:	89 c1                	mov    %eax,%ecx
 fd9:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 fdb:	8b 50 04             	mov    0x4(%eax),%edx
 fde:	39 da                	cmp    %ebx,%edx
 fe0:	73 d3                	jae    fb5 <malloc+0x48>
    if(p == freep)
 fe2:	39 05 04 17 00 00    	cmp    %eax,0x1704
 fe8:	75 ed                	jne    fd7 <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 fea:	89 d8                	mov    %ebx,%eax
 fec:	e8 2c ff ff ff       	call   f1d <morecore>
 ff1:	85 c0                	test   %eax,%eax
 ff3:	75 e2                	jne    fd7 <malloc+0x6a>
 ff5:	eb d4                	jmp    fcb <malloc+0x5e>
