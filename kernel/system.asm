
kernel/system:     file format elf32-i386


Disassembly of section .text:

f0100000 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0100000:	8b 54 24 04          	mov    0x4(%esp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0100004:	b8 00 00 00 00       	mov    $0x0,%eax
f0100009:	80 3a 00             	cmpb   $0x0,(%edx)
f010000c:	74 09                	je     f0100017 <strlen+0x17>
		n++;
f010000e:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f0100011:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0100015:	75 f7                	jne    f010000e <strlen+0xe>
		n++;
	return n;
}
f0100017:	f3 c3                	repz ret 

f0100019 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0100019:	8b 4c 24 04          	mov    0x4(%esp),%ecx
f010001d:	8b 54 24 08          	mov    0x8(%esp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0100021:	b8 00 00 00 00       	mov    $0x0,%eax
f0100026:	85 d2                	test   %edx,%edx
f0100028:	74 12                	je     f010003c <strnlen+0x23>
f010002a:	80 39 00             	cmpb   $0x0,(%ecx)
f010002d:	74 0d                	je     f010003c <strnlen+0x23>
		n++;
f010002f:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0100032:	39 d0                	cmp    %edx,%eax
f0100034:	74 06                	je     f010003c <strnlen+0x23>
f0100036:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f010003a:	75 f3                	jne    f010002f <strnlen+0x16>
		n++;
	return n;
}
f010003c:	f3 c3                	repz ret 

f010003e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f010003e:	53                   	push   %ebx
f010003f:	8b 44 24 08          	mov    0x8(%esp),%eax
f0100043:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0100047:	ba 00 00 00 00       	mov    $0x0,%edx
f010004c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f0100050:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0100053:	83 c2 01             	add    $0x1,%edx
f0100056:	84 c9                	test   %cl,%cl
f0100058:	75 f2                	jne    f010004c <strcpy+0xe>
		/* do nothing */;
	return ret;
}
f010005a:	5b                   	pop    %ebx
f010005b:	c3                   	ret    

f010005c <strcat>:

char *
strcat(char *dst, const char *src)
{
f010005c:	53                   	push   %ebx
f010005d:	83 ec 08             	sub    $0x8,%esp
f0100060:	8b 5c 24 10          	mov    0x10(%esp),%ebx
	int len = strlen(dst);
f0100064:	89 1c 24             	mov    %ebx,(%esp)
f0100067:	e8 94 ff ff ff       	call   f0100000 <strlen>
	strcpy(dst + len, src);
f010006c:	8b 54 24 14          	mov    0x14(%esp),%edx
f0100070:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100074:	8d 04 03             	lea    (%ebx,%eax,1),%eax
f0100077:	89 04 24             	mov    %eax,(%esp)
f010007a:	e8 bf ff ff ff       	call   f010003e <strcpy>
	return dst;
}
f010007f:	89 d8                	mov    %ebx,%eax
f0100081:	83 c4 08             	add    $0x8,%esp
f0100084:	5b                   	pop    %ebx
f0100085:	c3                   	ret    

f0100086 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0100086:	56                   	push   %esi
f0100087:	53                   	push   %ebx
f0100088:	8b 44 24 0c          	mov    0xc(%esp),%eax
f010008c:	8b 54 24 10          	mov    0x10(%esp),%edx
f0100090:	8b 74 24 14          	mov    0x14(%esp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0100094:	85 f6                	test   %esi,%esi
f0100096:	74 18                	je     f01000b0 <strncpy+0x2a>
f0100098:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
f010009d:	0f b6 1a             	movzbl (%edx),%ebx
f01000a0:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01000a3:	80 3a 01             	cmpb   $0x1,(%edx)
f01000a6:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01000a9:	83 c1 01             	add    $0x1,%ecx
f01000ac:	39 ce                	cmp    %ecx,%esi
f01000ae:	77 ed                	ja     f010009d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
f01000b0:	5b                   	pop    %ebx
f01000b1:	5e                   	pop    %esi
f01000b2:	c3                   	ret    

f01000b3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01000b3:	57                   	push   %edi
f01000b4:	56                   	push   %esi
f01000b5:	53                   	push   %ebx
f01000b6:	8b 7c 24 10          	mov    0x10(%esp),%edi
f01000ba:	8b 5c 24 14          	mov    0x14(%esp),%ebx
f01000be:	8b 74 24 18          	mov    0x18(%esp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01000c2:	89 f8                	mov    %edi,%eax
f01000c4:	85 f6                	test   %esi,%esi
f01000c6:	74 2c                	je     f01000f4 <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
f01000c8:	83 fe 01             	cmp    $0x1,%esi
f01000cb:	74 24                	je     f01000f1 <strlcpy+0x3e>
f01000cd:	0f b6 0b             	movzbl (%ebx),%ecx
f01000d0:	84 c9                	test   %cl,%cl
f01000d2:	74 1d                	je     f01000f1 <strlcpy+0x3e>
f01000d4:	ba 00 00 00 00       	mov    $0x0,%edx
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
f01000d9:	83 ee 02             	sub    $0x2,%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f01000dc:	88 08                	mov    %cl,(%eax)
f01000de:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f01000e1:	39 f2                	cmp    %esi,%edx
f01000e3:	74 0c                	je     f01000f1 <strlcpy+0x3e>
f01000e5:	0f b6 4c 13 01       	movzbl 0x1(%ebx,%edx,1),%ecx
f01000ea:	83 c2 01             	add    $0x1,%edx
f01000ed:	84 c9                	test   %cl,%cl
f01000ef:	75 eb                	jne    f01000dc <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
f01000f1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f01000f4:	29 f8                	sub    %edi,%eax
}
f01000f6:	5b                   	pop    %ebx
f01000f7:	5e                   	pop    %esi
f01000f8:	5f                   	pop    %edi
f01000f9:	c3                   	ret    

f01000fa <strcmp>:

int
strcmp(const char *p, const char *q)
{
f01000fa:	8b 4c 24 04          	mov    0x4(%esp),%ecx
f01000fe:	8b 54 24 08          	mov    0x8(%esp),%edx
	while (*p && *p == *q)
f0100102:	0f b6 01             	movzbl (%ecx),%eax
f0100105:	84 c0                	test   %al,%al
f0100107:	74 15                	je     f010011e <strcmp+0x24>
f0100109:	3a 02                	cmp    (%edx),%al
f010010b:	75 11                	jne    f010011e <strcmp+0x24>
		p++, q++;
f010010d:	83 c1 01             	add    $0x1,%ecx
f0100110:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
f0100113:	0f b6 01             	movzbl (%ecx),%eax
f0100116:	84 c0                	test   %al,%al
f0100118:	74 04                	je     f010011e <strcmp+0x24>
f010011a:	3a 02                	cmp    (%edx),%al
f010011c:	74 ef                	je     f010010d <strcmp+0x13>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
f010011e:	0f b6 c0             	movzbl %al,%eax
f0100121:	0f b6 12             	movzbl (%edx),%edx
f0100124:	29 d0                	sub    %edx,%eax
}
f0100126:	c3                   	ret    

f0100127 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0100127:	53                   	push   %ebx
f0100128:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f010012c:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
f0100130:	8b 54 24 10          	mov    0x10(%esp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
f0100134:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f0100139:	85 d2                	test   %edx,%edx
f010013b:	74 28                	je     f0100165 <strncmp+0x3e>
f010013d:	0f b6 01             	movzbl (%ecx),%eax
f0100140:	84 c0                	test   %al,%al
f0100142:	74 23                	je     f0100167 <strncmp+0x40>
f0100144:	3a 03                	cmp    (%ebx),%al
f0100146:	75 1f                	jne    f0100167 <strncmp+0x40>
f0100148:	83 ea 01             	sub    $0x1,%edx
f010014b:	74 13                	je     f0100160 <strncmp+0x39>
		n--, p++, q++;
f010014d:	83 c1 01             	add    $0x1,%ecx
f0100150:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f0100153:	0f b6 01             	movzbl (%ecx),%eax
f0100156:	84 c0                	test   %al,%al
f0100158:	74 0d                	je     f0100167 <strncmp+0x40>
f010015a:	3a 03                	cmp    (%ebx),%al
f010015c:	74 ea                	je     f0100148 <strncmp+0x21>
f010015e:	eb 07                	jmp    f0100167 <strncmp+0x40>
		n--, p++, q++;
	if (n == 0)
		return 0;
f0100160:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
f0100165:	5b                   	pop    %ebx
f0100166:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0100167:	0f b6 01             	movzbl (%ecx),%eax
f010016a:	0f b6 13             	movzbl (%ebx),%edx
f010016d:	29 d0                	sub    %edx,%eax
f010016f:	eb f4                	jmp    f0100165 <strncmp+0x3e>

f0100171 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0100171:	8b 44 24 04          	mov    0x4(%esp),%eax
f0100175:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
	for (; *s; s++)
f010017a:	0f b6 10             	movzbl (%eax),%edx
f010017d:	84 d2                	test   %dl,%dl
f010017f:	74 21                	je     f01001a2 <strchr+0x31>
		if (*s == c)
f0100181:	38 ca                	cmp    %cl,%dl
f0100183:	75 0d                	jne    f0100192 <strchr+0x21>
f0100185:	f3 c3                	repz ret 
f0100187:	38 ca                	cmp    %cl,%dl
f0100189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0100190:	74 15                	je     f01001a7 <strchr+0x36>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f0100192:	83 c0 01             	add    $0x1,%eax
f0100195:	0f b6 10             	movzbl (%eax),%edx
f0100198:	84 d2                	test   %dl,%dl
f010019a:	75 eb                	jne    f0100187 <strchr+0x16>
		if (*s == c)
			return (char *) s;
	return 0;
f010019c:	b8 00 00 00 00       	mov    $0x0,%eax
f01001a1:	c3                   	ret    
f01001a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01001a7:	f3 c3                	repz ret 

f01001a9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f01001a9:	8b 44 24 04          	mov    0x4(%esp),%eax
f01001ad:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
	for (; *s; s++)
f01001b2:	0f b6 10             	movzbl (%eax),%edx
f01001b5:	84 d2                	test   %dl,%dl
f01001b7:	74 14                	je     f01001cd <strfind+0x24>
		if (*s == c)
f01001b9:	38 ca                	cmp    %cl,%dl
f01001bb:	75 06                	jne    f01001c3 <strfind+0x1a>
f01001bd:	f3 c3                	repz ret 
f01001bf:	38 ca                	cmp    %cl,%dl
f01001c1:	74 0a                	je     f01001cd <strfind+0x24>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
f01001c3:	83 c0 01             	add    $0x1,%eax
f01001c6:	0f b6 10             	movzbl (%eax),%edx
f01001c9:	84 d2                	test   %dl,%dl
f01001cb:	75 f2                	jne    f01001bf <strfind+0x16>
		if (*s == c)
			break;
	return (char *) s;
}
f01001cd:	f3 c3                	repz ret 

f01001cf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01001cf:	83 ec 0c             	sub    $0xc,%esp
f01001d2:	89 1c 24             	mov    %ebx,(%esp)
f01001d5:	89 74 24 04          	mov    %esi,0x4(%esp)
f01001d9:	89 7c 24 08          	mov    %edi,0x8(%esp)
f01001dd:	8b 7c 24 10          	mov    0x10(%esp),%edi
f01001e1:	8b 44 24 14          	mov    0x14(%esp),%eax
f01001e5:	8b 4c 24 18          	mov    0x18(%esp),%ecx
	if (n == 0)
f01001e9:	85 c9                	test   %ecx,%ecx
f01001eb:	74 30                	je     f010021d <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01001ed:	f7 c7 03 00 00 00    	test   $0x3,%edi
f01001f3:	75 25                	jne    f010021a <memset+0x4b>
f01001f5:	f6 c1 03             	test   $0x3,%cl
f01001f8:	75 20                	jne    f010021a <memset+0x4b>
		c &= 0xFF;
f01001fa:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01001fd:	89 d3                	mov    %edx,%ebx
f01001ff:	c1 e3 08             	shl    $0x8,%ebx
f0100202:	89 d6                	mov    %edx,%esi
f0100204:	c1 e6 18             	shl    $0x18,%esi
f0100207:	89 d0                	mov    %edx,%eax
f0100209:	c1 e0 10             	shl    $0x10,%eax
f010020c:	09 f0                	or     %esi,%eax
f010020e:	09 d0                	or     %edx,%eax
f0100210:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f0100212:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
f0100215:	fc                   	cld    
f0100216:	f3 ab                	rep stos %eax,%es:(%edi)
f0100218:	eb 03                	jmp    f010021d <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f010021a:	fc                   	cld    
f010021b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f010021d:	89 f8                	mov    %edi,%eax
f010021f:	8b 1c 24             	mov    (%esp),%ebx
f0100222:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100226:	8b 7c 24 08          	mov    0x8(%esp),%edi
f010022a:	83 c4 0c             	add    $0xc,%esp
f010022d:	c3                   	ret    

f010022e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f010022e:	83 ec 08             	sub    $0x8,%esp
f0100231:	89 34 24             	mov    %esi,(%esp)
f0100234:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100238:	8b 44 24 0c          	mov    0xc(%esp),%eax
f010023c:	8b 74 24 10          	mov    0x10(%esp),%esi
f0100240:	8b 4c 24 14          	mov    0x14(%esp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0100244:	39 c6                	cmp    %eax,%esi
f0100246:	73 36                	jae    f010027e <memmove+0x50>
f0100248:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f010024b:	39 d0                	cmp    %edx,%eax
f010024d:	73 2f                	jae    f010027e <memmove+0x50>
		s += n;
		d += n;
f010024f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0100252:	f6 c2 03             	test   $0x3,%dl
f0100255:	75 1b                	jne    f0100272 <memmove+0x44>
f0100257:	f7 c7 03 00 00 00    	test   $0x3,%edi
f010025d:	75 13                	jne    f0100272 <memmove+0x44>
f010025f:	f6 c1 03             	test   $0x3,%cl
f0100262:	75 0e                	jne    f0100272 <memmove+0x44>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0100264:	83 ef 04             	sub    $0x4,%edi
f0100267:	8d 72 fc             	lea    -0x4(%edx),%esi
f010026a:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
f010026d:	fd                   	std    
f010026e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0100270:	eb 09                	jmp    f010027b <memmove+0x4d>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0100272:	83 ef 01             	sub    $0x1,%edi
f0100275:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f0100278:	fd                   	std    
f0100279:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f010027b:	fc                   	cld    
f010027c:	eb 20                	jmp    f010029e <memmove+0x70>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010027e:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0100284:	75 13                	jne    f0100299 <memmove+0x6b>
f0100286:	a8 03                	test   $0x3,%al
f0100288:	75 0f                	jne    f0100299 <memmove+0x6b>
f010028a:	f6 c1 03             	test   $0x3,%cl
f010028d:	75 0a                	jne    f0100299 <memmove+0x6b>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f010028f:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
f0100292:	89 c7                	mov    %eax,%edi
f0100294:	fc                   	cld    
f0100295:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0100297:	eb 05                	jmp    f010029e <memmove+0x70>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0100299:	89 c7                	mov    %eax,%edi
f010029b:	fc                   	cld    
f010029c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f010029e:	8b 34 24             	mov    (%esp),%esi
f01002a1:	8b 7c 24 04          	mov    0x4(%esp),%edi
f01002a5:	83 c4 08             	add    $0x8,%esp
f01002a8:	c3                   	ret    

f01002a9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f01002a9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f01002ac:	8b 44 24 18          	mov    0x18(%esp),%eax
f01002b0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01002b4:	8b 44 24 14          	mov    0x14(%esp),%eax
f01002b8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01002bc:	8b 44 24 10          	mov    0x10(%esp),%eax
f01002c0:	89 04 24             	mov    %eax,(%esp)
f01002c3:	e8 66 ff ff ff       	call   f010022e <memmove>
}
f01002c8:	83 c4 0c             	add    $0xc,%esp
f01002cb:	c3                   	ret    

f01002cc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f01002cc:	57                   	push   %edi
f01002cd:	56                   	push   %esi
f01002ce:	53                   	push   %ebx
f01002cf:	8b 5c 24 10          	mov    0x10(%esp),%ebx
f01002d3:	8b 74 24 14          	mov    0x14(%esp),%esi
f01002d7:	8b 7c 24 18          	mov    0x18(%esp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
f01002db:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01002e0:	85 ff                	test   %edi,%edi
f01002e2:	74 38                	je     f010031c <memcmp+0x50>
		if (*s1 != *s2)
f01002e4:	0f b6 03             	movzbl (%ebx),%eax
f01002e7:	0f b6 0e             	movzbl (%esi),%ecx
f01002ea:	38 c8                	cmp    %cl,%al
f01002ec:	74 1d                	je     f010030b <memcmp+0x3f>
f01002ee:	eb 11                	jmp    f0100301 <memcmp+0x35>
f01002f0:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
f01002f5:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
f01002fa:	83 c2 01             	add    $0x1,%edx
f01002fd:	38 c8                	cmp    %cl,%al
f01002ff:	74 12                	je     f0100313 <memcmp+0x47>
			return (int) *s1 - (int) *s2;
f0100301:	0f b6 c0             	movzbl %al,%eax
f0100304:	0f b6 c9             	movzbl %cl,%ecx
f0100307:	29 c8                	sub    %ecx,%eax
f0100309:	eb 11                	jmp    f010031c <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f010030b:	83 ef 01             	sub    $0x1,%edi
f010030e:	ba 00 00 00 00       	mov    $0x0,%edx
f0100313:	39 fa                	cmp    %edi,%edx
f0100315:	75 d9                	jne    f01002f0 <memcmp+0x24>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
f0100317:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010031c:	5b                   	pop    %ebx
f010031d:	5e                   	pop    %esi
f010031e:	5f                   	pop    %edi
f010031f:	c3                   	ret    

f0100320 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0100320:	8b 44 24 04          	mov    0x4(%esp),%eax
	const void *ends = (const char *) s + n;
f0100324:	89 c2                	mov    %eax,%edx
f0100326:	03 54 24 0c          	add    0xc(%esp),%edx
	for (; s < ends; s++)
f010032a:	39 d0                	cmp    %edx,%eax
f010032c:	73 16                	jae    f0100344 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
f010032e:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
f0100333:	38 08                	cmp    %cl,(%eax)
f0100335:	75 06                	jne    f010033d <memfind+0x1d>
f0100337:	f3 c3                	repz ret 
f0100339:	38 08                	cmp    %cl,(%eax)
f010033b:	74 07                	je     f0100344 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f010033d:	83 c0 01             	add    $0x1,%eax
f0100340:	39 c2                	cmp    %eax,%edx
f0100342:	77 f5                	ja     f0100339 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
f0100344:	f3 c3                	repz ret 

f0100346 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0100346:	55                   	push   %ebp
f0100347:	57                   	push   %edi
f0100348:	56                   	push   %esi
f0100349:	53                   	push   %ebx
f010034a:	8b 54 24 14          	mov    0x14(%esp),%edx
f010034e:	8b 74 24 18          	mov    0x18(%esp),%esi
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0100352:	0f b6 02             	movzbl (%edx),%eax
f0100355:	3c 20                	cmp    $0x20,%al
f0100357:	74 04                	je     f010035d <strtol+0x17>
f0100359:	3c 09                	cmp    $0x9,%al
f010035b:	75 0e                	jne    f010036b <strtol+0x25>
		s++;
f010035d:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0100360:	0f b6 02             	movzbl (%edx),%eax
f0100363:	3c 20                	cmp    $0x20,%al
f0100365:	74 f6                	je     f010035d <strtol+0x17>
f0100367:	3c 09                	cmp    $0x9,%al
f0100369:	74 f2                	je     f010035d <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
f010036b:	3c 2b                	cmp    $0x2b,%al
f010036d:	75 0a                	jne    f0100379 <strtol+0x33>
		s++;
f010036f:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
f0100372:	bf 00 00 00 00       	mov    $0x0,%edi
f0100377:	eb 10                	jmp    f0100389 <strtol+0x43>
f0100379:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
f010037e:	3c 2d                	cmp    $0x2d,%al
f0100380:	75 07                	jne    f0100389 <strtol+0x43>
		s++, neg = 1;
f0100382:	83 c2 01             	add    $0x1,%edx
f0100385:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0100389:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
f010038e:	0f 94 c0             	sete   %al
f0100391:	74 07                	je     f010039a <strtol+0x54>
f0100393:	83 7c 24 1c 10       	cmpl   $0x10,0x1c(%esp)
f0100398:	75 18                	jne    f01003b2 <strtol+0x6c>
f010039a:	80 3a 30             	cmpb   $0x30,(%edx)
f010039d:	75 13                	jne    f01003b2 <strtol+0x6c>
f010039f:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f01003a3:	75 0d                	jne    f01003b2 <strtol+0x6c>
		s += 2, base = 16;
f01003a5:	83 c2 02             	add    $0x2,%edx
f01003a8:	c7 44 24 1c 10 00 00 	movl   $0x10,0x1c(%esp)
f01003af:	00 
f01003b0:	eb 1c                	jmp    f01003ce <strtol+0x88>
	else if (base == 0 && s[0] == '0')
f01003b2:	84 c0                	test   %al,%al
f01003b4:	74 18                	je     f01003ce <strtol+0x88>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f01003b6:	c7 44 24 1c 0a 00 00 	movl   $0xa,0x1c(%esp)
f01003bd:	00 
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f01003be:	80 3a 30             	cmpb   $0x30,(%edx)
f01003c1:	75 0b                	jne    f01003ce <strtol+0x88>
		s++, base = 8;
f01003c3:	83 c2 01             	add    $0x1,%edx
f01003c6:	c7 44 24 1c 08 00 00 	movl   $0x8,0x1c(%esp)
f01003cd:	00 
	else if (base == 0)
		base = 10;
f01003ce:	b8 00 00 00 00       	mov    $0x0,%eax

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f01003d3:	0f b6 0a             	movzbl (%edx),%ecx
f01003d6:	8d 69 d0             	lea    -0x30(%ecx),%ebp
f01003d9:	89 eb                	mov    %ebp,%ebx
f01003db:	80 fb 09             	cmp    $0x9,%bl
f01003de:	77 08                	ja     f01003e8 <strtol+0xa2>
			dig = *s - '0';
f01003e0:	0f be c9             	movsbl %cl,%ecx
f01003e3:	83 e9 30             	sub    $0x30,%ecx
f01003e6:	eb 22                	jmp    f010040a <strtol+0xc4>
		else if (*s >= 'a' && *s <= 'z')
f01003e8:	8d 69 9f             	lea    -0x61(%ecx),%ebp
f01003eb:	89 eb                	mov    %ebp,%ebx
f01003ed:	80 fb 19             	cmp    $0x19,%bl
f01003f0:	77 08                	ja     f01003fa <strtol+0xb4>
			dig = *s - 'a' + 10;
f01003f2:	0f be c9             	movsbl %cl,%ecx
f01003f5:	83 e9 57             	sub    $0x57,%ecx
f01003f8:	eb 10                	jmp    f010040a <strtol+0xc4>
		else if (*s >= 'A' && *s <= 'Z')
f01003fa:	8d 69 bf             	lea    -0x41(%ecx),%ebp
f01003fd:	89 eb                	mov    %ebp,%ebx
f01003ff:	80 fb 19             	cmp    $0x19,%bl
f0100402:	77 19                	ja     f010041d <strtol+0xd7>
			dig = *s - 'A' + 10;
f0100404:	0f be c9             	movsbl %cl,%ecx
f0100407:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
f010040a:	3b 4c 24 1c          	cmp    0x1c(%esp),%ecx
f010040e:	7d 11                	jge    f0100421 <strtol+0xdb>
			break;
		s++, val = (val * base) + dig;
f0100410:	83 c2 01             	add    $0x1,%edx
f0100413:	0f af 44 24 1c       	imul   0x1c(%esp),%eax
f0100418:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
f010041b:	eb b6                	jmp    f01003d3 <strtol+0x8d>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
f010041d:	89 c1                	mov    %eax,%ecx
f010041f:	eb 02                	jmp    f0100423 <strtol+0xdd>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0100421:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
f0100423:	85 f6                	test   %esi,%esi
f0100425:	74 02                	je     f0100429 <strtol+0xe3>
		*endptr = (char *) s;
f0100427:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
f0100429:	89 ca                	mov    %ecx,%edx
f010042b:	f7 da                	neg    %edx
f010042d:	85 ff                	test   %edi,%edi
f010042f:	0f 45 c2             	cmovne %edx,%eax
}
f0100432:	5b                   	pop    %ebx
f0100433:	5e                   	pop    %esi
f0100434:	5f                   	pop    %edi
f0100435:	5d                   	pop    %ebp
f0100436:	c3                   	ret    
	...

f0100438 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
f0100438:	53                   	push   %ebx
f0100439:	83 ec 18             	sub    $0x18,%esp
f010043c:	8b 5c 24 24          	mov    0x24(%esp),%ebx
	b->buf[b->idx++] = ch;
f0100440:	8b 03                	mov    (%ebx),%eax
f0100442:	8b 54 24 20          	mov    0x20(%esp),%edx
f0100446:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
f010044a:	83 c0 01             	add    $0x1,%eax
f010044d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
f010044f:	3d ff 00 00 00       	cmp    $0xff,%eax
f0100454:	75 19                	jne    f010046f <putch+0x37>
		puts(b->buf, b->idx);
f0100456:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
f010045d:	00 
f010045e:	8d 43 08             	lea    0x8(%ebx),%eax
f0100461:	89 04 24             	mov    %eax,(%esp)
f0100464:	e8 01 0b 00 00       	call   f0100f6a <puts>
		b->idx = 0;
f0100469:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
f010046f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
f0100473:	83 c4 18             	add    $0x18,%esp
f0100476:	5b                   	pop    %ebx
f0100477:	c3                   	ret    

f0100478 <vcprintf>:


int
vcprintf(const char *fmt, va_list ap)
{
f0100478:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
	struct printbuf b;

	b.idx = 0;
f010047e:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
f0100485:	00 
	b.cnt = 0;
f0100486:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
f010048d:	00 
	vprintfmt((void*)putch, &b, fmt, ap);
f010048e:	8b 84 24 34 01 00 00 	mov    0x134(%esp),%eax
f0100495:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100499:	8b 84 24 30 01 00 00 	mov    0x130(%esp),%eax
f01004a0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01004a4:	8d 44 24 18          	lea    0x18(%esp),%eax
f01004a8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01004ac:	c7 04 24 38 04 10 f0 	movl   $0xf0100438,(%esp)
f01004b3:	e8 b7 01 00 00       	call   f010066f <vprintfmt>
	puts(b.buf, b.idx);
f01004b8:	8b 44 24 18          	mov    0x18(%esp),%eax
f01004bc:	89 44 24 04          	mov    %eax,0x4(%esp)
f01004c0:	8d 44 24 20          	lea    0x20(%esp),%eax
f01004c4:	89 04 24             	mov    %eax,(%esp)
f01004c7:	e8 9e 0a 00 00       	call   f0100f6a <puts>

	return b.cnt;
}
f01004cc:	8b 44 24 1c          	mov    0x1c(%esp),%eax
f01004d0:	81 c4 2c 01 00 00    	add    $0x12c,%esp
f01004d6:	c3                   	ret    

f01004d7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f01004d7:	83 ec 1c             	sub    $0x1c,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f01004da:	8d 44 24 24          	lea    0x24(%esp),%eax
	cnt = vcprintf(fmt, ap);
f01004de:	89 44 24 04          	mov    %eax,0x4(%esp)
f01004e2:	8b 44 24 20          	mov    0x20(%esp),%eax
f01004e6:	89 04 24             	mov    %eax,(%esp)
f01004e9:	e8 8a ff ff ff       	call   f0100478 <vcprintf>
	va_end(ap);

	return cnt;
}
f01004ee:	83 c4 1c             	add    $0x1c,%esp
f01004f1:	c3                   	ret    
	...

f0100500 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0100500:	55                   	push   %ebp
f0100501:	57                   	push   %edi
f0100502:	56                   	push   %esi
f0100503:	53                   	push   %ebx
f0100504:	83 ec 3c             	sub    $0x3c,%esp
f0100507:	89 c5                	mov    %eax,%ebp
f0100509:	89 d6                	mov    %edx,%esi
f010050b:	8b 44 24 50          	mov    0x50(%esp),%eax
f010050f:	89 44 24 24          	mov    %eax,0x24(%esp)
f0100513:	8b 54 24 54          	mov    0x54(%esp),%edx
f0100517:	89 54 24 20          	mov    %edx,0x20(%esp)
f010051b:	8b 5c 24 5c          	mov    0x5c(%esp),%ebx
f010051f:	8b 7c 24 60          	mov    0x60(%esp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0100523:	b8 00 00 00 00       	mov    $0x0,%eax
f0100528:	39 d0                	cmp    %edx,%eax
f010052a:	72 13                	jb     f010053f <printnum+0x3f>
f010052c:	8b 4c 24 24          	mov    0x24(%esp),%ecx
f0100530:	39 4c 24 58          	cmp    %ecx,0x58(%esp)
f0100534:	76 09                	jbe    f010053f <printnum+0x3f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f0100536:	83 eb 01             	sub    $0x1,%ebx
f0100539:	85 db                	test   %ebx,%ebx
f010053b:	7f 63                	jg     f01005a0 <printnum+0xa0>
f010053d:	eb 71                	jmp    f01005b0 <printnum+0xb0>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
f010053f:	89 7c 24 10          	mov    %edi,0x10(%esp)
f0100543:	83 eb 01             	sub    $0x1,%ebx
f0100546:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010054a:	8b 5c 24 58          	mov    0x58(%esp),%ebx
f010054e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0100552:	8b 44 24 08          	mov    0x8(%esp),%eax
f0100556:	8b 54 24 0c          	mov    0xc(%esp),%edx
f010055a:	89 44 24 28          	mov    %eax,0x28(%esp)
f010055e:	89 54 24 2c          	mov    %edx,0x2c(%esp)
f0100562:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0100569:	00 
f010056a:	8b 54 24 24          	mov    0x24(%esp),%edx
f010056e:	89 14 24             	mov    %edx,(%esp)
f0100571:	8b 4c 24 20          	mov    0x20(%esp),%ecx
f0100575:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0100579:	e8 12 10 00 00       	call   f0101590 <__udivdi3>
f010057e:	8b 4c 24 28          	mov    0x28(%esp),%ecx
f0100582:	8b 5c 24 2c          	mov    0x2c(%esp),%ebx
f0100586:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010058a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010058e:	89 04 24             	mov    %eax,(%esp)
f0100591:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100595:	89 f2                	mov    %esi,%edx
f0100597:	89 e8                	mov    %ebp,%eax
f0100599:	e8 62 ff ff ff       	call   f0100500 <printnum>
f010059e:	eb 10                	jmp    f01005b0 <printnum+0xb0>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f01005a0:	89 74 24 04          	mov    %esi,0x4(%esp)
f01005a4:	89 3c 24             	mov    %edi,(%esp)
f01005a7:	ff d5                	call   *%ebp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f01005a9:	83 eb 01             	sub    $0x1,%ebx
f01005ac:	85 db                	test   %ebx,%ebx
f01005ae:	7f f0                	jg     f01005a0 <printnum+0xa0>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f01005b0:	89 74 24 04          	mov    %esi,0x4(%esp)
f01005b4:	8b 74 24 04          	mov    0x4(%esp),%esi
f01005b8:	8b 44 24 58          	mov    0x58(%esp),%eax
f01005bc:	89 44 24 08          	mov    %eax,0x8(%esp)
f01005c0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f01005c7:	00 
f01005c8:	8b 54 24 24          	mov    0x24(%esp),%edx
f01005cc:	89 14 24             	mov    %edx,(%esp)
f01005cf:	8b 4c 24 20          	mov    0x20(%esp),%ecx
f01005d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f01005d7:	e8 34 11 00 00       	call   f0101710 <__umoddi3>
f01005dc:	89 74 24 04          	mov    %esi,0x4(%esp)
f01005e0:	0f be 80 88 61 10 f0 	movsbl -0xfef9e78(%eax),%eax
f01005e7:	89 04 24             	mov    %eax,(%esp)
f01005ea:	ff d5                	call   *%ebp
}
f01005ec:	83 c4 3c             	add    $0x3c,%esp
f01005ef:	5b                   	pop    %ebx
f01005f0:	5e                   	pop    %esi
f01005f1:	5f                   	pop    %edi
f01005f2:	5d                   	pop    %ebp
f01005f3:	c3                   	ret    

f01005f4 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f01005f4:	83 fa 01             	cmp    $0x1,%edx
f01005f7:	7e 0d                	jle    f0100606 <getuint+0x12>
		return va_arg(*ap, unsigned long long);
f01005f9:	8b 10                	mov    (%eax),%edx
f01005fb:	8d 4a 08             	lea    0x8(%edx),%ecx
f01005fe:	89 08                	mov    %ecx,(%eax)
f0100600:	8b 02                	mov    (%edx),%eax
f0100602:	8b 52 04             	mov    0x4(%edx),%edx
f0100605:	c3                   	ret    
	else if (lflag)
f0100606:	85 d2                	test   %edx,%edx
f0100608:	74 0f                	je     f0100619 <getuint+0x25>
		return va_arg(*ap, unsigned long);
f010060a:	8b 10                	mov    (%eax),%edx
f010060c:	8d 4a 04             	lea    0x4(%edx),%ecx
f010060f:	89 08                	mov    %ecx,(%eax)
f0100611:	8b 02                	mov    (%edx),%eax
f0100613:	ba 00 00 00 00       	mov    $0x0,%edx
f0100618:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
f0100619:	8b 10                	mov    (%eax),%edx
f010061b:	8d 4a 04             	lea    0x4(%edx),%ecx
f010061e:	89 08                	mov    %ecx,(%eax)
f0100620:	8b 02                	mov    (%edx),%eax
f0100622:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0100627:	c3                   	ret    

f0100628 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0100628:	8b 44 24 08          	mov    0x8(%esp),%eax
	b->cnt++;
f010062c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0100630:	8b 10                	mov    (%eax),%edx
f0100632:	3b 50 04             	cmp    0x4(%eax),%edx
f0100635:	73 0b                	jae    f0100642 <sprintputch+0x1a>
		*b->buf++ = ch;
f0100637:	8b 4c 24 04          	mov    0x4(%esp),%ecx
f010063b:	88 0a                	mov    %cl,(%edx)
f010063d:	83 c2 01             	add    $0x1,%edx
f0100640:	89 10                	mov    %edx,(%eax)
f0100642:	f3 c3                	repz ret 

f0100644 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
f0100644:	83 ec 1c             	sub    $0x1c,%esp
	va_list ap;

	va_start(ap, fmt);
f0100647:	8d 44 24 2c          	lea    0x2c(%esp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f010064b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010064f:	8b 44 24 28          	mov    0x28(%esp),%eax
f0100653:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100657:	8b 44 24 24          	mov    0x24(%esp),%eax
f010065b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010065f:	8b 44 24 20          	mov    0x20(%esp),%eax
f0100663:	89 04 24             	mov    %eax,(%esp)
f0100666:	e8 04 00 00 00       	call   f010066f <vprintfmt>
	va_end(ap);
}
f010066b:	83 c4 1c             	add    $0x1c,%esp
f010066e:	c3                   	ret    

f010066f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f010066f:	55                   	push   %ebp
f0100670:	57                   	push   %edi
f0100671:	56                   	push   %esi
f0100672:	53                   	push   %ebx
f0100673:	83 ec 4c             	sub    $0x4c,%esp
f0100676:	8b 6c 24 60          	mov    0x60(%esp),%ebp
f010067a:	8b 7c 24 64          	mov    0x64(%esp),%edi
f010067e:	8b 5c 24 68          	mov    0x68(%esp),%ebx
f0100682:	eb 11                	jmp    f0100695 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
f0100684:	85 c0                	test   %eax,%eax
f0100686:	0f 84 40 04 00 00    	je     f0100acc <vprintfmt+0x45d>
				return;
			putch(ch, putdat);
f010068c:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100690:	89 04 24             	mov    %eax,(%esp)
f0100693:	ff d5                	call   *%ebp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0100695:	0f b6 03             	movzbl (%ebx),%eax
f0100698:	83 c3 01             	add    $0x1,%ebx
f010069b:	83 f8 25             	cmp    $0x25,%eax
f010069e:	75 e4                	jne    f0100684 <vprintfmt+0x15>
f01006a0:	c6 44 24 28 20       	movb   $0x20,0x28(%esp)
f01006a5:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
f01006ac:	00 
f01006ad:	be ff ff ff ff       	mov    $0xffffffff,%esi
f01006b2:	c7 44 24 30 ff ff ff 	movl   $0xffffffff,0x30(%esp)
f01006b9:	ff 
f01006ba:	b9 00 00 00 00       	mov    $0x0,%ecx
f01006bf:	89 74 24 34          	mov    %esi,0x34(%esp)
f01006c3:	eb 34                	jmp    f01006f9 <vprintfmt+0x8a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01006c5:	8b 5c 24 24          	mov    0x24(%esp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
f01006c9:	c6 44 24 28 2d       	movb   $0x2d,0x28(%esp)
f01006ce:	eb 29                	jmp    f01006f9 <vprintfmt+0x8a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01006d0:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
f01006d4:	c6 44 24 28 30       	movb   $0x30,0x28(%esp)
f01006d9:	eb 1e                	jmp    f01006f9 <vprintfmt+0x8a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01006db:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
f01006df:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%esp)
f01006e6:	00 
f01006e7:	eb 10                	jmp    f01006f9 <vprintfmt+0x8a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
f01006e9:	8b 44 24 34          	mov    0x34(%esp),%eax
f01006ed:	89 44 24 30          	mov    %eax,0x30(%esp)
f01006f1:	c7 44 24 34 ff ff ff 	movl   $0xffffffff,0x34(%esp)
f01006f8:	ff 
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01006f9:	0f b6 03             	movzbl (%ebx),%eax
f01006fc:	0f b6 d0             	movzbl %al,%edx
f01006ff:	8d 73 01             	lea    0x1(%ebx),%esi
f0100702:	89 74 24 24          	mov    %esi,0x24(%esp)
f0100706:	83 e8 23             	sub    $0x23,%eax
f0100709:	3c 55                	cmp    $0x55,%al
f010070b:	0f 87 9c 03 00 00    	ja     f0100aad <vprintfmt+0x43e>
f0100711:	0f b6 c0             	movzbl %al,%eax
f0100714:	ff 24 85 00 60 10 f0 	jmp    *-0xfefa000(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
f010071b:	83 ea 30             	sub    $0x30,%edx
f010071e:	89 54 24 34          	mov    %edx,0x34(%esp)
				ch = *fmt;
f0100722:	8b 54 24 24          	mov    0x24(%esp),%edx
f0100726:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
f0100729:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010072c:	8b 5c 24 24          	mov    0x24(%esp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
f0100730:	83 fa 09             	cmp    $0x9,%edx
f0100733:	77 5b                	ja     f0100790 <vprintfmt+0x121>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0100735:	8b 74 24 34          	mov    0x34(%esp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
f0100739:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
f010073c:	8d 14 b6             	lea    (%esi,%esi,4),%edx
f010073f:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
f0100743:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
f0100746:	8d 50 d0             	lea    -0x30(%eax),%edx
f0100749:	83 fa 09             	cmp    $0x9,%edx
f010074c:	76 eb                	jbe    f0100739 <vprintfmt+0xca>
f010074e:	89 74 24 34          	mov    %esi,0x34(%esp)
f0100752:	eb 3c                	jmp    f0100790 <vprintfmt+0x121>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f0100754:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f0100758:	8d 50 04             	lea    0x4(%eax),%edx
f010075b:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f010075f:	8b 00                	mov    (%eax),%eax
f0100761:	89 44 24 34          	mov    %eax,0x34(%esp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0100765:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
f0100769:	eb 25                	jmp    f0100790 <vprintfmt+0x121>

		case '.':
			if (width < 0)
f010076b:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
f0100770:	0f 88 65 ff ff ff    	js     f01006db <vprintfmt+0x6c>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0100776:	8b 5c 24 24          	mov    0x24(%esp),%ebx
f010077a:	e9 7a ff ff ff       	jmp    f01006f9 <vprintfmt+0x8a>
f010077f:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
f0100783:	c7 44 24 2c 01 00 00 	movl   $0x1,0x2c(%esp)
f010078a:	00 
			goto reswitch;
f010078b:	e9 69 ff ff ff       	jmp    f01006f9 <vprintfmt+0x8a>

		process_precision:
			if (width < 0)
f0100790:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
f0100795:	0f 89 5e ff ff ff    	jns    f01006f9 <vprintfmt+0x8a>
f010079b:	e9 49 ff ff ff       	jmp    f01006e9 <vprintfmt+0x7a>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f01007a0:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01007a3:	8b 5c 24 24          	mov    0x24(%esp),%ebx
f01007a7:	e9 4d ff ff ff       	jmp    f01006f9 <vprintfmt+0x8a>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f01007ac:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f01007b0:	8d 50 04             	lea    0x4(%eax),%edx
f01007b3:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f01007b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01007bb:	8b 00                	mov    (%eax),%eax
f01007bd:	89 04 24             	mov    %eax,(%esp)
f01007c0:	ff d5                	call   *%ebp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01007c2:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
f01007c6:	e9 ca fe ff ff       	jmp    f0100695 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
f01007cb:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f01007cf:	8d 50 04             	lea    0x4(%eax),%edx
f01007d2:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f01007d6:	8b 00                	mov    (%eax),%eax
f01007d8:	89 c2                	mov    %eax,%edx
f01007da:	c1 fa 1f             	sar    $0x1f,%edx
f01007dd:	31 d0                	xor    %edx,%eax
f01007df:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f01007e1:	83 f8 08             	cmp    $0x8,%eax
f01007e4:	7f 0b                	jg     f01007f1 <vprintfmt+0x182>
f01007e6:	8b 14 85 60 61 10 f0 	mov    -0xfef9ea0(,%eax,4),%edx
f01007ed:	85 d2                	test   %edx,%edx
f01007ef:	75 21                	jne    f0100812 <vprintfmt+0x1a3>
				printfmt(putch, putdat, "error %d", err);
f01007f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01007f5:	c7 44 24 08 a0 61 10 	movl   $0xf01061a0,0x8(%esp)
f01007fc:	f0 
f01007fd:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100801:	89 2c 24             	mov    %ebp,(%esp)
f0100804:	e8 3b fe ff ff       	call   f0100644 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0100809:	8b 5c 24 24          	mov    0x24(%esp),%ebx
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
f010080d:	e9 83 fe ff ff       	jmp    f0100695 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
f0100812:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0100816:	c7 44 24 08 88 6b 10 	movl   $0xf0106b88,0x8(%esp)
f010081d:	f0 
f010081e:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100822:	89 2c 24             	mov    %ebp,(%esp)
f0100825:	e8 1a fe ff ff       	call   f0100644 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010082a:	8b 5c 24 24          	mov    0x24(%esp),%ebx
f010082e:	e9 62 fe ff ff       	jmp    f0100695 <vprintfmt+0x26>
f0100833:	8b 74 24 34          	mov    0x34(%esp),%esi
f0100837:	8b 5c 24 24          	mov    0x24(%esp),%ebx
f010083b:	8b 44 24 30          	mov    0x30(%esp),%eax
f010083f:	89 44 24 38          	mov    %eax,0x38(%esp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f0100843:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f0100847:	8d 50 04             	lea    0x4(%eax),%edx
f010084a:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f010084e:	8b 00                	mov    (%eax),%eax
				p = "(null)";
f0100850:	85 c0                	test   %eax,%eax
f0100852:	ba 99 61 10 f0       	mov    $0xf0106199,%edx
f0100857:	0f 45 d0             	cmovne %eax,%edx
f010085a:	89 54 24 34          	mov    %edx,0x34(%esp)
			if (width > 0 && padc != '-')
f010085e:	83 7c 24 38 00       	cmpl   $0x0,0x38(%esp)
f0100863:	7e 07                	jle    f010086c <vprintfmt+0x1fd>
f0100865:	80 7c 24 28 2d       	cmpb   $0x2d,0x28(%esp)
f010086a:	75 14                	jne    f0100880 <vprintfmt+0x211>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010086c:	8b 54 24 34          	mov    0x34(%esp),%edx
f0100870:	0f be 02             	movsbl (%edx),%eax
f0100873:	85 c0                	test   %eax,%eax
f0100875:	0f 85 ac 00 00 00    	jne    f0100927 <vprintfmt+0x2b8>
f010087b:	e9 97 00 00 00       	jmp    f0100917 <vprintfmt+0x2a8>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f0100880:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100884:	8b 44 24 34          	mov    0x34(%esp),%eax
f0100888:	89 04 24             	mov    %eax,(%esp)
f010088b:	e8 89 f7 ff ff       	call   f0100019 <strnlen>
f0100890:	8b 54 24 38          	mov    0x38(%esp),%edx
f0100894:	29 c2                	sub    %eax,%edx
f0100896:	89 54 24 30          	mov    %edx,0x30(%esp)
f010089a:	85 d2                	test   %edx,%edx
f010089c:	7e ce                	jle    f010086c <vprintfmt+0x1fd>
					putch(padc, putdat);
f010089e:	0f be 44 24 28       	movsbl 0x28(%esp),%eax
f01008a3:	89 74 24 38          	mov    %esi,0x38(%esp)
f01008a7:	89 5c 24 3c          	mov    %ebx,0x3c(%esp)
f01008ab:	89 d3                	mov    %edx,%ebx
f01008ad:	89 c6                	mov    %eax,%esi
f01008af:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01008b3:	89 34 24             	mov    %esi,(%esp)
f01008b6:	ff d5                	call   *%ebp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f01008b8:	83 eb 01             	sub    $0x1,%ebx
f01008bb:	85 db                	test   %ebx,%ebx
f01008bd:	7f f0                	jg     f01008af <vprintfmt+0x240>
f01008bf:	8b 74 24 38          	mov    0x38(%esp),%esi
f01008c3:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
f01008c7:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%esp)
f01008ce:	00 
f01008cf:	eb 9b                	jmp    f010086c <vprintfmt+0x1fd>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f01008d1:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
f01008d6:	74 19                	je     f01008f1 <vprintfmt+0x282>
f01008d8:	8d 50 e0             	lea    -0x20(%eax),%edx
f01008db:	83 fa 5e             	cmp    $0x5e,%edx
f01008de:	76 11                	jbe    f01008f1 <vprintfmt+0x282>
					putch('?', putdat);
f01008e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01008e4:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f01008eb:	ff 54 24 28          	call   *0x28(%esp)
f01008ef:	eb 0b                	jmp    f01008fc <vprintfmt+0x28d>
				else
					putch(ch, putdat);
f01008f1:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01008f5:	89 04 24             	mov    %eax,(%esp)
f01008f8:	ff 54 24 28          	call   *0x28(%esp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f01008fc:	83 ed 01             	sub    $0x1,%ebp
f01008ff:	0f be 03             	movsbl (%ebx),%eax
f0100902:	85 c0                	test   %eax,%eax
f0100904:	74 05                	je     f010090b <vprintfmt+0x29c>
f0100906:	83 c3 01             	add    $0x1,%ebx
f0100909:	eb 31                	jmp    f010093c <vprintfmt+0x2cd>
f010090b:	89 6c 24 30          	mov    %ebp,0x30(%esp)
f010090f:	8b 6c 24 28          	mov    0x28(%esp),%ebp
f0100913:	8b 5c 24 38          	mov    0x38(%esp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0100917:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
f010091c:	7f 35                	jg     f0100953 <vprintfmt+0x2e4>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010091e:	8b 5c 24 24          	mov    0x24(%esp),%ebx
f0100922:	e9 6e fd ff ff       	jmp    f0100695 <vprintfmt+0x26>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0100927:	8b 54 24 34          	mov    0x34(%esp),%edx
f010092b:	83 c2 01             	add    $0x1,%edx
f010092e:	89 6c 24 28          	mov    %ebp,0x28(%esp)
f0100932:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0100936:	89 5c 24 38          	mov    %ebx,0x38(%esp)
f010093a:	89 d3                	mov    %edx,%ebx
f010093c:	85 f6                	test   %esi,%esi
f010093e:	78 91                	js     f01008d1 <vprintfmt+0x262>
f0100940:	83 ee 01             	sub    $0x1,%esi
f0100943:	79 8c                	jns    f01008d1 <vprintfmt+0x262>
f0100945:	89 6c 24 30          	mov    %ebp,0x30(%esp)
f0100949:	8b 6c 24 28          	mov    0x28(%esp),%ebp
f010094d:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0100951:	eb c4                	jmp    f0100917 <vprintfmt+0x2a8>
f0100953:	89 de                	mov    %ebx,%esi
f0100955:	8b 5c 24 30          	mov    0x30(%esp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
f0100959:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010095d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f0100964:	ff d5                	call   *%ebp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0100966:	83 eb 01             	sub    $0x1,%ebx
f0100969:	85 db                	test   %ebx,%ebx
f010096b:	7f ec                	jg     f0100959 <vprintfmt+0x2ea>
f010096d:	89 f3                	mov    %esi,%ebx
f010096f:	e9 21 fd ff ff       	jmp    f0100695 <vprintfmt+0x26>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f0100974:	83 f9 01             	cmp    $0x1,%ecx
f0100977:	7e 12                	jle    f010098b <vprintfmt+0x31c>
		return va_arg(*ap, long long);
f0100979:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f010097d:	8d 50 08             	lea    0x8(%eax),%edx
f0100980:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f0100984:	8b 18                	mov    (%eax),%ebx
f0100986:	8b 70 04             	mov    0x4(%eax),%esi
f0100989:	eb 2a                	jmp    f01009b5 <vprintfmt+0x346>
	else if (lflag)
f010098b:	85 c9                	test   %ecx,%ecx
f010098d:	74 14                	je     f01009a3 <vprintfmt+0x334>
		return va_arg(*ap, long);
f010098f:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f0100993:	8d 50 04             	lea    0x4(%eax),%edx
f0100996:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f010099a:	8b 18                	mov    (%eax),%ebx
f010099c:	89 de                	mov    %ebx,%esi
f010099e:	c1 fe 1f             	sar    $0x1f,%esi
f01009a1:	eb 12                	jmp    f01009b5 <vprintfmt+0x346>
	else
		return va_arg(*ap, int);
f01009a3:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f01009a7:	8d 50 04             	lea    0x4(%eax),%edx
f01009aa:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f01009ae:	8b 18                	mov    (%eax),%ebx
f01009b0:	89 de                	mov    %ebx,%esi
f01009b2:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
f01009b5:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
f01009ba:	85 f6                	test   %esi,%esi
f01009bc:	0f 89 ab 00 00 00    	jns    f0100a6d <vprintfmt+0x3fe>
				putch('-', putdat);
f01009c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01009c6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f01009cd:	ff d5                	call   *%ebp
				num = -(long long) num;
f01009cf:	f7 db                	neg    %ebx
f01009d1:	83 d6 00             	adc    $0x0,%esi
f01009d4:	f7 de                	neg    %esi
			}
			base = 10;
f01009d6:	b8 0a 00 00 00       	mov    $0xa,%eax
f01009db:	e9 8d 00 00 00       	jmp    f0100a6d <vprintfmt+0x3fe>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f01009e0:	89 ca                	mov    %ecx,%edx
f01009e2:	8d 44 24 6c          	lea    0x6c(%esp),%eax
f01009e6:	e8 09 fc ff ff       	call   f01005f4 <getuint>
f01009eb:	89 c3                	mov    %eax,%ebx
f01009ed:	89 d6                	mov    %edx,%esi
			base = 10;
f01009ef:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
f01009f4:	eb 77                	jmp    f0100a6d <vprintfmt+0x3fe>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
f01009f6:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01009fa:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
f0100a01:	ff d5                	call   *%ebp
			putch('X', putdat);
f0100a03:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100a07:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
f0100a0e:	ff d5                	call   *%ebp
			putch('X', putdat);
f0100a10:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100a14:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
f0100a1b:	ff d5                	call   *%ebp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0100a1d:	8b 5c 24 24          	mov    0x24(%esp),%ebx
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
			putch('X', putdat);
			putch('X', putdat);
			break;
f0100a21:	e9 6f fc ff ff       	jmp    f0100695 <vprintfmt+0x26>

		// pointer
		case 'p':
			putch('0', putdat);
f0100a26:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100a2a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f0100a31:	ff d5                	call   *%ebp
			putch('x', putdat);
f0100a33:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100a37:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f0100a3e:	ff d5                	call   *%ebp
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
f0100a40:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f0100a44:	8d 50 04             	lea    0x4(%eax),%edx
f0100a47:	89 54 24 6c          	mov    %edx,0x6c(%esp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
f0100a4b:	8b 18                	mov    (%eax),%ebx
f0100a4d:	be 00 00 00 00       	mov    $0x0,%esi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
f0100a52:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
f0100a57:	eb 14                	jmp    f0100a6d <vprintfmt+0x3fe>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
f0100a59:	89 ca                	mov    %ecx,%edx
f0100a5b:	8d 44 24 6c          	lea    0x6c(%esp),%eax
f0100a5f:	e8 90 fb ff ff       	call   f01005f4 <getuint>
f0100a64:	89 c3                	mov    %eax,%ebx
f0100a66:	89 d6                	mov    %edx,%esi
			base = 16;
f0100a68:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
f0100a6d:	0f be 54 24 28       	movsbl 0x28(%esp),%edx
f0100a72:	89 54 24 10          	mov    %edx,0x10(%esp)
f0100a76:	8b 54 24 30          	mov    0x30(%esp),%edx
f0100a7a:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0100a7e:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100a82:	89 1c 24             	mov    %ebx,(%esp)
f0100a85:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100a89:	89 fa                	mov    %edi,%edx
f0100a8b:	89 e8                	mov    %ebp,%eax
f0100a8d:	e8 6e fa ff ff       	call   f0100500 <printnum>
			break;
f0100a92:	8b 5c 24 24          	mov    0x24(%esp),%ebx
f0100a96:	e9 fa fb ff ff       	jmp    f0100695 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
f0100a9b:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100a9f:	89 14 24             	mov    %edx,(%esp)
f0100aa2:	ff d5                	call   *%ebp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0100aa4:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
f0100aa8:	e9 e8 fb ff ff       	jmp    f0100695 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
f0100aad:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100ab1:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f0100ab8:	ff d5                	call   *%ebp
			for (fmt--; fmt[-1] != '%'; fmt--)
f0100aba:	eb 02                	jmp    f0100abe <vprintfmt+0x44f>
f0100abc:	89 c3                	mov    %eax,%ebx
f0100abe:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0100ac1:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
f0100ac5:	75 f5                	jne    f0100abc <vprintfmt+0x44d>
f0100ac7:	e9 c9 fb ff ff       	jmp    f0100695 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
f0100acc:	83 c4 4c             	add    $0x4c,%esp
f0100acf:	5b                   	pop    %ebx
f0100ad0:	5e                   	pop    %esi
f0100ad1:	5f                   	pop    %edi
f0100ad2:	5d                   	pop    %ebp
f0100ad3:	c3                   	ret    

f0100ad4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0100ad4:	83 ec 2c             	sub    $0x2c,%esp
f0100ad7:	8b 44 24 30          	mov    0x30(%esp),%eax
f0100adb:	8b 54 24 34          	mov    0x34(%esp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0100adf:	89 44 24 14          	mov    %eax,0x14(%esp)
f0100ae3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0100ae7:	89 4c 24 18          	mov    %ecx,0x18(%esp)
f0100aeb:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
f0100af2:	00 

	if (buf == NULL || n < 1)
f0100af3:	85 c0                	test   %eax,%eax
f0100af5:	74 35                	je     f0100b2c <vsnprintf+0x58>
f0100af7:	85 d2                	test   %edx,%edx
f0100af9:	7e 31                	jle    f0100b2c <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0100afb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f0100aff:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100b03:	8b 44 24 38          	mov    0x38(%esp),%eax
f0100b07:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100b0b:	8d 44 24 14          	lea    0x14(%esp),%eax
f0100b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b13:	c7 04 24 28 06 10 f0 	movl   $0xf0100628,(%esp)
f0100b1a:	e8 50 fb ff ff       	call   f010066f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0100b1f:	8b 44 24 14          	mov    0x14(%esp),%eax
f0100b23:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0100b26:	8b 44 24 1c          	mov    0x1c(%esp),%eax
f0100b2a:	eb 05                	jmp    f0100b31 <vsnprintf+0x5d>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
f0100b2c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
f0100b31:	83 c4 2c             	add    $0x2c,%esp
f0100b34:	c3                   	ret    

f0100b35 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0100b35:	83 ec 1c             	sub    $0x1c,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0100b38:	8d 44 24 2c          	lea    0x2c(%esp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0100b3c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100b40:	8b 44 24 28          	mov    0x28(%esp),%eax
f0100b44:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100b48:	8b 44 24 24          	mov    0x24(%esp),%eax
f0100b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b50:	8b 44 24 20          	mov    0x20(%esp),%eax
f0100b54:	89 04 24             	mov    %eax,(%esp)
f0100b57:	e8 78 ff ff ff       	call   f0100ad4 <vsnprintf>
	va_end(ap);

	return rc;
}
f0100b5c:	83 c4 1c             	add    $0x1c,%esp
f0100b5f:	c3                   	ret    

f0100b60 <readline>:
extern int hist_head;
extern int hist_tail;
extern int hist_curr;

char *readline(const char *prompt)
{
f0100b60:	55                   	push   %ebp
f0100b61:	57                   	push   %edi
f0100b62:	56                   	push   %esi
f0100b63:	53                   	push   %ebx
f0100b64:	83 ec 1c             	sub    $0x1c,%esp
  int i, c;

  if (prompt != NULL)
f0100b67:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
f0100b6c:	74 14                	je     f0100b82 <readline+0x22>
    cprintf("%s", prompt);
f0100b6e:	8b 44 24 30          	mov    0x30(%esp),%eax
f0100b72:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b76:	c7 04 24 88 6b 10 f0 	movl   $0xf0106b88,(%esp)
f0100b7d:	e8 55 f9 ff ff       	call   f01004d7 <cprintf>
          if (hist_curr != hist_tail)
            hist_curr = (hist_curr == SHELL_HIST_MAX-1) ? 0 : hist_curr+1;

          while (i --)
            cprintf("\b");
          for (i = 0 ; hist[hist_curr][i] ; i ++) {
f0100b82:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100b87:	eb 0c                	jmp    f0100b95 <readline+0x35>
          if (hist_curr != hist_head)
            hist_curr = (hist_curr == 0) ? SHELL_HIST_MAX-1 : hist_curr-1;

          while (i --)
            cprintf("\b");
          for (i = 0 ; hist[hist_curr][i] ; i ++) {
f0100b89:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100b8e:	eb 05                	jmp    f0100b95 <readline+0x35>
          if (hist_curr != hist_tail)
            hist_curr = (hist_curr == SHELL_HIST_MAX-1) ? 0 : hist_curr+1;

          while (i --)
            cprintf("\b");
          for (i = 0 ; hist[hist_curr][i] ; i ++) {
f0100b90:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (prompt != NULL)
    cprintf("%s", prompt);

  i = 0;
  while (1) {
    c = getchar();
f0100b95:	e8 5d 03 00 00       	call   f0100ef7 <getchar>
f0100b9a:	89 c6                	mov    %eax,%esi

    // Fill the found command into current buffer
    if (is_tab && is_found && c != '\t') {
f0100b9c:	83 3d 00 c0 10 f0 00 	cmpl   $0x0,0xf010c000
f0100ba3:	74 59                	je     f0100bfe <readline+0x9e>
f0100ba5:	83 3d 04 c0 10 f0 00 	cmpl   $0x0,0xf010c004
f0100bac:	74 50                	je     f0100bfe <readline+0x9e>
f0100bae:	83 f8 09             	cmp    $0x9,%eax
f0100bb1:	74 4b                	je     f0100bfe <readline+0x9e>
      strcpy(buf, commands[tab_idx].name);
f0100bb3:	a1 08 c0 10 f0       	mov    0xf010c008,%eax
f0100bb8:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100bbb:	8b 04 85 00 80 10 f0 	mov    -0xfef8000(,%eax,4),%eax
f0100bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100bc6:	c7 04 24 20 c0 10 f0 	movl   $0xf010c020,(%esp)
f0100bcd:	e8 6c f4 ff ff       	call   f010003e <strcpy>
      i = strlen(buf);
f0100bd2:	c7 04 24 20 c0 10 f0 	movl   $0xf010c020,(%esp)
f0100bd9:	e8 22 f4 ff ff       	call   f0100000 <strlen>
f0100bde:	89 c3                	mov    %eax,%ebx
      tab_idx = 0;
f0100be0:	c7 05 08 c0 10 f0 00 	movl   $0x0,0xf010c008
f0100be7:	00 00 00 
      is_tab = 0;
f0100bea:	c7 05 00 c0 10 f0 00 	movl   $0x0,0xf010c000
f0100bf1:	00 00 00 
      is_found = 0;
f0100bf4:	c7 05 04 c0 10 f0 00 	movl   $0x0,0xf010c004
f0100bfb:	00 00 00 
    }

    if (c < 0) {
f0100bfe:	85 f6                	test   %esi,%esi
f0100c00:	79 1a                	jns    f0100c1c <readline+0xbc>
      cprintf("read error: %e\n", c);
f0100c02:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100c06:	c7 04 24 3c 62 10 f0 	movl   $0xf010623c,(%esp)
f0100c0d:	e8 c5 f8 ff ff       	call   f01004d7 <cprintf>
      return NULL;
f0100c12:	b8 00 00 00 00       	mov    $0x0,%eax
f0100c17:	e9 af 02 00 00       	jmp    f0100ecb <readline+0x36b>
    } else if ((c == '\b' || c == '\x7f') && i > 0) {
f0100c1c:	83 fe 08             	cmp    $0x8,%esi
f0100c1f:	74 05                	je     f0100c26 <readline+0xc6>
f0100c21:	83 fe 7f             	cmp    $0x7f,%esi
f0100c24:	75 18                	jne    f0100c3e <readline+0xde>
f0100c26:	85 db                	test   %ebx,%ebx
f0100c28:	7e 14                	jle    f0100c3e <readline+0xde>
      cprintf("\b");
f0100c2a:	c7 04 24 4c 62 10 f0 	movl   $0xf010624c,(%esp)
f0100c31:	e8 a1 f8 ff ff       	call   f01004d7 <cprintf>
      i--;
f0100c36:	83 eb 01             	sub    $0x1,%ebx
f0100c39:	e9 57 ff ff ff       	jmp    f0100b95 <readline+0x35>
    } else if (c >= ' ' && c <= 0x7E && i < BUFLEN-1) {
f0100c3e:	8d 46 e0             	lea    -0x20(%esi),%eax
f0100c41:	83 f8 5e             	cmp    $0x5e,%eax
f0100c44:	77 28                	ja     f0100c6e <readline+0x10e>
f0100c46:	81 fb fe 03 00 00    	cmp    $0x3fe,%ebx
f0100c4c:	7f 20                	jg     f0100c6e <readline+0x10e>
      cprintf("%c",c);
f0100c4e:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100c52:	c7 04 24 4e 62 10 f0 	movl   $0xf010624e,(%esp)
f0100c59:	e8 79 f8 ff ff       	call   f01004d7 <cprintf>
      buf[i++] = c;
f0100c5e:	89 f0                	mov    %esi,%eax
f0100c60:	88 83 20 c0 10 f0    	mov    %al,-0xfef3fe0(%ebx)
f0100c66:	83 c3 01             	add    $0x1,%ebx
f0100c69:	e9 27 ff ff ff       	jmp    f0100b95 <readline+0x35>
    } else if (c == '\n' || c == '\r') {
f0100c6e:	83 fe 0a             	cmp    $0xa,%esi
f0100c71:	74 05                	je     f0100c78 <readline+0x118>
f0100c73:	83 fe 0d             	cmp    $0xd,%esi
f0100c76:	75 1d                	jne    f0100c95 <readline+0x135>
      cprintf("\n");
f0100c78:	c7 04 24 52 68 10 f0 	movl   $0xf0106852,(%esp)
f0100c7f:	e8 53 f8 ff ff       	call   f01004d7 <cprintf>
      buf[i] = 0;
f0100c84:	c6 83 20 c0 10 f0 00 	movb   $0x0,-0xfef3fe0(%ebx)
      return buf;
f0100c8b:	b8 20 c0 10 f0       	mov    $0xf010c020,%eax
f0100c90:	e9 36 02 00 00       	jmp    f0100ecb <readline+0x36b>
    } else if (c == 0xc) { // ctrl-L or ctrl-l
f0100c95:	83 fe 0c             	cmp    $0xc,%esi
f0100c98:	75 1e                	jne    f0100cb8 <readline+0x158>
      cls();
f0100c9a:	e8 ff 03 00 00       	call   f010109e <cls>
      cprintf("%s", prompt);
f0100c9f:	8b 44 24 30          	mov    0x30(%esp),%eax
f0100ca3:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ca7:	c7 04 24 88 6b 10 f0 	movl   $0xf0106b88,(%esp)
f0100cae:	e8 24 f8 ff ff       	call   f01004d7 <cprintf>
f0100cb3:	e9 dd fe ff ff       	jmp    f0100b95 <readline+0x35>
    } else if (c == '\t') {
f0100cb8:	83 fe 09             	cmp    $0x9,%esi
f0100cbb:	0f 85 dd 00 00 00    	jne    f0100d9e <readline+0x23e>
      // Start from previous match
      int curr_idx = (is_found) ? tab_idx+1 : 0;
f0100cc1:	bf 00 00 00 00       	mov    $0x0,%edi
f0100cc6:	83 3d 04 c0 10 f0 00 	cmpl   $0x0,0xf010c004
f0100ccd:	74 0f                	je     f0100cde <readline+0x17e>
f0100ccf:	8b 3d 08 c0 10 f0    	mov    0xf010c008,%edi
f0100cd5:	83 c7 01             	add    $0x1,%edi
f0100cd8:	66 be 00 00          	mov    $0x0,%si
f0100cdc:	eb 26                	jmp    f0100d04 <readline+0x1a4>

extern int hist_head;
extern int hist_tail;
extern int hist_curr;

char *readline(const char *prompt)
f0100cde:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0100ce1:	8d 34 85 00 80 10 f0 	lea    -0xfef8000(,%eax,4),%esi
        int tmp;
        for (tmp = 0 ; tmp < strlen(commands[tab_idx].name)-i ; tmp ++)
          cprintf("\b");
      }

      for (curr_idx ; curr_idx < NCOMMANDS ; curr_idx ++) {
f0100ce8:	39 3d 84 61 10 f0    	cmp    %edi,0xf0106184
f0100cee:	7f 33                	jg     f0100d23 <readline+0x1c3>
f0100cf0:	e9 8e 00 00 00       	jmp    f0100d83 <readline+0x223>

      if (is_found) {
        // Clear the output of previous match
        int tmp;
        for (tmp = 0 ; tmp < strlen(commands[tab_idx].name)-i ; tmp ++)
          cprintf("\b");
f0100cf5:	c7 04 24 4c 62 10 f0 	movl   $0xf010624c,(%esp)
f0100cfc:	e8 d6 f7 ff ff       	call   f01004d7 <cprintf>
      int curr_idx = (is_found) ? tab_idx+1 : 0;

      if (is_found) {
        // Clear the output of previous match
        int tmp;
        for (tmp = 0 ; tmp < strlen(commands[tab_idx].name)-i ; tmp ++)
f0100d01:	83 c6 01             	add    $0x1,%esi
f0100d04:	a1 08 c0 10 f0       	mov    0xf010c008,%eax
f0100d09:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100d0c:	8b 04 85 00 80 10 f0 	mov    -0xfef8000(,%eax,4),%eax
f0100d13:	89 04 24             	mov    %eax,(%esp)
f0100d16:	e8 e5 f2 ff ff       	call   f0100000 <strlen>
f0100d1b:	29 d8                	sub    %ebx,%eax
f0100d1d:	39 c6                	cmp    %eax,%esi
f0100d1f:	7c d4                	jl     f0100cf5 <readline+0x195>
f0100d21:	eb bb                	jmp    f0100cde <readline+0x17e>
          cprintf("\b");
      }

      for (curr_idx ; curr_idx < NCOMMANDS ; curr_idx ++) {
        if (strncmp(commands[curr_idx].name, buf, i) == 0) {
f0100d23:	89 dd                	mov    %ebx,%ebp
f0100d25:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0100d29:	c7 44 24 04 20 c0 10 	movl   $0xf010c020,0x4(%esp)
f0100d30:	f0 
f0100d31:	8b 06                	mov    (%esi),%eax
f0100d33:	89 04 24             	mov    %eax,(%esp)
f0100d36:	e8 ec f3 ff ff       	call   f0100127 <strncmp>
f0100d3b:	85 c0                	test   %eax,%eax
f0100d3d:	75 36                	jne    f0100d75 <readline+0x215>
          // Show the found command, instead of changing the current buffer
          cprintf("%s", commands[curr_idx].name+i);
f0100d3f:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0100d42:	03 2c 85 00 80 10 f0 	add    -0xfef8000(,%eax,4),%ebp
f0100d49:	89 6c 24 04          	mov    %ebp,0x4(%esp)
f0100d4d:	c7 04 24 88 6b 10 f0 	movl   $0xf0106b88,(%esp)
f0100d54:	e8 7e f7 ff ff       	call   f01004d7 <cprintf>
          is_tab = 1;
f0100d59:	c7 05 00 c0 10 f0 01 	movl   $0x1,0xf010c000
f0100d60:	00 00 00 
          is_found = 1;
f0100d63:	c7 05 04 c0 10 f0 01 	movl   $0x1,0xf010c004
f0100d6a:	00 00 00 
          tab_idx = curr_idx;
f0100d6d:	89 3d 08 c0 10 f0    	mov    %edi,0xf010c008
          break;
f0100d73:	eb 0e                	jmp    f0100d83 <readline+0x223>
        int tmp;
        for (tmp = 0 ; tmp < strlen(commands[tab_idx].name)-i ; tmp ++)
          cprintf("\b");
      }

      for (curr_idx ; curr_idx < NCOMMANDS ; curr_idx ++) {
f0100d75:	83 c7 01             	add    $0x1,%edi
f0100d78:	83 c6 0c             	add    $0xc,%esi
f0100d7b:	39 3d 84 61 10 f0    	cmp    %edi,0xf0106184
f0100d81:	7f a0                	jg     f0100d23 <readline+0x1c3>
          is_found = 1;
          tab_idx = curr_idx;
          break;
        }
      }
      if (curr_idx == NCOMMANDS) {
f0100d83:	3b 3d 84 61 10 f0    	cmp    0xf0106184,%edi
f0100d89:	0f 85 06 fe ff ff    	jne    f0100b95 <readline+0x35>
          is_found = 0;
f0100d8f:	c7 05 04 c0 10 f0 00 	movl   $0x0,0xf010c004
f0100d96:	00 00 00 
f0100d99:	e9 f7 fd ff ff       	jmp    f0100b95 <readline+0x35>
      }

    } else if (c >= 0x80) {
f0100d9e:	83 fe 7f             	cmp    $0x7f,%esi
f0100da1:	0f 8e ee fd ff ff    	jle    f0100b95 <readline+0x35>
      switch (c)
f0100da7:	81 fe e2 00 00 00    	cmp    $0xe2,%esi
f0100dad:	74 11                	je     f0100dc0 <readline+0x260>
f0100daf:	81 fe e3 00 00 00    	cmp    $0xe3,%esi
f0100db5:	0f 85 da fd ff ff    	jne    f0100b95 <readline+0x35>
f0100dbb:	e9 85 00 00 00       	jmp    f0100e45 <readline+0x2e5>
      {
        case KEY_UP:
          if (hist_curr != hist_head)
f0100dc0:	a1 a0 5e 11 f0       	mov    0xf0115ea0,%eax
f0100dc5:	3b 05 a4 5e 11 f0    	cmp    0xf0115ea4,%eax
f0100dcb:	74 12                	je     f0100ddf <readline+0x27f>
            hist_curr = (hist_curr == 0) ? SHELL_HIST_MAX-1 : hist_curr-1;
f0100dcd:	8d 50 ff             	lea    -0x1(%eax),%edx
f0100dd0:	85 c0                	test   %eax,%eax
f0100dd2:	b8 09 00 00 00       	mov    $0x9,%eax
f0100dd7:	0f 45 c2             	cmovne %edx,%eax
f0100dda:	a3 a0 5e 11 f0       	mov    %eax,0xf0115ea0

          while (i --)
f0100ddf:	85 db                	test   %ebx,%ebx
f0100de1:	74 11                	je     f0100df4 <readline+0x294>
            cprintf("\b");
f0100de3:	c7 04 24 4c 62 10 f0 	movl   $0xf010624c,(%esp)
f0100dea:	e8 e8 f6 ff ff       	call   f01004d7 <cprintf>
      {
        case KEY_UP:
          if (hist_curr != hist_head)
            hist_curr = (hist_curr == 0) ? SHELL_HIST_MAX-1 : hist_curr-1;

          while (i --)
f0100def:	83 eb 01             	sub    $0x1,%ebx
f0100df2:	75 ef                	jne    f0100de3 <readline+0x283>
            cprintf("\b");
          for (i = 0 ; hist[hist_curr][i] ; i ++) {
f0100df4:	a1 a0 5e 11 f0       	mov    0xf0115ea0,%eax
f0100df9:	c1 e0 0a             	shl    $0xa,%eax
f0100dfc:	0f b6 80 c0 5e 11 f0 	movzbl -0xfeea140(%eax),%eax
f0100e03:	84 c0                	test   %al,%al
f0100e05:	0f 84 7e fd ff ff    	je     f0100b89 <readline+0x29>
f0100e0b:	bb 00 00 00 00       	mov    $0x0,%ebx
            buf[i] = hist[hist_curr][i];
f0100e10:	88 83 20 c0 10 f0    	mov    %al,-0xfef3fe0(%ebx)
            cprintf("%c",buf[i]);
f0100e16:	0f be c0             	movsbl %al,%eax
f0100e19:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100e1d:	c7 04 24 4e 62 10 f0 	movl   $0xf010624e,(%esp)
f0100e24:	e8 ae f6 ff ff       	call   f01004d7 <cprintf>
          if (hist_curr != hist_head)
            hist_curr = (hist_curr == 0) ? SHELL_HIST_MAX-1 : hist_curr-1;

          while (i --)
            cprintf("\b");
          for (i = 0 ; hist[hist_curr][i] ; i ++) {
f0100e29:	83 c3 01             	add    $0x1,%ebx
f0100e2c:	a1 a0 5e 11 f0       	mov    0xf0115ea0,%eax
f0100e31:	c1 e0 0a             	shl    $0xa,%eax
f0100e34:	0f b6 84 03 c0 5e 11 	movzbl -0xfeea140(%ebx,%eax,1),%eax
f0100e3b:	f0 
f0100e3c:	84 c0                	test   %al,%al
f0100e3e:	75 d0                	jne    f0100e10 <readline+0x2b0>
f0100e40:	e9 50 fd ff ff       	jmp    f0100b95 <readline+0x35>
            buf[i] = hist[hist_curr][i];
            cprintf("%c",buf[i]);
          }
          break;
        case KEY_DN:
          if (hist_curr != hist_tail)
f0100e45:	a1 a0 5e 11 f0       	mov    0xf0115ea0,%eax
f0100e4a:	3b 05 a8 5e 11 f0    	cmp    0xf0115ea8,%eax
f0100e50:	74 13                	je     f0100e65 <readline+0x305>
            hist_curr = (hist_curr == SHELL_HIST_MAX-1) ? 0 : hist_curr+1;
f0100e52:	8d 50 01             	lea    0x1(%eax),%edx
f0100e55:	83 f8 09             	cmp    $0x9,%eax
f0100e58:	b8 00 00 00 00       	mov    $0x0,%eax
f0100e5d:	0f 45 c2             	cmovne %edx,%eax
f0100e60:	a3 a0 5e 11 f0       	mov    %eax,0xf0115ea0

          while (i --)
f0100e65:	85 db                	test   %ebx,%ebx
f0100e67:	74 11                	je     f0100e7a <readline+0x31a>
            cprintf("\b");
f0100e69:	c7 04 24 4c 62 10 f0 	movl   $0xf010624c,(%esp)
f0100e70:	e8 62 f6 ff ff       	call   f01004d7 <cprintf>
          break;
        case KEY_DN:
          if (hist_curr != hist_tail)
            hist_curr = (hist_curr == SHELL_HIST_MAX-1) ? 0 : hist_curr+1;

          while (i --)
f0100e75:	83 eb 01             	sub    $0x1,%ebx
f0100e78:	75 ef                	jne    f0100e69 <readline+0x309>
            cprintf("\b");
          for (i = 0 ; hist[hist_curr][i] ; i ++) {
f0100e7a:	a1 a0 5e 11 f0       	mov    0xf0115ea0,%eax
f0100e7f:	c1 e0 0a             	shl    $0xa,%eax
f0100e82:	0f b6 80 c0 5e 11 f0 	movzbl -0xfeea140(%eax),%eax
f0100e89:	84 c0                	test   %al,%al
f0100e8b:	0f 84 ff fc ff ff    	je     f0100b90 <readline+0x30>
f0100e91:	bb 00 00 00 00       	mov    $0x0,%ebx
            buf[i] = hist[hist_curr][i];
f0100e96:	88 83 20 c0 10 f0    	mov    %al,-0xfef3fe0(%ebx)
            cprintf("%c",buf[i]);
f0100e9c:	0f be c0             	movsbl %al,%eax
f0100e9f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ea3:	c7 04 24 4e 62 10 f0 	movl   $0xf010624e,(%esp)
f0100eaa:	e8 28 f6 ff ff       	call   f01004d7 <cprintf>
          if (hist_curr != hist_tail)
            hist_curr = (hist_curr == SHELL_HIST_MAX-1) ? 0 : hist_curr+1;

          while (i --)
            cprintf("\b");
          for (i = 0 ; hist[hist_curr][i] ; i ++) {
f0100eaf:	83 c3 01             	add    $0x1,%ebx
f0100eb2:	a1 a0 5e 11 f0       	mov    0xf0115ea0,%eax
f0100eb7:	c1 e0 0a             	shl    $0xa,%eax
f0100eba:	0f b6 84 03 c0 5e 11 	movzbl -0xfeea140(%ebx,%eax,1),%eax
f0100ec1:	f0 
f0100ec2:	84 c0                	test   %al,%al
f0100ec4:	75 d0                	jne    f0100e96 <readline+0x336>
f0100ec6:	e9 ca fc ff ff       	jmp    f0100b95 <readline+0x35>
          }
          break;
      }
    }
  }
}
f0100ecb:	83 c4 1c             	add    $0x1c,%esp
f0100ece:	5b                   	pop    %ebx
f0100ecf:	5e                   	pop    %esi
f0100ed0:	5f                   	pop    %edi
f0100ed1:	5d                   	pop    %ebp
f0100ed2:	c3                   	ret    
	...

f0100ed4 <cputchar>:
#include <inc/syscall.h>


void
cputchar(int ch)
{
f0100ed4:	83 ec 2c             	sub    $0x2c,%esp
	char c = ch;
f0100ed7:	8b 44 24 30          	mov    0x30(%esp),%eax
f0100edb:	88 44 24 1f          	mov    %al,0x1f(%esp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	puts(&c, 1);
f0100edf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f0100ee6:	00 
f0100ee7:	8d 44 24 1f          	lea    0x1f(%esp),%eax
f0100eeb:	89 04 24             	mov    %eax,(%esp)
f0100eee:	e8 77 00 00 00       	call   f0100f6a <puts>
}
f0100ef3:	83 c4 2c             	add    $0x2c,%esp
f0100ef6:	c3                   	ret    

f0100ef7 <getchar>:

int
getchar(void)
{
f0100ef7:	83 ec 0c             	sub    $0xc,%esp
	int r;
	// sys_cgetc does not block, but getchar should.
	while ((r = getc()) == 0){};
f0100efa:	e8 09 00 00 00       	call   f0100f08 <getc>
f0100eff:	85 c0                	test   %eax,%eax
f0100f01:	74 f7                	je     f0100efa <getchar+0x3>
		//sys_yield();
	return r;
}
f0100f03:	83 c4 0c             	add    $0xc,%esp
f0100f06:	c3                   	ret    
	...

f0100f08 <getc>:

	return ret;
}


SYSCALL_NOARG(getc, int)
f0100f08:	83 ec 0c             	sub    $0xc,%esp
f0100f0b:	89 1c 24             	mov    %ebx,(%esp)
f0100f0e:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100f12:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0100f16:	ba 00 00 00 00       	mov    $0x0,%edx
f0100f1b:	b8 01 00 00 00       	mov    $0x1,%eax
f0100f20:	89 d1                	mov    %edx,%ecx
f0100f22:	89 d3                	mov    %edx,%ebx
f0100f24:	89 d7                	mov    %edx,%edi
f0100f26:	89 d6                	mov    %edx,%esi
f0100f28:	cd 30                	int    $0x30

	return ret;
}


SYSCALL_NOARG(getc, int)
f0100f2a:	8b 1c 24             	mov    (%esp),%ebx
f0100f2d:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100f31:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0100f35:	83 c4 0c             	add    $0xc,%esp
f0100f38:	c3                   	ret    

f0100f39 <getcid>:
SYSCALL_NOARG(getcid, int32_t)
f0100f39:	83 ec 0c             	sub    $0xc,%esp
f0100f3c:	89 1c 24             	mov    %ebx,(%esp)
f0100f3f:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100f43:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0100f47:	ba 00 00 00 00       	mov    $0x0,%edx
f0100f4c:	b8 03 00 00 00       	mov    $0x3,%eax
f0100f51:	89 d1                	mov    %edx,%ecx
f0100f53:	89 d3                	mov    %edx,%ebx
f0100f55:	89 d7                	mov    %edx,%edi
f0100f57:	89 d6                	mov    %edx,%esi
f0100f59:	cd 30                	int    $0x30
	return ret;
}


SYSCALL_NOARG(getc, int)
SYSCALL_NOARG(getcid, int32_t)
f0100f5b:	8b 1c 24             	mov    (%esp),%ebx
f0100f5e:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100f62:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0100f66:	83 c4 0c             	add    $0xc,%esp
f0100f69:	c3                   	ret    

f0100f6a <puts>:

void
puts(const char *s, size_t len)
{
f0100f6a:	83 ec 0c             	sub    $0xc,%esp
f0100f6d:	89 1c 24             	mov    %ebx,(%esp)
f0100f70:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100f74:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0100f78:	b8 00 00 00 00       	mov    $0x0,%eax
f0100f7d:	8b 4c 24 14          	mov    0x14(%esp),%ecx
f0100f81:	8b 54 24 10          	mov    0x10(%esp),%edx
f0100f85:	89 c3                	mov    %eax,%ebx
f0100f87:	89 c7                	mov    %eax,%edi
f0100f89:	89 c6                	mov    %eax,%esi
f0100f8b:	cd 30                	int    $0x30

void
puts(const char *s, size_t len)
{
	syscall(SYS_puts,(uint32_t)s, len, 0, 0, 0);
}
f0100f8d:	8b 1c 24             	mov    (%esp),%ebx
f0100f90:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100f94:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0100f98:	83 c4 0c             	add    $0xc,%esp
f0100f9b:	c3                   	ret    

f0100f9c <sleep>:
//see inc/syscall.h
void sleep(uint32_t ticks)
{
f0100f9c:	83 ec 0c             	sub    $0xc,%esp
f0100f9f:	89 1c 24             	mov    %ebx,(%esp)
f0100fa2:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100fa6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0100faa:	b9 00 00 00 00       	mov    $0x0,%ecx
f0100faf:	b8 06 00 00 00       	mov    $0x6,%eax
f0100fb4:	8b 54 24 10          	mov    0x10(%esp),%edx
f0100fb8:	89 cb                	mov    %ecx,%ebx
f0100fba:	89 cf                	mov    %ecx,%edi
f0100fbc:	89 ce                	mov    %ecx,%esi
f0100fbe:	cd 30                	int    $0x30
}
//see inc/syscall.h
void sleep(uint32_t ticks)
{
    syscall(SYS_sleep,ticks,0,0,0,0);
}
f0100fc0:	8b 1c 24             	mov    (%esp),%ebx
f0100fc3:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100fc7:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0100fcb:	83 c4 0c             	add    $0xc,%esp
f0100fce:	c3                   	ret    

f0100fcf <settextcolor>:
void settextcolor(unsigned char forecolor,unsigned char backcolor){
f0100fcf:	83 ec 0c             	sub    $0xc,%esp
f0100fd2:	89 1c 24             	mov    %ebx,(%esp)
f0100fd5:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100fd9:	89 7c 24 08          	mov    %edi,0x8(%esp)
    syscall(SYS_settextcolor,forecolor,backcolor,0,0,0);
f0100fdd:	0f b6 54 24 10       	movzbl 0x10(%esp),%edx
f0100fe2:	0f b6 4c 24 14       	movzbl 0x14(%esp),%ecx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0100fe7:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100fec:	b8 0a 00 00 00       	mov    $0xa,%eax
f0100ff1:	89 df                	mov    %ebx,%edi
f0100ff3:	89 de                	mov    %ebx,%esi
f0100ff5:	cd 30                	int    $0x30
{
    syscall(SYS_sleep,ticks,0,0,0,0);
}
void settextcolor(unsigned char forecolor,unsigned char backcolor){
    syscall(SYS_settextcolor,forecolor,backcolor,0,0,0);
}
f0100ff7:	8b 1c 24             	mov    (%esp),%ebx
f0100ffa:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100ffe:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0101002:	83 c4 0c             	add    $0xc,%esp
f0101005:	c3                   	ret    

f0101006 <fork>:
void kill_self()
{
    int pid = getpid();
    syscall(SYS_kill,pid,0,0,0,0);
}
SYSCALL_NOARG(fork, int32_t)
f0101006:	83 ec 0c             	sub    $0xc,%esp
f0101009:	89 1c 24             	mov    %ebx,(%esp)
f010100c:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101010:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0101014:	ba 00 00 00 00       	mov    $0x0,%edx
f0101019:	b8 04 00 00 00       	mov    $0x4,%eax
f010101e:	89 d1                	mov    %edx,%ecx
f0101020:	89 d3                	mov    %edx,%ebx
f0101022:	89 d7                	mov    %edx,%edi
f0101024:	89 d6                	mov    %edx,%esi
f0101026:	cd 30                	int    $0x30
void kill_self()
{
    int pid = getpid();
    syscall(SYS_kill,pid,0,0,0,0);
}
SYSCALL_NOARG(fork, int32_t)
f0101028:	8b 1c 24             	mov    (%esp),%ebx
f010102b:	8b 74 24 04          	mov    0x4(%esp),%esi
f010102f:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0101033:	83 c4 0c             	add    $0xc,%esp
f0101036:	c3                   	ret    

f0101037 <getpid>:
SYSCALL_NOARG(getpid, int32_t)
f0101037:	83 ec 0c             	sub    $0xc,%esp
f010103a:	89 1c 24             	mov    %ebx,(%esp)
f010103d:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101041:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0101045:	ba 00 00 00 00       	mov    $0x0,%edx
f010104a:	b8 02 00 00 00       	mov    $0x2,%eax
f010104f:	89 d1                	mov    %edx,%ecx
f0101051:	89 d3                	mov    %edx,%ebx
f0101053:	89 d7                	mov    %edx,%edi
f0101055:	89 d6                	mov    %edx,%esi
f0101057:	cd 30                	int    $0x30
{
    int pid = getpid();
    syscall(SYS_kill,pid,0,0,0,0);
}
SYSCALL_NOARG(fork, int32_t)
SYSCALL_NOARG(getpid, int32_t)
f0101059:	8b 1c 24             	mov    (%esp),%ebx
f010105c:	8b 74 24 04          	mov    0x4(%esp),%esi
f0101060:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0101064:	83 c4 0c             	add    $0xc,%esp
f0101067:	c3                   	ret    

f0101068 <kill_self>:
}
void settextcolor(unsigned char forecolor,unsigned char backcolor){
    syscall(SYS_settextcolor,forecolor,backcolor,0,0,0);
}
void kill_self()
{
f0101068:	83 ec 0c             	sub    $0xc,%esp
f010106b:	89 1c 24             	mov    %ebx,(%esp)
f010106e:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101072:	89 7c 24 08          	mov    %edi,0x8(%esp)
    int pid = getpid();
f0101076:	e8 bc ff ff ff       	call   f0101037 <getpid>
f010107b:	89 c2                	mov    %eax,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f010107d:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101082:	b8 05 00 00 00       	mov    $0x5,%eax
f0101087:	89 cb                	mov    %ecx,%ebx
f0101089:	89 cf                	mov    %ecx,%edi
f010108b:	89 ce                	mov    %ecx,%esi
f010108d:	cd 30                	int    $0x30
}
void kill_self()
{
    int pid = getpid();
    syscall(SYS_kill,pid,0,0,0,0);
}
f010108f:	8b 1c 24             	mov    (%esp),%ebx
f0101092:	8b 74 24 04          	mov    0x4(%esp),%esi
f0101096:	8b 7c 24 08          	mov    0x8(%esp),%edi
f010109a:	83 c4 0c             	add    $0xc,%esp
f010109d:	c3                   	ret    

f010109e <cls>:
SYSCALL_NOARG(fork, int32_t)
SYSCALL_NOARG(getpid, int32_t)
SYSCALL_NOARG(cls, int32_t)
f010109e:	83 ec 0c             	sub    $0xc,%esp
f01010a1:	89 1c 24             	mov    %ebx,(%esp)
f01010a4:	89 74 24 04          	mov    %esi,0x4(%esp)
f01010a8:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f01010ac:	ba 00 00 00 00       	mov    $0x0,%edx
f01010b1:	b8 0b 00 00 00       	mov    $0xb,%eax
f01010b6:	89 d1                	mov    %edx,%ecx
f01010b8:	89 d3                	mov    %edx,%ebx
f01010ba:	89 d7                	mov    %edx,%edi
f01010bc:	89 d6                	mov    %edx,%esi
f01010be:	cd 30                	int    $0x30
    int pid = getpid();
    syscall(SYS_kill,pid,0,0,0,0);
}
SYSCALL_NOARG(fork, int32_t)
SYSCALL_NOARG(getpid, int32_t)
SYSCALL_NOARG(cls, int32_t)
f01010c0:	8b 1c 24             	mov    (%esp),%ebx
f01010c3:	8b 74 24 04          	mov    0x4(%esp),%esi
f01010c7:	8b 7c 24 08          	mov    0x8(%esp),%edi
f01010cb:	83 c4 0c             	add    $0xc,%esp
f01010ce:	c3                   	ret    

f01010cf <get_num_free_page>:
SYSCALL_NOARG(get_num_free_page, int32_t)
f01010cf:	83 ec 0c             	sub    $0xc,%esp
f01010d2:	89 1c 24             	mov    %ebx,(%esp)
f01010d5:	89 74 24 04          	mov    %esi,0x4(%esp)
f01010d9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f01010dd:	ba 00 00 00 00       	mov    $0x0,%edx
f01010e2:	b8 08 00 00 00       	mov    $0x8,%eax
f01010e7:	89 d1                	mov    %edx,%ecx
f01010e9:	89 d3                	mov    %edx,%ebx
f01010eb:	89 d7                	mov    %edx,%edi
f01010ed:	89 d6                	mov    %edx,%esi
f01010ef:	cd 30                	int    $0x30
    syscall(SYS_kill,pid,0,0,0,0);
}
SYSCALL_NOARG(fork, int32_t)
SYSCALL_NOARG(getpid, int32_t)
SYSCALL_NOARG(cls, int32_t)
SYSCALL_NOARG(get_num_free_page, int32_t)
f01010f1:	8b 1c 24             	mov    (%esp),%ebx
f01010f4:	8b 74 24 04          	mov    0x4(%esp),%esi
f01010f8:	8b 7c 24 08          	mov    0x8(%esp),%edi
f01010fc:	83 c4 0c             	add    $0xc,%esp
f01010ff:	c3                   	ret    

f0101100 <get_num_used_page>:
SYSCALL_NOARG(get_num_used_page, int32_t)
f0101100:	83 ec 0c             	sub    $0xc,%esp
f0101103:	89 1c 24             	mov    %ebx,(%esp)
f0101106:	89 74 24 04          	mov    %esi,0x4(%esp)
f010110a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f010110e:	ba 00 00 00 00       	mov    $0x0,%edx
f0101113:	b8 07 00 00 00       	mov    $0x7,%eax
f0101118:	89 d1                	mov    %edx,%ecx
f010111a:	89 d3                	mov    %edx,%ebx
f010111c:	89 d7                	mov    %edx,%edi
f010111e:	89 d6                	mov    %edx,%esi
f0101120:	cd 30                	int    $0x30
}
SYSCALL_NOARG(fork, int32_t)
SYSCALL_NOARG(getpid, int32_t)
SYSCALL_NOARG(cls, int32_t)
SYSCALL_NOARG(get_num_free_page, int32_t)
SYSCALL_NOARG(get_num_used_page, int32_t)
f0101122:	8b 1c 24             	mov    (%esp),%ebx
f0101125:	8b 74 24 04          	mov    0x4(%esp),%esi
f0101129:	8b 7c 24 08          	mov    0x8(%esp),%edi
f010112d:	83 c4 0c             	add    $0xc,%esp
f0101130:	c3                   	ret    

f0101131 <get_ticks>:
//tick??????
SYSCALL_NOARG(get_ticks,unsigned long)
f0101131:	83 ec 0c             	sub    $0xc,%esp
f0101134:	89 1c 24             	mov    %ebx,(%esp)
f0101137:	89 74 24 04          	mov    %esi,0x4(%esp)
f010113b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f010113f:	ba 00 00 00 00       	mov    $0x0,%edx
f0101144:	b8 09 00 00 00       	mov    $0x9,%eax
f0101149:	89 d1                	mov    %edx,%ecx
f010114b:	89 d3                	mov    %edx,%ebx
f010114d:	89 d7                	mov    %edx,%edi
f010114f:	89 d6                	mov    %edx,%esi
f0101151:	cd 30                	int    $0x30
SYSCALL_NOARG(getpid, int32_t)
SYSCALL_NOARG(cls, int32_t)
SYSCALL_NOARG(get_num_free_page, int32_t)
SYSCALL_NOARG(get_num_used_page, int32_t)
//tick??????
SYSCALL_NOARG(get_ticks,unsigned long)
f0101153:	8b 1c 24             	mov    (%esp),%ebx
f0101156:	8b 74 24 04          	mov    0x4(%esp),%esi
f010115a:	8b 7c 24 08          	mov    0x8(%esp),%edi
f010115e:	83 c4 0c             	add    $0xc,%esp
f0101161:	c3                   	ret    
	...

f0101170 <mon_help>:
  cprintf("Free: %18d pages\n", get_num_free_page());
  return 0;
}

int mon_help(int argc, char **argv)
{
f0101170:	53                   	push   %ebx
f0101171:	83 ec 18             	sub    $0x18,%esp
f0101174:	bb 00 00 00 00       	mov    $0x0,%ebx
  int i;

  for (i = 0; i < NCOMMANDS; i++)
    cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f0101179:	8b 83 04 80 10 f0    	mov    -0xfef7ffc(%ebx),%eax
f010117f:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101183:	8b 83 00 80 10 f0    	mov    -0xfef8000(%ebx),%eax
f0101189:	89 44 24 04          	mov    %eax,0x4(%esp)
f010118d:	c7 04 24 51 62 10 f0 	movl   $0xf0106251,(%esp)
f0101194:	e8 3e f3 ff ff       	call   f01004d7 <cprintf>
f0101199:	83 c3 0c             	add    $0xc,%ebx

int mon_help(int argc, char **argv)
{
  int i;

  for (i = 0; i < NCOMMANDS; i++)
f010119c:	83 fb 48             	cmp    $0x48,%ebx
f010119f:	75 d8                	jne    f0101179 <mon_help+0x9>
    cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  return 0;
}
f01011a1:	b8 00 00 00 00       	mov    $0x0,%eax
f01011a6:	83 c4 18             	add    $0x18,%esp
f01011a9:	5b                   	pop    %ebx
f01011aa:	c3                   	ret    

f01011ab <spinlocktest>:
  }
  return 0;
}

int spinlocktest(int argc, char **argv)
{
f01011ab:	53                   	push   %ebx
f01011ac:	83 ec 18             	sub    $0x18,%esp
  /* Below code is running on user mode */
  if (!fork())
f01011af:	e8 52 fe ff ff       	call   f0101006 <fork>
f01011b4:	85 c0                	test   %eax,%eax
f01011b6:	75 43                	jne    f01011fb <spinlocktest+0x50>
  {
    /*Child*/
    fork();
f01011b8:	e8 49 fe ff ff       	call   f0101006 <fork>
f01011bd:	8d 76 00             	lea    0x0(%esi),%esi
    fork();
f01011c0:	e8 41 fe ff ff       	call   f0101006 <fork>
    fork();
f01011c5:	e8 3c fe ff ff       	call   f0101006 <fork>
    sleep(500);
f01011ca:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
f01011d1:	e8 c6 fd ff ff       	call   f0100f9c <sleep>
    cprintf("Pid=%d, Cid=%d\n", getpid(), getcid());
f01011d6:	e8 5e fd ff ff       	call   f0100f39 <getcid>
f01011db:	89 c3                	mov    %eax,%ebx
f01011dd:	e8 55 fe ff ff       	call   f0101037 <getpid>
f01011e2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f01011e6:	89 44 24 04          	mov    %eax,0x4(%esp)
f01011ea:	c7 04 24 5a 62 10 f0 	movl   $0xf010625a,(%esp)
f01011f1:	e8 e1 f2 ff ff       	call   f01004d7 <cprintf>
    /* task recycle */
    kill_self();
f01011f6:	e8 6d fe ff ff       	call   f0101068 <kill_self>
  }
  return 0;
}
f01011fb:	b8 00 00 00 00       	mov    $0x0,%eax
f0101200:	83 c4 18             	add    $0x18,%esp
f0101203:	5b                   	pop    %ebx
f0101204:	c3                   	ret    

f0101205 <chgcolor>:
  cprintf("Now tick = %d\n", get_ticks());
  return 0;
}

int chgcolor(int argc, char **argv)
{
f0101205:	53                   	push   %ebx
f0101206:	83 ec 18             	sub    $0x18,%esp
  if (argc > 1)
f0101209:	83 7c 24 20 01       	cmpl   $0x1,0x20(%esp)
f010120e:	7e 35                	jle    f0101245 <chgcolor+0x40>
  {
    char fore = argv[1][0] - '0';
f0101210:	8b 44 24 24          	mov    0x24(%esp),%eax
f0101214:	8b 40 04             	mov    0x4(%eax),%eax
f0101217:	0f b6 18             	movzbl (%eax),%ebx
f010121a:	83 eb 30             	sub    $0x30,%ebx
    settextcolor(fore, 0);
f010121d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101224:	00 
f0101225:	0f b6 c3             	movzbl %bl,%eax
f0101228:	89 04 24             	mov    %eax,(%esp)
f010122b:	e8 9f fd ff ff       	call   f0100fcf <settextcolor>
    cprintf("Change color %d!\n", fore);
f0101230:	0f be db             	movsbl %bl,%ebx
f0101233:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0101237:	c7 04 24 6a 62 10 f0 	movl   $0xf010626a,(%esp)
f010123e:	e8 94 f2 ff ff       	call   f01004d7 <cprintf>
f0101243:	eb 0c                	jmp    f0101251 <chgcolor+0x4c>
  }
  else
  {
    cprintf("No input text color!\n");
f0101245:	c7 04 24 7c 62 10 f0 	movl   $0xf010627c,(%esp)
f010124c:	e8 86 f2 ff ff       	call   f01004d7 <cprintf>
  }
  return 0;
}
f0101251:	b8 00 00 00 00       	mov    $0x0,%eax
f0101256:	83 c4 18             	add    $0x18,%esp
f0101259:	5b                   	pop    %ebx
f010125a:	c3                   	ret    

f010125b <print_tick>:
    cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  return 0;
}

int print_tick(int argc, char **argv)
{
f010125b:	83 ec 1c             	sub    $0x1c,%esp
  cprintf("Now tick = %d\n", get_ticks());
f010125e:	e8 ce fe ff ff       	call   f0101131 <get_ticks>
f0101263:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101267:	c7 04 24 92 62 10 f0 	movl   $0xf0106292,(%esp)
f010126e:	e8 64 f2 ff ff       	call   f01004d7 <cprintf>
  return 0;
}
f0101273:	b8 00 00 00 00       	mov    $0x0,%eax
f0101278:	83 c4 1c             	add    $0x1c,%esp
f010127b:	c3                   	ret    

f010127c <mem_stat>:
  { "spinlocktest", "Test spinlock", spinlocktest }
};
const int NCOMMANDS = (sizeof(commands)/sizeof(commands[0]));

int mem_stat(int argc, char **argv)
{
f010127c:	83 ec 1c             	sub    $0x1c,%esp
  cprintf("%-10s MEM_STAT %10s\n", "--------", "--------");
f010127f:	c7 44 24 08 a1 62 10 	movl   $0xf01062a1,0x8(%esp)
f0101286:	f0 
f0101287:	c7 44 24 04 a1 62 10 	movl   $0xf01062a1,0x4(%esp)
f010128e:	f0 
f010128f:	c7 04 24 aa 62 10 f0 	movl   $0xf01062aa,(%esp)
f0101296:	e8 3c f2 ff ff       	call   f01004d7 <cprintf>
  cprintf("Used: %18d pages\n", get_num_used_page());
f010129b:	e8 60 fe ff ff       	call   f0101100 <get_num_used_page>
f01012a0:	89 44 24 04          	mov    %eax,0x4(%esp)
f01012a4:	c7 04 24 bf 62 10 f0 	movl   $0xf01062bf,(%esp)
f01012ab:	e8 27 f2 ff ff       	call   f01004d7 <cprintf>
  cprintf("Free: %18d pages\n", get_num_free_page());
f01012b0:	e8 1a fe ff ff       	call   f01010cf <get_num_free_page>
f01012b5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01012b9:	c7 04 24 d1 62 10 f0 	movl   $0xf01062d1,(%esp)
f01012c0:	e8 12 f2 ff ff       	call   f01004d7 <cprintf>
  return 0;
}
f01012c5:	b8 00 00 00 00       	mov    $0x0,%eax
f01012ca:	83 c4 1c             	add    $0x1c,%esp
f01012cd:	c3                   	ret    

f01012ce <task_job>:
}



void task_job()
{
f01012ce:	57                   	push   %edi
f01012cf:	56                   	push   %esi
f01012d0:	53                   	push   %ebx
f01012d1:	83 ec 10             	sub    $0x10,%esp
	int pid = 0;
	int cid = 0;
	int i;

	pid = getpid();
f01012d4:	e8 5e fd ff ff       	call   f0101037 <getpid>
f01012d9:	89 c6                	mov    %eax,%esi
	cid = getcid();
f01012db:	e8 59 fc ff ff       	call   f0100f39 <getcid>
f01012e0:	89 c7                	mov    %eax,%edi
	for (i = 0; i < 10; i++)
f01012e2:	bb 00 00 00 00       	mov    $0x0,%ebx
	{
		cprintf("Pid=%d, Cid=%d, now=%d\n", pid, cid, i);
f01012e7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f01012eb:	89 7c 24 08          	mov    %edi,0x8(%esp)
f01012ef:	89 74 24 04          	mov    %esi,0x4(%esp)
f01012f3:	c7 04 24 e3 62 10 f0 	movl   $0xf01062e3,(%esp)
f01012fa:	e8 d8 f1 ff ff       	call   f01004d7 <cprintf>
		sleep(100);
f01012ff:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
f0101306:	e8 91 fc ff ff       	call   f0100f9c <sleep>
	int cid = 0;
	int i;

	pid = getpid();
	cid = getcid();
	for (i = 0; i < 10; i++)
f010130b:	83 c3 01             	add    $0x1,%ebx
f010130e:	83 fb 0a             	cmp    $0xa,%ebx
f0101311:	75 d4                	jne    f01012e7 <task_job+0x19>
	{
		cprintf("Pid=%d, Cid=%d, now=%d\n", pid, cid, i);
		sleep(100);
	}
}
f0101313:	83 c4 10             	add    $0x10,%esp
f0101316:	5b                   	pop    %ebx
f0101317:	5e                   	pop    %esi
f0101318:	5f                   	pop    %edi
f0101319:	c3                   	ret    

f010131a <forktest>:

int forktest(int argc, char **argv)
{
f010131a:	83 ec 0c             	sub    $0xc,%esp
  /* Below code is running on user mode */
  if (!fork())
f010131d:	e8 e4 fc ff ff       	call   f0101006 <fork>
f0101322:	85 c0                	test   %eax,%eax
f0101324:	75 54                	jne    f010137a <forktest+0x60>
  {

    /*Child*/
    task_job();
f0101326:	e8 a3 ff ff ff       	call   f01012ce <task_job>
f010132b:	90                   	nop
f010132c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (fork())
f0101330:	e8 d1 fc ff ff       	call   f0101006 <fork>
f0101335:	85 c0                	test   %eax,%eax
f0101337:	74 09                	je     f0101342 <forktest+0x28>
      task_job();
f0101339:	e8 90 ff ff ff       	call   f01012ce <task_job>
f010133e:	66 90                	xchg   %ax,%ax
f0101340:	eb 33                	jmp    f0101375 <forktest+0x5b>
    else
    {
      if (fork())
f0101342:	e8 bf fc ff ff       	call   f0101006 <fork>
f0101347:	85 c0                	test   %eax,%eax
f0101349:	74 0c                	je     f0101357 <forktest+0x3d>
f010134b:	90                   	nop
f010134c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        task_job();
f0101350:	e8 79 ff ff ff       	call   f01012ce <task_job>
f0101355:	eb 1e                	jmp    f0101375 <forktest+0x5b>
      else
        if (fork())
f0101357:	e8 aa fc ff ff       	call   f0101006 <fork>
f010135c:	85 c0                	test   %eax,%eax
f010135e:	66 90                	xchg   %ax,%ax
f0101360:	74 07                	je     f0101369 <forktest+0x4f>
          task_job();
f0101362:	e8 67 ff ff ff       	call   f01012ce <task_job>
f0101367:	eb 0c                	jmp    f0101375 <forktest+0x5b>
f0101369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        else
          task_job();
f0101370:	e8 59 ff ff ff       	call   f01012ce <task_job>
    }
    /* task recycle */
    kill_self();
f0101375:	e8 ee fc ff ff       	call   f0101068 <kill_self>
  }
  return 0;
}
f010137a:	b8 00 00 00 00       	mov    $0x0,%eax
f010137f:	83 c4 0c             	add    $0xc,%esp
f0101382:	c3                   	ret    

f0101383 <shell>:
  }
  return 0;
}

void shell()
{
f0101383:	55                   	push   %ebp
f0101384:	57                   	push   %edi
f0101385:	56                   	push   %esi
f0101386:	53                   	push   %ebx
f0101387:	83 ec 5c             	sub    $0x5c,%esp
  char *buf;
  hist_head = 0;
f010138a:	c7 05 a4 5e 11 f0 00 	movl   $0x0,0xf0115ea4
f0101391:	00 00 00 
  hist_tail = 0;
f0101394:	c7 05 a8 5e 11 f0 00 	movl   $0x0,0xf0115ea8
f010139b:	00 00 00 
  hist_curr = 0;
f010139e:	c7 05 a0 5e 11 f0 00 	movl   $0x0,0xf0115ea0
f01013a5:	00 00 00 

  cprintf("Welcome to the OSDI course!\n");
f01013a8:	c7 04 24 fb 62 10 f0 	movl   $0xf01062fb,(%esp)
f01013af:	e8 23 f1 ff ff       	call   f01004d7 <cprintf>
  cprintf("Type 'help' for a list of commands.\n");
f01013b4:	c7 04 24 08 64 10 f0 	movl   $0xf0106408,(%esp)
f01013bb:	e8 17 f1 ff ff       	call   f01004d7 <cprintf>
  {
    buf = readline("OSDI> ");
    if (buf != NULL)
    {
      strcpy(hist[hist_tail], buf);
      hist_tail = (hist_tail + 1) % SHELL_HIST_MAX;
f01013c0:	bd 67 66 66 66       	mov    $0x66666667,%ebp
  cprintf("Welcome to the OSDI course!\n");
  cprintf("Type 'help' for a list of commands.\n");

  while(1)
  {
    buf = readline("OSDI> ");
f01013c5:	c7 04 24 18 63 10 f0 	movl   $0xf0106318,(%esp)
f01013cc:	e8 8f f7 ff ff       	call   f0100b60 <readline>
f01013d1:	89 c3                	mov    %eax,%ebx
    if (buf != NULL)
f01013d3:	85 c0                	test   %eax,%eax
f01013d5:	74 ee                	je     f01013c5 <shell+0x42>
    {
      strcpy(hist[hist_tail], buf);
f01013d7:	89 44 24 04          	mov    %eax,0x4(%esp)
f01013db:	a1 a8 5e 11 f0       	mov    0xf0115ea8,%eax
f01013e0:	c1 e0 0a             	shl    $0xa,%eax
f01013e3:	05 c0 5e 11 f0       	add    $0xf0115ec0,%eax
f01013e8:	89 04 24             	mov    %eax,(%esp)
f01013eb:	e8 4e ec ff ff       	call   f010003e <strcpy>
      hist_tail = (hist_tail + 1) % SHELL_HIST_MAX;
f01013f0:	8b 35 a8 5e 11 f0    	mov    0xf0115ea8,%esi
f01013f6:	83 c6 01             	add    $0x1,%esi
f01013f9:	89 f0                	mov    %esi,%eax
f01013fb:	f7 ed                	imul   %ebp
f01013fd:	89 d1                	mov    %edx,%ecx
f01013ff:	c1 f9 02             	sar    $0x2,%ecx
f0101402:	89 f0                	mov    %esi,%eax
f0101404:	c1 f8 1f             	sar    $0x1f,%eax
f0101407:	29 c1                	sub    %eax,%ecx
f0101409:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
f010140c:	01 c0                	add    %eax,%eax
f010140e:	89 f1                	mov    %esi,%ecx
f0101410:	29 c1                	sub    %eax,%ecx
f0101412:	89 0d a8 5e 11 f0    	mov    %ecx,0xf0115ea8
      if (hist_head == hist_tail)
f0101418:	3b 0d a4 5e 11 f0    	cmp    0xf0115ea4,%ecx
f010141e:	75 2a                	jne    f010144a <shell+0xc7>
      {
        hist_head = (hist_head + 1) % SHELL_HIST_MAX;
f0101420:	8d 71 01             	lea    0x1(%ecx),%esi
f0101423:	89 f0                	mov    %esi,%eax
f0101425:	f7 ed                	imul   %ebp
f0101427:	c1 fa 02             	sar    $0x2,%edx
f010142a:	89 f0                	mov    %esi,%eax
f010142c:	c1 f8 1f             	sar    $0x1f,%eax
f010142f:	29 c2                	sub    %eax,%edx
f0101431:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0101434:	01 c0                	add    %eax,%eax
f0101436:	29 c6                	sub    %eax,%esi
f0101438:	89 35 a4 5e 11 f0    	mov    %esi,0xf0115ea4
        hist[hist_tail][0] = 0;
f010143e:	89 c8                	mov    %ecx,%eax
f0101440:	c1 e0 0a             	shl    $0xa,%eax
f0101443:	c6 80 c0 5e 11 f0 00 	movb   $0x0,-0xfeea140(%eax)
      }
      hist_curr = hist_tail;
f010144a:	89 0d a0 5e 11 f0    	mov    %ecx,0xf0115ea0
  char *argv[MAXARGS];
  int i;

  // Parse the command buffer into whitespace-separated arguments
  argc = 0;
  argv[argc] = 0;
f0101450:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
f0101457:	00 
  int argc;
  char *argv[MAXARGS];
  int i;

  // Parse the command buffer into whitespace-separated arguments
  argc = 0;
f0101458:	be 00 00 00 00       	mov    $0x0,%esi
f010145d:	eb 06                	jmp    f0101465 <shell+0xe2>
  argv[argc] = 0;
  while (1) {
    // gobble whitespace
    while (*buf && strchr(WHITESPACE, *buf))
      *buf++ = 0;
f010145f:	c6 03 00             	movb   $0x0,(%ebx)
f0101462:	83 c3 01             	add    $0x1,%ebx
  // Parse the command buffer into whitespace-separated arguments
  argc = 0;
  argv[argc] = 0;
  while (1) {
    // gobble whitespace
    while (*buf && strchr(WHITESPACE, *buf))
f0101465:	0f b6 03             	movzbl (%ebx),%eax
f0101468:	84 c0                	test   %al,%al
f010146a:	74 6d                	je     f01014d9 <shell+0x156>
f010146c:	0f be c0             	movsbl %al,%eax
f010146f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101473:	c7 04 24 1f 63 10 f0 	movl   $0xf010631f,(%esp)
f010147a:	e8 f2 ec ff ff       	call   f0100171 <strchr>
f010147f:	85 c0                	test   %eax,%eax
f0101481:	75 dc                	jne    f010145f <shell+0xdc>
      *buf++ = 0;
    if (*buf == 0)
f0101483:	80 3b 00             	cmpb   $0x0,(%ebx)
f0101486:	74 51                	je     f01014d9 <shell+0x156>
      break;

    // save and scan past next arg
    if (argc == MAXARGS-1) {
f0101488:	83 fe 0f             	cmp    $0xf,%esi
f010148b:	75 19                	jne    f01014a6 <shell+0x123>
      cprintf("Too many arguments (max %d)\n", MAXARGS);
f010148d:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f0101494:	00 
f0101495:	c7 04 24 24 63 10 f0 	movl   $0xf0106324,(%esp)
f010149c:	e8 36 f0 ff ff       	call   f01004d7 <cprintf>
f01014a1:	e9 1f ff ff ff       	jmp    f01013c5 <shell+0x42>
      return 0;
    }
    argv[argc++] = buf;
f01014a6:	89 5c b4 10          	mov    %ebx,0x10(%esp,%esi,4)
f01014aa:	83 c6 01             	add    $0x1,%esi
    while (*buf && !strchr(WHITESPACE, *buf))
f01014ad:	0f b6 03             	movzbl (%ebx),%eax
f01014b0:	84 c0                	test   %al,%al
f01014b2:	75 0c                	jne    f01014c0 <shell+0x13d>
f01014b4:	eb af                	jmp    f0101465 <shell+0xe2>
      buf++;
f01014b6:	83 c3 01             	add    $0x1,%ebx
    if (argc == MAXARGS-1) {
      cprintf("Too many arguments (max %d)\n", MAXARGS);
      return 0;
    }
    argv[argc++] = buf;
    while (*buf && !strchr(WHITESPACE, *buf))
f01014b9:	0f b6 03             	movzbl (%ebx),%eax
f01014bc:	84 c0                	test   %al,%al
f01014be:	74 a5                	je     f0101465 <shell+0xe2>
f01014c0:	0f be c0             	movsbl %al,%eax
f01014c3:	89 44 24 04          	mov    %eax,0x4(%esp)
f01014c7:	c7 04 24 1f 63 10 f0 	movl   $0xf010631f,(%esp)
f01014ce:	e8 9e ec ff ff       	call   f0100171 <strchr>
f01014d3:	85 c0                	test   %eax,%eax
f01014d5:	74 df                	je     f01014b6 <shell+0x133>
f01014d7:	eb 8c                	jmp    f0101465 <shell+0xe2>
      buf++;
  }
  argv[argc] = 0;
f01014d9:	c7 44 b4 10 00 00 00 	movl   $0x0,0x10(%esp,%esi,4)
f01014e0:	00 

  // Lookup and invoke the command
  if (argc == 0)
f01014e1:	85 f6                	test   %esi,%esi
f01014e3:	0f 84 dc fe ff ff    	je     f01013c5 <shell+0x42>
f01014e9:	bb 00 80 10 f0       	mov    $0xf0108000,%ebx
f01014ee:	bf 00 00 00 00       	mov    $0x0,%edi
    return 0;
  for (i = 0; i < NCOMMANDS; i++) {
    if (strcmp(argv[0], commands[i].name) == 0)
f01014f3:	8b 03                	mov    (%ebx),%eax
f01014f5:	89 44 24 04          	mov    %eax,0x4(%esp)
f01014f9:	8b 44 24 10          	mov    0x10(%esp),%eax
f01014fd:	89 04 24             	mov    %eax,(%esp)
f0101500:	e8 f5 eb ff ff       	call   f01000fa <strcmp>
f0101505:	85 c0                	test   %eax,%eax
f0101507:	75 1d                	jne    f0101526 <shell+0x1a3>
      return commands[i].func(argc, argv);
f0101509:	6b ff 0c             	imul   $0xc,%edi,%edi
f010150c:	8d 44 24 10          	lea    0x10(%esp),%eax
f0101510:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101514:	89 34 24             	mov    %esi,(%esp)
f0101517:	ff 97 08 80 10 f0    	call   *-0xfef7ff8(%edi)
        hist_head = (hist_head + 1) % SHELL_HIST_MAX;
        hist[hist_tail][0] = 0;
      }
      hist_curr = hist_tail;

      if (runcmd(buf) < 0)
f010151d:	85 c0                	test   %eax,%eax
f010151f:	78 29                	js     f010154a <shell+0x1c7>
f0101521:	e9 9f fe ff ff       	jmp    f01013c5 <shell+0x42>
  argv[argc] = 0;

  // Lookup and invoke the command
  if (argc == 0)
    return 0;
  for (i = 0; i < NCOMMANDS; i++) {
f0101526:	83 c7 01             	add    $0x1,%edi
f0101529:	83 c3 0c             	add    $0xc,%ebx
f010152c:	83 ff 06             	cmp    $0x6,%edi
f010152f:	75 c2                	jne    f01014f3 <shell+0x170>
    if (strcmp(argv[0], commands[i].name) == 0)
      return commands[i].func(argc, argv);
  }
  cprintf("Unknown command '%s'\n", argv[0]);
f0101531:	8b 44 24 10          	mov    0x10(%esp),%eax
f0101535:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101539:	c7 04 24 41 63 10 f0 	movl   $0xf0106341,(%esp)
f0101540:	e8 92 ef ff ff       	call   f01004d7 <cprintf>
f0101545:	e9 7b fe ff ff       	jmp    f01013c5 <shell+0x42>

      if (runcmd(buf) < 0)
        break;
    }
  }
}
f010154a:	83 c4 5c             	add    $0x5c,%esp
f010154d:	5b                   	pop    %ebx
f010154e:	5e                   	pop    %esi
f010154f:	5f                   	pop    %edi
f0101550:	5d                   	pop    %ebp
f0101551:	c3                   	ret    
	...

f0101554 <user_entry>:
#include <inc/stdio.h>
#include <inc/syscall.h>
#include <inc/shell.h>

int user_entry()
{
f0101554:	83 ec 1c             	sub    $0x1c,%esp

	asm volatile("movl %0,%%eax\n\t" \
f0101557:	b8 23 00 00 00       	mov    $0x23,%eax
f010155c:	8e d8                	mov    %eax,%ds
f010155e:	8e c0                	mov    %eax,%es
f0101560:	8e e0                	mov    %eax,%fs
f0101562:	8e e8                	mov    %eax,%gs
    "movw %%ax,%%fs\n\t" \
    "movw %%ax,%%gs" \
    :: "i" (0x20 | 0x03)
  );

  cprintf("Welcome to User Land, cheers!\n");
f0101564:	c7 04 24 58 64 10 f0 	movl   $0xf0106458,(%esp)
f010156b:	e8 67 ef ff ff       	call   f01004d7 <cprintf>
  shell();
f0101570:	e8 0e fe ff ff       	call   f0101383 <shell>
f0101575:	eb fe                	jmp    f0101575 <user_entry+0x21>

f0101577 <idle_entry>:
}

int idle_entry()
{

	asm volatile("movl %0,%%eax\n\t" \
f0101577:	b8 23 00 00 00       	mov    $0x23,%eax
f010157c:	8e d8                	mov    %eax,%ds
f010157e:	8e c0                	mov    %eax,%es
f0101580:	8e e0                	mov    %eax,%fs
f0101582:	8e e8                	mov    %eax,%gs
f0101584:	eb fe                	jmp    f0101584 <idle_entry+0xd>
	...

f0101590 <__udivdi3>:
f0101590:	55                   	push   %ebp
f0101591:	89 e5                	mov    %esp,%ebp
f0101593:	57                   	push   %edi
f0101594:	56                   	push   %esi
f0101595:	8d 64 24 e0          	lea    -0x20(%esp),%esp
f0101599:	8b 45 14             	mov    0x14(%ebp),%eax
f010159c:	8b 75 08             	mov    0x8(%ebp),%esi
f010159f:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01015a2:	85 c0                	test   %eax,%eax
f01015a4:	89 75 e8             	mov    %esi,-0x18(%ebp)
f01015a7:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01015aa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01015ad:	75 39                	jne    f01015e8 <__udivdi3+0x58>
f01015af:	39 f9                	cmp    %edi,%ecx
f01015b1:	77 65                	ja     f0101618 <__udivdi3+0x88>
f01015b3:	85 c9                	test   %ecx,%ecx
f01015b5:	75 0b                	jne    f01015c2 <__udivdi3+0x32>
f01015b7:	b8 01 00 00 00       	mov    $0x1,%eax
f01015bc:	31 d2                	xor    %edx,%edx
f01015be:	f7 f1                	div    %ecx
f01015c0:	89 c1                	mov    %eax,%ecx
f01015c2:	89 f8                	mov    %edi,%eax
f01015c4:	31 d2                	xor    %edx,%edx
f01015c6:	f7 f1                	div    %ecx
f01015c8:	89 c7                	mov    %eax,%edi
f01015ca:	89 f0                	mov    %esi,%eax
f01015cc:	f7 f1                	div    %ecx
f01015ce:	89 fa                	mov    %edi,%edx
f01015d0:	89 c6                	mov    %eax,%esi
f01015d2:	89 75 f0             	mov    %esi,-0x10(%ebp)
f01015d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
f01015d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01015db:	8b 55 f4             	mov    -0xc(%ebp),%edx
f01015de:	8d 64 24 20          	lea    0x20(%esp),%esp
f01015e2:	5e                   	pop    %esi
f01015e3:	5f                   	pop    %edi
f01015e4:	5d                   	pop    %ebp
f01015e5:	c3                   	ret    
f01015e6:	66 90                	xchg   %ax,%ax
f01015e8:	31 d2                	xor    %edx,%edx
f01015ea:	31 f6                	xor    %esi,%esi
f01015ec:	39 f8                	cmp    %edi,%eax
f01015ee:	77 e2                	ja     f01015d2 <__udivdi3+0x42>
f01015f0:	0f bd d0             	bsr    %eax,%edx
f01015f3:	83 f2 1f             	xor    $0x1f,%edx
f01015f6:	89 55 ec             	mov    %edx,-0x14(%ebp)
f01015f9:	75 2d                	jne    f0101628 <__udivdi3+0x98>
f01015fb:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f01015fe:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
f0101601:	76 06                	jbe    f0101609 <__udivdi3+0x79>
f0101603:	39 f8                	cmp    %edi,%eax
f0101605:	89 f2                	mov    %esi,%edx
f0101607:	73 c9                	jae    f01015d2 <__udivdi3+0x42>
f0101609:	31 d2                	xor    %edx,%edx
f010160b:	be 01 00 00 00       	mov    $0x1,%esi
f0101610:	eb c0                	jmp    f01015d2 <__udivdi3+0x42>
f0101612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0101618:	89 f0                	mov    %esi,%eax
f010161a:	89 fa                	mov    %edi,%edx
f010161c:	f7 f1                	div    %ecx
f010161e:	31 d2                	xor    %edx,%edx
f0101620:	89 c6                	mov    %eax,%esi
f0101622:	eb ae                	jmp    f01015d2 <__udivdi3+0x42>
f0101624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101628:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f010162c:	89 c2                	mov    %eax,%edx
f010162e:	b8 20 00 00 00       	mov    $0x20,%eax
f0101633:	2b 45 ec             	sub    -0x14(%ebp),%eax
f0101636:	d3 e2                	shl    %cl,%edx
f0101638:	89 c1                	mov    %eax,%ecx
f010163a:	8b 75 f0             	mov    -0x10(%ebp),%esi
f010163d:	d3 ee                	shr    %cl,%esi
f010163f:	09 d6                	or     %edx,%esi
f0101641:	89 fa                	mov    %edi,%edx
f0101643:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101647:	89 75 e4             	mov    %esi,-0x1c(%ebp)
f010164a:	8b 75 f0             	mov    -0x10(%ebp),%esi
f010164d:	d3 e6                	shl    %cl,%esi
f010164f:	89 c1                	mov    %eax,%ecx
f0101651:	89 75 f0             	mov    %esi,-0x10(%ebp)
f0101654:	8b 75 e8             	mov    -0x18(%ebp),%esi
f0101657:	d3 ea                	shr    %cl,%edx
f0101659:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f010165d:	d3 e7                	shl    %cl,%edi
f010165f:	89 c1                	mov    %eax,%ecx
f0101661:	d3 ee                	shr    %cl,%esi
f0101663:	09 fe                	or     %edi,%esi
f0101665:	89 f0                	mov    %esi,%eax
f0101667:	f7 75 e4             	divl   -0x1c(%ebp)
f010166a:	89 d7                	mov    %edx,%edi
f010166c:	89 c6                	mov    %eax,%esi
f010166e:	f7 65 f0             	mull   -0x10(%ebp)
f0101671:	39 d7                	cmp    %edx,%edi
f0101673:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0101676:	72 12                	jb     f010168a <__udivdi3+0xfa>
f0101678:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f010167c:	8b 55 e8             	mov    -0x18(%ebp),%edx
f010167f:	d3 e2                	shl    %cl,%edx
f0101681:	39 c2                	cmp    %eax,%edx
f0101683:	73 08                	jae    f010168d <__udivdi3+0xfd>
f0101685:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
f0101688:	75 03                	jne    f010168d <__udivdi3+0xfd>
f010168a:	8d 76 ff             	lea    -0x1(%esi),%esi
f010168d:	31 d2                	xor    %edx,%edx
f010168f:	e9 3e ff ff ff       	jmp    f01015d2 <__udivdi3+0x42>
f0101694:	47                   	inc    %edi
f0101695:	43                   	inc    %ebx
f0101696:	43                   	inc    %ebx
f0101697:	3a 20                	cmp    (%eax),%ah
f0101699:	28 47 4e             	sub    %al,0x4e(%edi)
f010169c:	55                   	push   %ebp
f010169d:	29 20                	sub    %esp,(%eax)
f010169f:	34 2e                	xor    $0x2e,%al
f01016a1:	35 2e 31 20 32       	xor    $0x3220312e,%eax
f01016a6:	30 31                	xor    %dh,(%ecx)
f01016a8:	30 30                	xor    %dh,(%eax)
f01016aa:	39 32                	cmp    %esi,(%edx)
f01016ac:	34 20                	xor    $0x20,%al
f01016ae:	28 52 65             	sub    %dl,0x65(%edx)
f01016b1:	64 20 48 61          	and    %cl,%fs:0x61(%eax)
f01016b5:	74 20                	je     f01016d7 <__udivdi3+0x147>
f01016b7:	34 2e                	xor    $0x2e,%al
f01016b9:	35 2e 31 2d 34       	xor    $0x342d312e,%eax
f01016be:	29 00                	sub    %eax,(%eax)
f01016c0:	14 00                	adc    $0x0,%al
f01016c2:	00 00                	add    %al,(%eax)
f01016c4:	00 00                	add    %al,(%eax)
f01016c6:	00 00                	add    %al,(%eax)
f01016c8:	01 7a 52             	add    %edi,0x52(%edx)
f01016cb:	00 01                	add    %al,(%ecx)
f01016cd:	7c 08                	jl     f01016d7 <__udivdi3+0x147>
f01016cf:	01 1b                	add    %ebx,(%ebx)
f01016d1:	0c 04                	or     $0x4,%al
f01016d3:	04 88                	add    $0x88,%al
f01016d5:	01 00                	add    %eax,(%eax)
f01016d7:	00 28                	add    %ch,(%eax)
f01016d9:	00 00                	add    %al,(%eax)
f01016db:	00 1c 00             	add    %bl,(%eax,%eax,1)
f01016de:	00 00                	add    %al,(%eax)
f01016e0:	b0 fe                	mov    $0xfe,%al
f01016e2:	ff                   	(bad)  
f01016e3:	ff 04 01             	incl   (%ecx,%eax,1)
f01016e6:	00 00                	add    %al,(%eax)
f01016e8:	00 41 0e             	add    %al,0xe(%ecx)
f01016eb:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
f01016f1:	4c                   	dec    %esp
f01016f2:	86 04 87             	xchg   %al,(%edi,%eax,4)
f01016f5:	03 02                	add    (%edx),%eax
f01016f7:	44                   	inc    %esp
f01016f8:	0a c6                	or     %dh,%al
f01016fa:	41                   	inc    %ecx
f01016fb:	c7 41 c5 0c 04 04 43 	movl   $0x4304040c,-0x3b(%ecx)
f0101702:	0b 00                	or     (%eax),%eax
	...

f0101710 <__umoddi3>:
f0101710:	55                   	push   %ebp
f0101711:	89 e5                	mov    %esp,%ebp
f0101713:	57                   	push   %edi
f0101714:	56                   	push   %esi
f0101715:	8d 64 24 e0          	lea    -0x20(%esp),%esp
f0101719:	8b 7d 14             	mov    0x14(%ebp),%edi
f010171c:	8b 45 08             	mov    0x8(%ebp),%eax
f010171f:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0101722:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101725:	85 ff                	test   %edi,%edi
f0101727:	89 45 e8             	mov    %eax,-0x18(%ebp)
f010172a:	89 4d f4             	mov    %ecx,-0xc(%ebp)
f010172d:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0101730:	89 f2                	mov    %esi,%edx
f0101732:	75 14                	jne    f0101748 <__umoddi3+0x38>
f0101734:	39 f1                	cmp    %esi,%ecx
f0101736:	76 40                	jbe    f0101778 <__umoddi3+0x68>
f0101738:	f7 f1                	div    %ecx
f010173a:	89 d0                	mov    %edx,%eax
f010173c:	31 d2                	xor    %edx,%edx
f010173e:	8d 64 24 20          	lea    0x20(%esp),%esp
f0101742:	5e                   	pop    %esi
f0101743:	5f                   	pop    %edi
f0101744:	5d                   	pop    %ebp
f0101745:	c3                   	ret    
f0101746:	66 90                	xchg   %ax,%ax
f0101748:	39 f7                	cmp    %esi,%edi
f010174a:	77 4c                	ja     f0101798 <__umoddi3+0x88>
f010174c:	0f bd c7             	bsr    %edi,%eax
f010174f:	83 f0 1f             	xor    $0x1f,%eax
f0101752:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0101755:	75 51                	jne    f01017a8 <__umoddi3+0x98>
f0101757:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
f010175a:	0f 87 e8 00 00 00    	ja     f0101848 <__umoddi3+0x138>
f0101760:	89 f2                	mov    %esi,%edx
f0101762:	8b 75 f0             	mov    -0x10(%ebp),%esi
f0101765:	29 ce                	sub    %ecx,%esi
f0101767:	19 fa                	sbb    %edi,%edx
f0101769:	89 75 f0             	mov    %esi,-0x10(%ebp)
f010176c:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010176f:	8d 64 24 20          	lea    0x20(%esp),%esp
f0101773:	5e                   	pop    %esi
f0101774:	5f                   	pop    %edi
f0101775:	5d                   	pop    %ebp
f0101776:	c3                   	ret    
f0101777:	90                   	nop
f0101778:	85 c9                	test   %ecx,%ecx
f010177a:	75 0b                	jne    f0101787 <__umoddi3+0x77>
f010177c:	b8 01 00 00 00       	mov    $0x1,%eax
f0101781:	31 d2                	xor    %edx,%edx
f0101783:	f7 f1                	div    %ecx
f0101785:	89 c1                	mov    %eax,%ecx
f0101787:	89 f0                	mov    %esi,%eax
f0101789:	31 d2                	xor    %edx,%edx
f010178b:	f7 f1                	div    %ecx
f010178d:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0101790:	f7 f1                	div    %ecx
f0101792:	eb a6                	jmp    f010173a <__umoddi3+0x2a>
f0101794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101798:	89 f2                	mov    %esi,%edx
f010179a:	8d 64 24 20          	lea    0x20(%esp),%esp
f010179e:	5e                   	pop    %esi
f010179f:	5f                   	pop    %edi
f01017a0:	5d                   	pop    %ebp
f01017a1:	c3                   	ret    
f01017a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01017a8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f01017ac:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
f01017b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
f01017b6:	29 45 f0             	sub    %eax,-0x10(%ebp)
f01017b9:	d3 e7                	shl    %cl,%edi
f01017bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01017be:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f01017c2:	89 f2                	mov    %esi,%edx
f01017c4:	d3 e8                	shr    %cl,%eax
f01017c6:	09 f8                	or     %edi,%eax
f01017c8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f01017cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01017cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01017d2:	d3 e0                	shl    %cl,%eax
f01017d4:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f01017d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
f01017db:	8b 45 e8             	mov    -0x18(%ebp),%eax
f01017de:	d3 ea                	shr    %cl,%edx
f01017e0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f01017e4:	d3 e6                	shl    %cl,%esi
f01017e6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f01017ea:	d3 e8                	shr    %cl,%eax
f01017ec:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f01017f0:	09 f0                	or     %esi,%eax
f01017f2:	8b 75 e8             	mov    -0x18(%ebp),%esi
f01017f5:	d3 e6                	shl    %cl,%esi
f01017f7:	f7 75 e4             	divl   -0x1c(%ebp)
f01017fa:	89 75 e8             	mov    %esi,-0x18(%ebp)
f01017fd:	89 d6                	mov    %edx,%esi
f01017ff:	f7 65 f4             	mull   -0xc(%ebp)
f0101802:	89 d7                	mov    %edx,%edi
f0101804:	89 c2                	mov    %eax,%edx
f0101806:	39 fe                	cmp    %edi,%esi
f0101808:	89 f9                	mov    %edi,%ecx
f010180a:	72 30                	jb     f010183c <__umoddi3+0x12c>
f010180c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
f010180f:	72 27                	jb     f0101838 <__umoddi3+0x128>
f0101811:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0101814:	29 d0                	sub    %edx,%eax
f0101816:	19 ce                	sbb    %ecx,%esi
f0101818:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f010181c:	89 f2                	mov    %esi,%edx
f010181e:	d3 e8                	shr    %cl,%eax
f0101820:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101824:	d3 e2                	shl    %cl,%edx
f0101826:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f010182a:	09 d0                	or     %edx,%eax
f010182c:	89 f2                	mov    %esi,%edx
f010182e:	d3 ea                	shr    %cl,%edx
f0101830:	8d 64 24 20          	lea    0x20(%esp),%esp
f0101834:	5e                   	pop    %esi
f0101835:	5f                   	pop    %edi
f0101836:	5d                   	pop    %ebp
f0101837:	c3                   	ret    
f0101838:	39 fe                	cmp    %edi,%esi
f010183a:	75 d5                	jne    f0101811 <__umoddi3+0x101>
f010183c:	89 f9                	mov    %edi,%ecx
f010183e:	89 c2                	mov    %eax,%edx
f0101840:	2b 55 f4             	sub    -0xc(%ebp),%edx
f0101843:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f0101846:	eb c9                	jmp    f0101811 <__umoddi3+0x101>
f0101848:	39 f7                	cmp    %esi,%edi
f010184a:	0f 82 10 ff ff ff    	jb     f0101760 <__umoddi3+0x50>
f0101850:	e9 17 ff ff ff       	jmp    f010176c <__umoddi3+0x5c>
f0101855:	00 00                	add    %al,(%eax)
f0101857:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
f010185b:	00 9c 01 00 00 b0 fe 	add    %bl,-0x1500000(%ecx,%eax,1)
f0101862:	ff                   	(bad)  
f0101863:	ff 45 01             	incl   0x1(%ebp)
f0101866:	00 00                	add    %al,(%eax)
f0101868:	00 41 0e             	add    %al,0xe(%ecx)
f010186b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
f0101871:	49                   	dec    %ecx
f0101872:	86 04 87             	xchg   %al,(%edi,%eax,4)
f0101875:	03 67 0a             	add    0xa(%edi),%esp
f0101878:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
f010187c:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
f010187f:	04 43                	add    $0x43,%al
f0101881:	0b 6c 0a c6          	or     -0x3a(%edx,%ecx,1),%ebp
f0101885:	41                   	inc    %ecx
f0101886:	c7 41 0c 04 04 c5 42 	movl   $0x42c50404,0xc(%ecx)
f010188d:	0b 67 0a             	or     0xa(%edi),%esp
f0101890:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
f0101894:	0c 04                	or     $0x4,%al
f0101896:	04 c5                	add    $0xc5,%al
f0101898:	47                   	inc    %edi
f0101899:	0b 02                	or     (%edx),%eax
f010189b:	8d 0a                	lea    (%edx),%ecx
f010189d:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
f01018a1:	0c 04                	or     $0x4,%al
f01018a3:	04 c5                	add    $0xc5,%al
f01018a5:	41                   	inc    %ecx
f01018a6:	0b 00                	or     (%eax),%eax

f01018a8 <UTEXT_end>:
.global entry
_start = RELOC(entry)

.text
entry:
	movw	$0x1234,0x472			# warm boot
f01018a8:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f01018af:	34 12 
	# KERNBASE+1MB.  Hence, we set up a trivial page directory that
	# translates virtual addresses [KERNBASE, KERNBASE+4MB) to
	# physical addresses [0, 4MB).  This 4MB region will be
	# sufficient until we set up our real page table in mem_init.

    movl $0, %eax
f01018b1:	b8 00 00 00 00       	mov    $0x0,%eax
    movl $(RELOC(bss_start)), %edi
f01018b6:	bf 74 b0 10 00       	mov    $0x10b074,%edi
    movl $(RELOC(end)), %ecx
f01018bb:	b9 00 a0 15 00       	mov    $0x15a000,%ecx
    subl %edi, %ecx
f01018c0:	29 f9                	sub    %edi,%ecx
    cld
f01018c2:	fc                   	cld    
    rep stosb
f01018c3:	f3 aa                	rep stos %al,%es:(%edi)

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f01018c5:	b8 00 90 10 00       	mov    $0x109000,%eax
	movl	%eax, %cr3
f01018ca:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f01018cd:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f01018d0:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f01018d5:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f01018d8:	b8 df 18 10 f0       	mov    $0xf01018df,%eax
	jmp	*%eax
f01018dd:	ff e0                	jmp    *%eax

f01018df <relocated>:

relocated:

  # Setup new gdt
  lgdt    kgdtdesc
f01018df:	0f 01 15 10 19 10 f0 	lgdtl  0xf0101910

	# Setup kernel stack
	movl $0, %ebp
f01018e6:	bd 00 00 00 00       	mov    $0x0,%ebp
	movl $(bootstacktop), %esp
f01018eb:	bc 00 50 11 f0       	mov    $0xf0115000,%esp

	call kernel_main
f01018f0:	e8 23 00 00 00       	call   f0101918 <kernel_main>

f01018f5 <die>:
die:
	jmp die
f01018f5:	eb fe                	jmp    f01018f5 <die>
f01018f7:	90                   	nop

f01018f8 <kgdt>:
	...
f0101900:	ff                   	(bad)  
f0101901:	ff 00                	incl   (%eax)
f0101903:	00 00                	add    %al,(%eax)
f0101905:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f010190c:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

f0101910 <kgdtdesc>:
f0101910:	17                   	pop    %ss
f0101911:	00 f8                	add    %bh,%al
f0101913:	18 10                	sbb    %dl,(%eax)
f0101915:	f0 00 00             	lock add %al,(%eax)

f0101918 <kernel_main>:
extern void init_video(void);
static void boot_aps(void);
extern Task *cur_task;

void kernel_main(void)
{
f0101918:	83 ec 0c             	sub    $0xc,%esp
	extern char stext[];
	extern char etext[], end[], data_start[],rdata_end[];
	extern void task_job();

	init_video();
f010191b:	e8 65 05 00 00       	call   f0101e85 <init_video>
  	mem_init();
f0101920:	e8 ed 10 00 00       	call   f0102a12 <mem_init>
	mp_init();
f0101925:	e8 89 35 00 00       	call   f0104eb3 <mp_init>
	lapic_init();
f010192a:	e8 5b 32 00 00       	call   f0104b8a <lapic_init>
  	task_init();
f010192f:	e8 ad 2e 00 00       	call   f01047e1 <task_init>
	trap_init();
f0101934:	e8 86 08 00 00       	call   f01021bf <trap_init>
	pic_init();
f0101939:	e8 56 01 00 00       	call   f0101a94 <pic_init>
	kbd_init();
f010193e:	e8 f9 02 00 00       	call   f0101c3c <kbd_init>
  	timer_init();
f0101943:	e8 41 2a 00 00       	call   f0104389 <timer_init>
  	syscall_init();
f0101948:	e8 15 30 00 00       	call   f0104962 <syscall_init>
	boot_aps();

  printk("Kernel code base start=0x%08x to = 0x%08x\n", stext, etext);
f010194d:	50                   	push   %eax
f010194e:	68 f0 50 10 f0       	push   $0xf01050f0
f0101953:	68 00 00 10 f0       	push   $0xf0100000
f0101958:	68 78 64 10 f0       	push   $0xf0106478
f010195d:	e8 c6 09 00 00       	call   f0102328 <printk>
  printk("Readonly data start=0x%08x to = 0x%08x\n", etext, rdata_end);
f0101962:	83 c4 0c             	add    $0xc,%esp
f0101965:	68 fa 79 10 f0       	push   $0xf01079fa
f010196a:	68 f0 50 10 f0       	push   $0xf01050f0
f010196f:	68 a3 64 10 f0       	push   $0xf01064a3
f0101974:	e8 af 09 00 00       	call   f0102328 <printk>
  printk("Kernel data base start=0x%08x to = 0x%08x\n", data_start, end);
f0101979:	83 c4 0c             	add    $0xc,%esp
f010197c:	68 00 a0 15 f0       	push   $0xf015a000
f0101981:	68 00 80 10 f0       	push   $0xf0108000
f0101986:	68 cb 64 10 f0       	push   $0xf01064cb
f010198b:	e8 98 09 00 00       	call   f0102328 <printk>


  /* Enable interrupt */
  __asm __volatile("sti");
f0101990:	fb                   	sti    

  lcr3(PADDR(cur_task->pgdir));
f0101991:	8b 15 2c 5e 11 f0    	mov    0xf0115e2c,%edx
/* -------------- Inline Functions --------------  */

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0101997:	83 c4 10             	add    $0x10,%esp
f010199a:	8b 42 54             	mov    0x54(%edx),%eax
f010199d:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01019a2:	77 12                	ja     f01019b6 <kernel_main+0x9e>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01019a4:	50                   	push   %eax
f01019a5:	68 f6 64 10 f0       	push   $0xf01064f6
f01019aa:	6a 2b                	push   $0x2b
f01019ac:	68 1a 65 10 f0       	push   $0xf010651a
f01019b1:	e8 9e 28 00 00       	call   f0104254 <_panic>
	return (physaddr_t)kva - KERNBASE;
f01019b6:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f01019bb:	0f 22 d8             	mov    %eax,%cr3
  /* Move to user mode */
  asm volatile("movl %0,%%eax\n\t" \
f01019be:	8b 42 44             	mov    0x44(%edx),%eax
f01019c1:	6a 23                	push   $0x23
f01019c3:	50                   	push   %eax
f01019c4:	9c                   	pushf  
f01019c5:	6a 1b                	push   $0x1b
f01019c7:	ff 72 38             	pushl  0x38(%edx)
f01019ca:	cf                   	iret   
  "pushl %2\n\t" \
  "pushl %3\n\t" \
  "iret\n" \
  :: "m" (cur_task->tf.tf_esp), "i" (GD_UD | 0x03), "i" (GD_UT | 0x03), "m" (cur_task->tf.tf_eip)
  :"ax");
}
f01019cb:	83 c4 0c             	add    $0xc,%esp
f01019ce:	c3                   	ret    

f01019cf <mp_main>:
}

// Setup code for APs
void
mp_main(void)
{
f01019cf:	53                   	push   %ebx
f01019d0:	83 ec 08             	sub    $0x8,%esp
	 * 6. init per-CPU system registers
	 *       
	 */
	
	// We are in high EIP now, safe to switch to kern_pgdir 
	lcr3(PADDR(kern_pgdir));
f01019d3:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
/* -------------- Inline Functions --------------  */

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01019d8:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01019dd:	77 0d                	ja     f01019ec <mp_main+0x1d>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01019df:	50                   	push   %eax
f01019e0:	68 f6 64 10 f0       	push   $0xf01064f6
f01019e5:	68 94 00 00 00       	push   $0x94
f01019ea:	eb 41                	jmp    f0101a2d <mp_main+0x5e>
	return (physaddr_t)kva - KERNBASE;
f01019ec:	05 00 00 00 10       	add    $0x10000000,%eax
f01019f1:	0f 22 d8             	mov    %eax,%cr3
	printk("SMP: CPU %d starting\n", cpunum());
f01019f4:	e8 7e 31 00 00       	call   f0104b77 <cpunum>
f01019f9:	52                   	push   %edx
f01019fa:	52                   	push   %edx
f01019fb:	50                   	push   %eax
f01019fc:	68 28 65 10 f0       	push   $0xf0106528
f0101a01:	e8 22 09 00 00       	call   f0102328 <printk>
	// Your code here:



	/* Enable interrupt */
	__asm __volatile("sti");
f0101a06:	fb                   	sti    

	lcr3(PADDR(thiscpu->cpu_task->pgdir));
f0101a07:	e8 6b 31 00 00       	call   f0104b77 <cpunum>
/* -------------- Inline Functions --------------  */

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0101a0c:	83 c4 10             	add    $0x10,%esp
f0101a0f:	6b c0 74             	imul   $0x74,%eax,%eax
f0101a12:	8b 80 0c 90 11 f0    	mov    -0xfee6ff4(%eax),%eax
f0101a18:	8b 40 54             	mov    0x54(%eax),%eax
f0101a1b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101a20:	77 15                	ja     f0101a37 <mp_main+0x68>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101a22:	50                   	push   %eax
f0101a23:	68 f6 64 10 f0       	push   $0xf01064f6
f0101a28:	68 a4 00 00 00       	push   $0xa4
f0101a2d:	68 1a 65 10 f0       	push   $0xf010651a
f0101a32:	e8 1d 28 00 00       	call   f0104254 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0101a37:	05 00 00 00 10       	add    $0x10000000,%eax
f0101a3c:	0f 22 d8             	mov    %eax,%cr3
			"pushl %%eax\n\t" \
			"pushfl\n\t" \
			"pushl %2\n\t" \
			"pushl %3\n\t" \
			"iret\n" \
			:: "m" (thiscpu->cpu_task->tf.tf_esp), "i" (GD_UD | 0x03), "i" (GD_UT | 0x03), "m" (thiscpu->cpu_task->tf.tf_eip)
f0101a3f:	e8 33 31 00 00       	call   f0104b77 <cpunum>
f0101a44:	6b c0 74             	imul   $0x74,%eax,%eax
f0101a47:	8b 98 0c 90 11 f0    	mov    -0xfee6ff4(%eax),%ebx
f0101a4d:	e8 25 31 00 00       	call   f0104b77 <cpunum>
f0101a52:	6b c0 74             	imul   $0x74,%eax,%eax
f0101a55:	8b 90 0c 90 11 f0    	mov    -0xfee6ff4(%eax),%edx
	__asm __volatile("sti");

	lcr3(PADDR(thiscpu->cpu_task->pgdir));

	/* Move to user mode */
	asm volatile("movl %0,%%eax\n\t" \
f0101a5b:	8b 43 44             	mov    0x44(%ebx),%eax
f0101a5e:	6a 23                	push   $0x23
f0101a60:	50                   	push   %eax
f0101a61:	9c                   	pushf  
f0101a62:	6a 1b                	push   $0x1b
f0101a64:	ff 72 38             	pushl  0x38(%edx)
f0101a67:	cf                   	iret   
			"pushl %3\n\t" \
			"iret\n" \
			:: "m" (thiscpu->cpu_task->tf.tf_esp), "i" (GD_UD | 0x03), "i" (GD_UT | 0x03), "m" (thiscpu->cpu_task->tf.tf_eip)
			:"ax");

}
f0101a68:	83 c4 08             	add    $0x8,%esp
f0101a6b:	5b                   	pop    %ebx
f0101a6c:	c3                   	ret    
f0101a6d:	00 00                	add    %al,(%eax)
	...

f0101a70 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0101a70:	8b 54 24 04          	mov    0x4(%esp),%edx
	irq_mask_8259A = mask;
	if (!didinit)
f0101a74:	80 3d 00 50 11 f0 00 	cmpb   $0x0,0xf0115000
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0101a7b:	89 d0                	mov    %edx,%eax
	irq_mask_8259A = mask;
f0101a7d:	66 89 15 48 80 10 f0 	mov    %dx,0xf0108048
	if (!didinit)
f0101a84:	74 0d                	je     f0101a93 <irq_setmask_8259A+0x23>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0101a86:	ba 21 00 00 00       	mov    $0x21,%edx
f0101a8b:	ee                   	out    %al,(%dx)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
f0101a8c:	66 c1 e8 08          	shr    $0x8,%ax
f0101a90:	b2 a1                	mov    $0xa1,%dl
f0101a92:	ee                   	out    %al,(%dx)
f0101a93:	c3                   	ret    

f0101a94 <pic_init>:
static bool didinit;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
f0101a94:	57                   	push   %edi
f0101a95:	b9 21 00 00 00       	mov    $0x21,%ecx
f0101a9a:	56                   	push   %esi
f0101a9b:	b0 ff                	mov    $0xff,%al
f0101a9d:	53                   	push   %ebx
f0101a9e:	89 ca                	mov    %ecx,%edx
f0101aa0:	ee                   	out    %al,(%dx)
f0101aa1:	be a1 00 00 00       	mov    $0xa1,%esi
f0101aa6:	89 f2                	mov    %esi,%edx
f0101aa8:	ee                   	out    %al,(%dx)
f0101aa9:	bf 11 00 00 00       	mov    $0x11,%edi
f0101aae:	bb 20 00 00 00       	mov    $0x20,%ebx
f0101ab3:	89 f8                	mov    %edi,%eax
f0101ab5:	89 da                	mov    %ebx,%edx
f0101ab7:	ee                   	out    %al,(%dx)
f0101ab8:	b0 20                	mov    $0x20,%al
f0101aba:	89 ca                	mov    %ecx,%edx
f0101abc:	ee                   	out    %al,(%dx)
f0101abd:	b0 04                	mov    $0x4,%al
f0101abf:	ee                   	out    %al,(%dx)
f0101ac0:	b0 03                	mov    $0x3,%al
f0101ac2:	ee                   	out    %al,(%dx)
f0101ac3:	b1 a0                	mov    $0xa0,%cl
f0101ac5:	89 f8                	mov    %edi,%eax
f0101ac7:	89 ca                	mov    %ecx,%edx
f0101ac9:	ee                   	out    %al,(%dx)
f0101aca:	b0 28                	mov    $0x28,%al
f0101acc:	89 f2                	mov    %esi,%edx
f0101ace:	ee                   	out    %al,(%dx)
f0101acf:	b0 02                	mov    $0x2,%al
f0101ad1:	ee                   	out    %al,(%dx)
f0101ad2:	b0 01                	mov    $0x1,%al
f0101ad4:	ee                   	out    %al,(%dx)
f0101ad5:	bf 68 00 00 00       	mov    $0x68,%edi
f0101ada:	89 da                	mov    %ebx,%edx
f0101adc:	89 f8                	mov    %edi,%eax
f0101ade:	ee                   	out    %al,(%dx)
f0101adf:	be 0a 00 00 00       	mov    $0xa,%esi
f0101ae4:	89 f0                	mov    %esi,%eax
f0101ae6:	ee                   	out    %al,(%dx)
f0101ae7:	89 f8                	mov    %edi,%eax
f0101ae9:	89 ca                	mov    %ecx,%edx
f0101aeb:	ee                   	out    %al,(%dx)
f0101aec:	89 f0                	mov    %esi,%eax
f0101aee:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
f0101aef:	66 a1 48 80 10 f0    	mov    0xf0108048,%ax

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
	didinit = 1;
f0101af5:	c6 05 00 50 11 f0 01 	movb   $0x1,0xf0115000
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
f0101afc:	66 83 f8 ff          	cmp    $0xffffffff,%ax
f0101b00:	74 0a                	je     f0101b0c <pic_init+0x78>
		irq_setmask_8259A(irq_mask_8259A);
f0101b02:	0f b7 c0             	movzwl %ax,%eax
f0101b05:	50                   	push   %eax
f0101b06:	e8 65 ff ff ff       	call   f0101a70 <irq_setmask_8259A>
f0101b0b:	58                   	pop    %eax
}
f0101b0c:	5b                   	pop    %ebx
f0101b0d:	5e                   	pop    %esi
f0101b0e:	5f                   	pop    %edi
f0101b0f:	c3                   	ret    

f0101b10 <kbd_proc_data>:
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
f0101b10:	53                   	push   %ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0101b11:	ba 64 00 00 00       	mov    $0x64,%edx
f0101b16:	83 ec 08             	sub    $0x8,%esp
f0101b19:	ec                   	in     (%dx),%al
  int c;
  uint8_t data;
  static uint32_t shift;

  if ((inb(KBSTATP) & KBS_DIB) == 0)
    return -1;
f0101b1a:	83 c9 ff             	or     $0xffffffff,%ecx
{
  int c;
  uint8_t data;
  static uint32_t shift;

  if ((inb(KBSTATP) & KBS_DIB) == 0)
f0101b1d:	a8 01                	test   $0x1,%al
f0101b1f:	0f 84 ae 00 00 00    	je     f0101bd3 <kbd_proc_data+0xc3>
f0101b25:	b2 60                	mov    $0x60,%dl
f0101b27:	ec                   	in     (%dx),%al
    return -1;

  data = inb(KBDATAP);

  if (data == 0xE0) {
f0101b28:	3c e0                	cmp    $0xe0,%al
f0101b2a:	88 c1                	mov    %al,%cl
f0101b2c:	75 12                	jne    f0101b40 <kbd_proc_data+0x30>
f0101b2e:	ec                   	in     (%dx),%al
    data = inb(KBDATAP);
    if (data & 0x80)
      return 0;
f0101b2f:	31 c9                	xor    %ecx,%ecx

  data = inb(KBDATAP);

  if (data == 0xE0) {
    data = inb(KBDATAP);
    if (data & 0x80)
f0101b31:	84 c0                	test   %al,%al
f0101b33:	0f 88 9a 00 00 00    	js     f0101bd3 <kbd_proc_data+0xc3>
      return 0;
    else
      data |= 0x80;
f0101b39:	88 c1                	mov    %al,%cl
f0101b3b:	83 c9 80             	or     $0xffffff80,%ecx
f0101b3e:	eb 1a                	jmp    f0101b5a <kbd_proc_data+0x4a>
  } else if (data & 0x80) {
f0101b40:	84 c0                	test   %al,%al
f0101b42:	79 16                	jns    f0101b5a <kbd_proc_data+0x4a>
    // Key released
    data &= 0x7F;
    shift &= ~(shiftcode[data]);
f0101b44:	83 e0 7f             	and    $0x7f,%eax
    return 0;
f0101b47:	31 c9                	xor    %ecx,%ecx
    else
      data |= 0x80;
  } else if (data & 0x80) {
    // Key released
    data &= 0x7F;
    shift &= ~(shiftcode[data]);
f0101b49:	0f b6 80 4c 65 10 f0 	movzbl -0xfef9ab4(%eax),%eax
f0101b50:	f7 d0                	not    %eax
f0101b52:	21 05 0c 52 11 f0    	and    %eax,0xf011520c
    return 0;
f0101b58:	eb 79                	jmp    f0101bd3 <kbd_proc_data+0xc3>
  }

  shift |= shiftcode[data];
f0101b5a:	0f b6 c1             	movzbl %cl,%eax
  shift ^= togglecode[data];
f0101b5d:	0f b6 90 4c 66 10 f0 	movzbl -0xfef99b4(%eax),%edx
    data &= 0x7F;
    shift &= ~(shiftcode[data]);
    return 0;
  }

  shift |= shiftcode[data];
f0101b64:	0f b6 98 4c 65 10 f0 	movzbl -0xfef9ab4(%eax),%ebx
f0101b6b:	0b 1d 0c 52 11 f0    	or     0xf011520c,%ebx
  shift ^= togglecode[data];
f0101b71:	31 d3                	xor    %edx,%ebx

  c = charcode[shift & (CTL | SHIFT)][data];
f0101b73:	89 da                	mov    %ebx,%edx
f0101b75:	83 e2 03             	and    $0x3,%edx
  if (shift & CAPSLOCK) {
f0101b78:	f6 c3 08             	test   $0x8,%bl
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];

  c = charcode[shift & (CTL | SHIFT)][data];
f0101b7b:	8b 14 95 4c 67 10 f0 	mov    -0xfef98b4(,%edx,4),%edx
    shift &= ~(shiftcode[data]);
    return 0;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
f0101b82:	89 1d 0c 52 11 f0    	mov    %ebx,0xf011520c

  c = charcode[shift & (CTL | SHIFT)][data];
f0101b88:	0f b6 0c 02          	movzbl (%edx,%eax,1),%ecx
  if (shift & CAPSLOCK) {
f0101b8c:	74 19                	je     f0101ba7 <kbd_proc_data+0x97>
    if ('a' <= c && c <= 'z')
f0101b8e:	8d 41 9f             	lea    -0x61(%ecx),%eax
f0101b91:	83 f8 19             	cmp    $0x19,%eax
f0101b94:	77 05                	ja     f0101b9b <kbd_proc_data+0x8b>
      c += 'A' - 'a';
f0101b96:	83 e9 20             	sub    $0x20,%ecx
f0101b99:	eb 0c                	jmp    f0101ba7 <kbd_proc_data+0x97>
    else if ('A' <= c && c <= 'Z')
f0101b9b:	8d 51 bf             	lea    -0x41(%ecx),%edx
      c += 'a' - 'A';
f0101b9e:	8d 41 20             	lea    0x20(%ecx),%eax
f0101ba1:	83 fa 19             	cmp    $0x19,%edx
f0101ba4:	0f 46 c8             	cmovbe %eax,%ecx
  }

  // Process special keys
  // Ctrl-Alt-Del: reboot
  if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0101ba7:	81 f9 e9 00 00 00    	cmp    $0xe9,%ecx
f0101bad:	75 24                	jne    f0101bd3 <kbd_proc_data+0xc3>
f0101baf:	f7 d3                	not    %ebx
f0101bb1:	80 e3 06             	and    $0x6,%bl
f0101bb4:	75 1d                	jne    f0101bd3 <kbd_proc_data+0xc3>
    printk("Rebooting!\n");
f0101bb6:	83 ec 0c             	sub    $0xc,%esp
f0101bb9:	68 3e 65 10 f0       	push   $0xf010653e
f0101bbe:	e8 65 07 00 00       	call   f0102328 <printk>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0101bc3:	ba 92 00 00 00       	mov    $0x92,%edx
f0101bc8:	b0 03                	mov    $0x3,%al
f0101bca:	ee                   	out    %al,(%dx)
f0101bcb:	b9 e9 00 00 00       	mov    $0xe9,%ecx
f0101bd0:	83 c4 10             	add    $0x10,%esp
    outb(0x92, 0x3); // courtesy of Chris Frost
  }

  return c;
}
f0101bd3:	89 c8                	mov    %ecx,%eax
f0101bd5:	83 c4 08             	add    $0x8,%esp
f0101bd8:	5b                   	pop    %ebx
f0101bd9:	c3                   	ret    

f0101bda <kbd_intr>:
/* 
 *  Note: The interrupt handler
 */
void
kbd_intr(struct Trapframe *tf)
{
f0101bda:	83 ec 0c             	sub    $0xc,%esp
f0101bdd:	eb 23                	jmp    f0101c02 <kbd_intr+0x28>
cons_intr(int (*proc)(void))
{
  int c;

  while ((c = (*proc)()) != -1) {
    if (c == 0)
f0101bdf:	85 c0                	test   %eax,%eax
f0101be1:	74 1f                	je     f0101c02 <kbd_intr+0x28>
      continue;

    cons.buf[cons.wpos++] = c;
f0101be3:	8b 15 08 52 11 f0    	mov    0xf0115208,%edx
f0101be9:	88 82 04 50 11 f0    	mov    %al,-0xfeeaffc(%edx)
f0101bef:	42                   	inc    %edx
    if (cons.wpos == CONSBUFSIZE)
      cons.wpos = 0;
f0101bf0:	31 c0                	xor    %eax,%eax
f0101bf2:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f0101bf8:	0f 45 c2             	cmovne %edx,%eax
f0101bfb:	a3 08 52 11 f0       	mov    %eax,0xf0115208
f0101c00:	eb 0a                	jmp    f0101c0c <kbd_intr+0x32>
  static void
cons_intr(int (*proc)(void))
{
  int c;

  while ((c = (*proc)()) != -1) {
f0101c02:	e8 09 ff ff ff       	call   f0101b10 <kbd_proc_data>
f0101c07:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101c0a:	75 d3                	jne    f0101bdf <kbd_intr+0x5>
 */
void
kbd_intr(struct Trapframe *tf)
{
  cons_intr(kbd_proc_data);
}
f0101c0c:	83 c4 0c             	add    $0xc,%esp
f0101c0f:	c3                   	ret    

f0101c10 <cons_getc>:
  // so that this function works even when interrupts are disabled
  // (e.g., when called from the kernel monitor).
  //kbd_intr();

  // grab the next character from the input buffer.
  if (cons.rpos != cons.wpos) {
f0101c10:	8b 15 04 52 11 f0    	mov    0xf0115204,%edx
    c = cons.buf[cons.rpos++];
    if (cons.rpos == CONSBUFSIZE)
      cons.rpos = 0;
    return c;
  }
  return 0;
f0101c16:	31 c0                	xor    %eax,%eax
  // so that this function works even when interrupts are disabled
  // (e.g., when called from the kernel monitor).
  //kbd_intr();

  // grab the next character from the input buffer.
  if (cons.rpos != cons.wpos) {
f0101c18:	3b 15 08 52 11 f0    	cmp    0xf0115208,%edx
f0101c1e:	74 1b                	je     f0101c3b <cons_getc+0x2b>
    c = cons.buf[cons.rpos++];
f0101c20:	8d 4a 01             	lea    0x1(%edx),%ecx
f0101c23:	0f b6 82 04 50 11 f0 	movzbl -0xfeeaffc(%edx),%eax
    if (cons.rpos == CONSBUFSIZE)
      cons.rpos = 0;
f0101c2a:	31 d2                	xor    %edx,%edx
f0101c2c:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f0101c32:	0f 45 d1             	cmovne %ecx,%edx
f0101c35:	89 15 04 52 11 f0    	mov    %edx,0xf0115204
    return c;
  }
  return 0;
}
f0101c3b:	c3                   	ret    

f0101c3c <kbd_init>:
{
  cons_intr(kbd_proc_data);
}

void kbd_init(void)
{
f0101c3c:	83 ec 18             	sub    $0x18,%esp
  // Drain the kbd buffer so that Bochs generates interrupts.
  kbd_intr(NULL);
f0101c3f:	6a 00                	push   $0x0
f0101c41:	e8 94 ff ff ff       	call   f0101bda <kbd_intr>
  irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f0101c46:	0f b7 05 48 80 10 f0 	movzwl 0xf0108048,%eax
f0101c4d:	25 fd ff 00 00       	and    $0xfffd,%eax
f0101c52:	89 04 24             	mov    %eax,(%esp)
f0101c55:	e8 16 fe ff ff       	call   f0101a70 <irq_setmask_8259A>
  /* Register trap handler */
  extern void KBD_Input();
  register_handler( IRQ_OFFSET + IRQ_KBD, &kbd_intr, &KBD_Input, 0, 0);
f0101c5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101c61:	6a 00                	push   $0x0
f0101c63:	68 8e 22 10 f0       	push   $0xf010228e
f0101c68:	68 da 1b 10 f0       	push   $0xf0101bda
f0101c6d:	6a 21                	push   $0x21
f0101c6f:	e8 29 04 00 00       	call   f010209d <register_handler>
}
f0101c74:	83 c4 2c             	add    $0x2c,%esp
f0101c77:	c3                   	ret    

f0101c78 <k_getc>:
int k_getc(void)
{
  // In lab4, our task is switched to user mode, so dont block at there
  //while ((c = cons_getc()) == 0)
  /* do nothing *///;
  return cons_getc();
f0101c78:	e9 93 ff ff ff       	jmp    f0101c10 <cons_getc>
f0101c7d:	00 00                	add    %al,(%eax)
	...

f0101c80 <scroll>:
int attrib = 0x0F;
int csr_x = 0, csr_y = 0;

/* Scrolls the screen */
void scroll(void)
{
f0101c80:	56                   	push   %esi
f0101c81:	53                   	push   %ebx
f0101c82:	83 ec 04             	sub    $0x4,%esp
    /* A blank is defined as a space... we need to give it
    *  backcolor too */
    blank = 0x0 | (attrib << 8);

    /* Row 25 is the end, this means we need to scroll up */
    if(csr_y >= 25)
f0101c85:	8b 1d 14 52 11 f0    	mov    0xf0115214,%ebx
{
    unsigned short blank, temp;

    /* A blank is defined as a space... we need to give it
    *  backcolor too */
    blank = 0x0 | (attrib << 8);
f0101c8b:	8b 35 4c 83 10 f0    	mov    0xf010834c,%esi

    /* Row 25 is the end, this means we need to scroll up */
    if(csr_y >= 25)
f0101c91:	83 fb 18             	cmp    $0x18,%ebx
f0101c94:	7e 5b                	jle    f0101cf1 <scroll+0x71>
    {
        /* Move the current text chunk that makes up the screen
        *  back in the buffer by a line */
        temp = csr_y - 25 + 1;
f0101c96:	83 eb 18             	sub    $0x18,%ebx
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);
f0101c99:	a1 c4 86 11 f0       	mov    0xf01186c4,%eax
f0101c9e:	0f b7 db             	movzwl %bx,%ebx
f0101ca1:	52                   	push   %edx
f0101ca2:	69 d3 60 ff ff ff    	imul   $0xffffff60,%ebx,%edx
{
    unsigned short blank, temp;

    /* A blank is defined as a space... we need to give it
    *  backcolor too */
    blank = 0x0 | (attrib << 8);
f0101ca8:	c1 e6 08             	shl    $0x8,%esi
        temp = csr_y - 25 + 1;
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memset (textmemptr + (25 - temp) * 80, blank, 80 * 2);
f0101cab:	0f b7 f6             	movzwl %si,%esi
    if(csr_y >= 25)
    {
        /* Move the current text chunk that makes up the screen
        *  back in the buffer by a line */
        temp = csr_y - 25 + 1;
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);
f0101cae:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f0101cb4:	52                   	push   %edx
f0101cb5:	69 d3 a0 00 00 00    	imul   $0xa0,%ebx,%edx

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memset (textmemptr + (25 - temp) * 80, blank, 80 * 2);
f0101cbb:	6b db b0             	imul   $0xffffffb0,%ebx,%ebx
    if(csr_y >= 25)
    {
        /* Move the current text chunk that makes up the screen
        *  back in the buffer by a line */
        temp = csr_y - 25 + 1;
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);
f0101cbe:	8d 14 10             	lea    (%eax,%edx,1),%edx
f0101cc1:	52                   	push   %edx
f0101cc2:	50                   	push   %eax
f0101cc3:	e8 e1 e5 ff ff       	call   f01002a9 <memcpy>

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memset (textmemptr + (25 - temp) * 80, blank, 80 * 2);
f0101cc8:	83 c4 0c             	add    $0xc,%esp
f0101ccb:	8d 84 1b a0 0f 00 00 	lea    0xfa0(%ebx,%ebx,1),%eax
f0101cd2:	03 05 c4 86 11 f0    	add    0xf01186c4,%eax
f0101cd8:	68 a0 00 00 00       	push   $0xa0
f0101cdd:	56                   	push   %esi
f0101cde:	50                   	push   %eax
f0101cdf:	e8 eb e4 ff ff       	call   f01001cf <memset>
        csr_y = 25 - 1;
f0101ce4:	83 c4 10             	add    $0x10,%esp
f0101ce7:	c7 05 14 52 11 f0 18 	movl   $0x18,0xf0115214
f0101cee:	00 00 00 
    }
}
f0101cf1:	83 c4 04             	add    $0x4,%esp
f0101cf4:	5b                   	pop    %ebx
f0101cf5:	5e                   	pop    %esi
f0101cf6:	c3                   	ret    

f0101cf7 <move_csr>:
    unsigned short temp;

    /* The equation for finding the index in a linear
    *  chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    temp = csr_y * 80 + csr_x;
f0101cf7:	66 6b 0d 14 52 11 f0 	imul   $0x50,0xf0115214,%cx
f0101cfe:	50 
f0101cff:	ba d4 03 00 00       	mov    $0x3d4,%edx
f0101d04:	03 0d 10 52 11 f0    	add    0xf0115210,%ecx
f0101d0a:	b0 0e                	mov    $0xe,%al
f0101d0c:	ee                   	out    %al,(%dx)
    *  where the hardware cursor is to be 'blinking'. To
    *  learn more, you should look up some VGA specific
    *  programming documents. A great start to graphics:
    *  http://www.brackeen.com/home/vga */
    outb(0x3D4, 14);
    outb(0x3D5, temp >> 8);
f0101d0d:	89 c8                	mov    %ecx,%eax
f0101d0f:	b2 d5                	mov    $0xd5,%dl
f0101d11:	66 c1 e8 08          	shr    $0x8,%ax
f0101d15:	ee                   	out    %al,(%dx)
f0101d16:	b0 0f                	mov    $0xf,%al
f0101d18:	b2 d4                	mov    $0xd4,%dl
f0101d1a:	ee                   	out    %al,(%dx)
f0101d1b:	b2 d5                	mov    $0xd5,%dl
f0101d1d:	88 c8                	mov    %cl,%al
f0101d1f:	ee                   	out    %al,(%dx)
    outb(0x3D4, 15);
    outb(0x3D5, temp);
}
f0101d20:	c3                   	ret    

f0101d21 <sys_cls>:

/* Clears the screen */
void sys_cls()
{
f0101d21:	56                   	push   %esi
f0101d22:	53                   	push   %ebx
    unsigned short blank;
    int i;

    /* Again, we need the 'short' that will be used to
    *  represent a space with color */
    blank = 0x0 | (attrib << 8);
f0101d23:	31 db                	xor    %ebx,%ebx
    outb(0x3D5, temp);
}

/* Clears the screen */
void sys_cls()
{
f0101d25:	83 ec 04             	sub    $0x4,%esp
    unsigned short blank;
    int i;

    /* Again, we need the 'short' that will be used to
    *  represent a space with color */
    blank = 0x0 | (attrib << 8);
f0101d28:	8b 35 4c 83 10 f0    	mov    0xf010834c,%esi
f0101d2e:	c1 e6 08             	shl    $0x8,%esi

    /* Sets the entire screen to spaces in our current
    *  color */
    for(i = 0; i < 25; i++)
        memset (textmemptr + i * 80, blank, 80 * 2);
f0101d31:	0f b7 f6             	movzwl %si,%esi
f0101d34:	a1 c4 86 11 f0       	mov    0xf01186c4,%eax
f0101d39:	51                   	push   %ecx
f0101d3a:	68 a0 00 00 00       	push   $0xa0
f0101d3f:	56                   	push   %esi
f0101d40:	01 d8                	add    %ebx,%eax
f0101d42:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
f0101d48:	50                   	push   %eax
f0101d49:	e8 81 e4 ff ff       	call   f01001cf <memset>
    *  represent a space with color */
    blank = 0x0 | (attrib << 8);

    /* Sets the entire screen to spaces in our current
    *  color */
    for(i = 0; i < 25; i++)
f0101d4e:	83 c4 10             	add    $0x10,%esp
f0101d51:	81 fb a0 0f 00 00    	cmp    $0xfa0,%ebx
f0101d57:	75 db                	jne    f0101d34 <sys_cls+0x13>
        memset (textmemptr + i * 80, blank, 80 * 2);

    /* Update out virtual cursor, and then move the
    *  hardware cursor */
    csr_x = 0;
f0101d59:	c7 05 10 52 11 f0 00 	movl   $0x0,0xf0115210
f0101d60:	00 00 00 
    csr_y = 0;
f0101d63:	c7 05 14 52 11 f0 00 	movl   $0x0,0xf0115214
f0101d6a:	00 00 00 
    move_csr();
}
f0101d6d:	83 c4 04             	add    $0x4,%esp
f0101d70:	5b                   	pop    %ebx
f0101d71:	5e                   	pop    %esi

    /* Update out virtual cursor, and then move the
    *  hardware cursor */
    csr_x = 0;
    csr_y = 0;
    move_csr();
f0101d72:	e9 80 ff ff ff       	jmp    f0101cf7 <move_csr>

f0101d77 <k_putch>:
}

/* Puts a single character on the screen */
void k_putch(unsigned char c)
{
f0101d77:	53                   	push   %ebx
f0101d78:	83 ec 08             	sub    $0x8,%esp
    unsigned short *where;
    unsigned short att = attrib << 8;
f0101d7b:	8b 0d 4c 83 10 f0    	mov    0xf010834c,%ecx
    move_csr();
}

/* Puts a single character on the screen */
void k_putch(unsigned char c)
{
f0101d81:	8a 44 24 10          	mov    0x10(%esp),%al
    unsigned short *where;
    unsigned short att = attrib << 8;
f0101d85:	c1 e1 08             	shl    $0x8,%ecx

    /* Handle a backspace, by moving the cursor back one space */
    if(c == 0x08)
f0101d88:	3c 08                	cmp    $0x8,%al
f0101d8a:	75 21                	jne    f0101dad <k_putch+0x36>
    {
        if(csr_x != 0) {
f0101d8c:	a1 10 52 11 f0       	mov    0xf0115210,%eax
f0101d91:	85 c0                	test   %eax,%eax
f0101d93:	74 7d                	je     f0101e12 <k_putch+0x9b>
          where = (textmemptr-1) + (csr_y * 80 + csr_x);
f0101d95:	6b 15 14 52 11 f0 50 	imul   $0x50,0xf0115214,%edx
f0101d9c:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
          *where = 0x0 | att;	/* Character AND attributes: color */
f0101da0:	8b 15 c4 86 11 f0    	mov    0xf01186c4,%edx
          csr_x--;
f0101da6:	48                   	dec    %eax
    /* Handle a backspace, by moving the cursor back one space */
    if(c == 0x08)
    {
        if(csr_x != 0) {
          where = (textmemptr-1) + (csr_y * 80 + csr_x);
          *where = 0x0 | att;	/* Character AND attributes: color */
f0101da7:	66 89 0c 5a          	mov    %cx,(%edx,%ebx,2)
f0101dab:	eb 0f                	jmp    f0101dbc <k_putch+0x45>
          csr_x--;
        }
    }
    /* Handles a tab by incrementing the cursor's x, but only
    *  to a point that will make it divisible by 8 */
    else if(c == 0x09)
f0101dad:	3c 09                	cmp    $0x9,%al
f0101daf:	75 12                	jne    f0101dc3 <k_putch+0x4c>
    {
        csr_x = (csr_x + 8) & ~(8 - 1);
f0101db1:	a1 10 52 11 f0       	mov    0xf0115210,%eax
f0101db6:	83 c0 08             	add    $0x8,%eax
f0101db9:	83 e0 f8             	and    $0xfffffff8,%eax
f0101dbc:	a3 10 52 11 f0       	mov    %eax,0xf0115210
f0101dc1:	eb 4f                	jmp    f0101e12 <k_putch+0x9b>
    }
    /* Handles a 'Carriage Return', which simply brings the
    *  cursor back to the margin */
    else if(c == '\r')
f0101dc3:	3c 0d                	cmp    $0xd,%al
f0101dc5:	75 0c                	jne    f0101dd3 <k_putch+0x5c>
    {
        csr_x = 0;
f0101dc7:	c7 05 10 52 11 f0 00 	movl   $0x0,0xf0115210
f0101dce:	00 00 00 
f0101dd1:	eb 3f                	jmp    f0101e12 <k_putch+0x9b>
    }
    /* We handle our newlines the way DOS and the BIOS do: we
    *  treat it as if a 'CR' was also there, so we bring the
    *  cursor to the margin and we increment the 'y' value */
    else if(c == '\n')
f0101dd3:	3c 0a                	cmp    $0xa,%al
f0101dd5:	75 12                	jne    f0101de9 <k_putch+0x72>
    {
        csr_x = 0;
f0101dd7:	c7 05 10 52 11 f0 00 	movl   $0x0,0xf0115210
f0101dde:	00 00 00 
        csr_y++;
f0101de1:	ff 05 14 52 11 f0    	incl   0xf0115214
f0101de7:	eb 29                	jmp    f0101e12 <k_putch+0x9b>
    }
    /* Any character greater than and including a space, is a
    *  printable character. The equation for finding the index
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
f0101de9:	3c 1f                	cmp    $0x1f,%al
f0101deb:	76 25                	jbe    f0101e12 <k_putch+0x9b>
    {
        where = textmemptr + (csr_y * 80 + csr_x);
f0101ded:	8b 15 10 52 11 f0    	mov    0xf0115210,%edx
        *where = c | att;	/* Character AND attributes: color */
f0101df3:	0f b6 c0             	movzbl %al,%eax
    *  printable character. The equation for finding the index
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
    {
        where = textmemptr + (csr_y * 80 + csr_x);
f0101df6:	6b 1d 14 52 11 f0 50 	imul   $0x50,0xf0115214,%ebx
        *where = c | att;	/* Character AND attributes: color */
f0101dfd:	09 c8                	or     %ecx,%eax
f0101dff:	8b 0d c4 86 11 f0    	mov    0xf01186c4,%ecx
    *  printable character. The equation for finding the index
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
    {
        where = textmemptr + (csr_y * 80 + csr_x);
f0101e05:	01 d3                	add    %edx,%ebx
        *where = c | att;	/* Character AND attributes: color */
        csr_x++;
f0101e07:	42                   	inc    %edx
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
    {
        where = textmemptr + (csr_y * 80 + csr_x);
        *where = c | att;	/* Character AND attributes: color */
f0101e08:	66 89 04 59          	mov    %ax,(%ecx,%ebx,2)
        csr_x++;
f0101e0c:	89 15 10 52 11 f0    	mov    %edx,0xf0115210
    }

    /* If the cursor has reached the edge of the screen's width, we
    *  insert a new line in there */
    if(csr_x >= 80)
f0101e12:	83 3d 10 52 11 f0 4f 	cmpl   $0x4f,0xf0115210
f0101e19:	7e 10                	jle    f0101e2b <k_putch+0xb4>
    {
        csr_x = 0;
        csr_y++;
f0101e1b:	ff 05 14 52 11 f0    	incl   0xf0115214

    /* If the cursor has reached the edge of the screen's width, we
    *  insert a new line in there */
    if(csr_x >= 80)
    {
        csr_x = 0;
f0101e21:	c7 05 10 52 11 f0 00 	movl   $0x0,0xf0115210
f0101e28:	00 00 00 
        csr_y++;
    }

    /* Scroll the screen if needed, and finally move the cursor */
    scroll();
f0101e2b:	e8 50 fe ff ff       	call   f0101c80 <scroll>
    move_csr();
}
f0101e30:	83 c4 08             	add    $0x8,%esp
f0101e33:	5b                   	pop    %ebx
        csr_y++;
    }

    /* Scroll the screen if needed, and finally move the cursor */
    scroll();
    move_csr();
f0101e34:	e9 be fe ff ff       	jmp    f0101cf7 <move_csr>

f0101e39 <k_puts>:
}

/* Uses the above routine to output a string... */
void k_puts(unsigned char *text)
{
f0101e39:	56                   	push   %esi
f0101e3a:	53                   	push   %ebx
    int i;

    for (i = 0; i < strlen((char*)text); i++)
f0101e3b:	31 db                	xor    %ebx,%ebx
    move_csr();
}

/* Uses the above routine to output a string... */
void k_puts(unsigned char *text)
{
f0101e3d:	83 ec 04             	sub    $0x4,%esp
f0101e40:	8b 74 24 10          	mov    0x10(%esp),%esi
    int i;

    for (i = 0; i < strlen((char*)text); i++)
f0101e44:	eb 11                	jmp    f0101e57 <k_puts+0x1e>
    {
        k_putch(text[i]);
f0101e46:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
f0101e4a:	83 ec 0c             	sub    $0xc,%esp
/* Uses the above routine to output a string... */
void k_puts(unsigned char *text)
{
    int i;

    for (i = 0; i < strlen((char*)text); i++)
f0101e4d:	43                   	inc    %ebx
    {
        k_putch(text[i]);
f0101e4e:	50                   	push   %eax
f0101e4f:	e8 23 ff ff ff       	call   f0101d77 <k_putch>
/* Uses the above routine to output a string... */
void k_puts(unsigned char *text)
{
    int i;

    for (i = 0; i < strlen((char*)text); i++)
f0101e54:	83 c4 10             	add    $0x10,%esp
f0101e57:	83 ec 0c             	sub    $0xc,%esp
f0101e5a:	56                   	push   %esi
f0101e5b:	e8 a0 e1 ff ff       	call   f0100000 <strlen>
f0101e60:	83 c4 10             	add    $0x10,%esp
f0101e63:	39 c3                	cmp    %eax,%ebx
f0101e65:	7c df                	jl     f0101e46 <k_puts+0xd>
    {
        k_putch(text[i]);
    }
}
f0101e67:	83 c4 04             	add    $0x4,%esp
f0101e6a:	5b                   	pop    %ebx
f0101e6b:	5e                   	pop    %esi
f0101e6c:	c3                   	ret    

f0101e6d <sys_settextcolor>:

/* Sets the forecolor and backcolor that we will use */
void sys_settextcolor(unsigned char forecolor, unsigned char backcolor)
{
    attrib = (backcolor << 4) | (forecolor & 0x0F);
f0101e6d:	0f b6 44 24 08       	movzbl 0x8(%esp),%eax
f0101e72:	0f b6 54 24 04       	movzbl 0x4(%esp),%edx
f0101e77:	c1 e0 04             	shl    $0x4,%eax
f0101e7a:	83 e2 0f             	and    $0xf,%edx
f0101e7d:	09 d0                	or     %edx,%eax
f0101e7f:	a3 4c 83 10 f0       	mov    %eax,0xf010834c
}
f0101e84:	c3                   	ret    

f0101e85 <init_video>:

/* Sets our text-mode VGA pointer, then clears the screen for us */
void init_video(void)
{
f0101e85:	83 ec 0c             	sub    $0xc,%esp
    textmemptr = (unsigned short *)0xB8000;
f0101e88:	c7 05 c4 86 11 f0 00 	movl   $0xb8000,0xf01186c4
f0101e8f:	80 0b 00 
    sys_cls();
}
f0101e92:	83 c4 0c             	add    $0xc,%esp

/* Sets our text-mode VGA pointer, then clears the screen for us */
void init_video(void)
{
    textmemptr = (unsigned short *)0xB8000;
    sys_cls();
f0101e95:	e9 87 fe ff ff       	jmp    f0101d21 <sys_cls>
	...

f0101e9c <page_fault_handler>:
	trap_dispatch(tf);
}


void page_fault_handler(struct Trapframe *tf)
{
f0101e9c:	83 ec 14             	sub    $0x14,%esp

static __inline uint32_t
rcr2(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr2,%0" : "=r" (val));
f0101e9f:	0f 20 d0             	mov    %cr2,%eax
    printk("Page fault @ %p\n", rcr2());
f0101ea2:	50                   	push   %eax
f0101ea3:	68 5c 67 10 f0       	push   $0xf010675c
f0101ea8:	e8 7b 04 00 00       	call   f0102328 <printk>
f0101ead:	83 c4 10             	add    $0x10,%esp
f0101eb0:	eb fe                	jmp    f0101eb0 <page_fault_handler+0x14>

f0101eb2 <print_regs>:
		printk("  ss   0x----%04x\n", tf->tf_ss);
	}
}
void
print_regs(struct PushRegs *regs)
{
f0101eb2:	53                   	push   %ebx
f0101eb3:	83 ec 10             	sub    $0x10,%esp
f0101eb6:	8b 5c 24 18          	mov    0x18(%esp),%ebx
	printk("  edi  0x%08x\n", regs->reg_edi);
f0101eba:	ff 33                	pushl  (%ebx)
f0101ebc:	68 6d 67 10 f0       	push   $0xf010676d
f0101ec1:	e8 62 04 00 00       	call   f0102328 <printk>
	printk("  esi  0x%08x\n", regs->reg_esi);
f0101ec6:	58                   	pop    %eax
f0101ec7:	5a                   	pop    %edx
f0101ec8:	ff 73 04             	pushl  0x4(%ebx)
f0101ecb:	68 7c 67 10 f0       	push   $0xf010677c
f0101ed0:	e8 53 04 00 00       	call   f0102328 <printk>
	printk("  ebp  0x%08x\n", regs->reg_ebp);
f0101ed5:	5a                   	pop    %edx
f0101ed6:	59                   	pop    %ecx
f0101ed7:	ff 73 08             	pushl  0x8(%ebx)
f0101eda:	68 8b 67 10 f0       	push   $0xf010678b
f0101edf:	e8 44 04 00 00       	call   f0102328 <printk>
	printk("  oesp 0x%08x\n", regs->reg_oesp);
f0101ee4:	59                   	pop    %ecx
f0101ee5:	58                   	pop    %eax
f0101ee6:	ff 73 0c             	pushl  0xc(%ebx)
f0101ee9:	68 9a 67 10 f0       	push   $0xf010679a
f0101eee:	e8 35 04 00 00       	call   f0102328 <printk>
	printk("  ebx  0x%08x\n", regs->reg_ebx);
f0101ef3:	58                   	pop    %eax
f0101ef4:	5a                   	pop    %edx
f0101ef5:	ff 73 10             	pushl  0x10(%ebx)
f0101ef8:	68 a9 67 10 f0       	push   $0xf01067a9
f0101efd:	e8 26 04 00 00       	call   f0102328 <printk>
	printk("  edx  0x%08x\n", regs->reg_edx);
f0101f02:	5a                   	pop    %edx
f0101f03:	59                   	pop    %ecx
f0101f04:	ff 73 14             	pushl  0x14(%ebx)
f0101f07:	68 b8 67 10 f0       	push   $0xf01067b8
f0101f0c:	e8 17 04 00 00       	call   f0102328 <printk>
	printk("  ecx  0x%08x\n", regs->reg_ecx);
f0101f11:	59                   	pop    %ecx
f0101f12:	58                   	pop    %eax
f0101f13:	ff 73 18             	pushl  0x18(%ebx)
f0101f16:	68 c7 67 10 f0       	push   $0xf01067c7
f0101f1b:	e8 08 04 00 00       	call   f0102328 <printk>
	printk("  eax  0x%08x\n", regs->reg_eax);
f0101f20:	58                   	pop    %eax
f0101f21:	5a                   	pop    %edx
f0101f22:	ff 73 1c             	pushl  0x1c(%ebx)
f0101f25:	68 d6 67 10 f0       	push   $0xf01067d6
f0101f2a:	e8 f9 03 00 00       	call   f0102328 <printk>
}
f0101f2f:	83 c4 18             	add    $0x18,%esp
f0101f32:	5b                   	pop    %ebx
f0101f33:	c3                   	ret    

f0101f34 <print_trapframe>:
	return "(unknown trap)";
}

void
print_trapframe(struct Trapframe *tf)
{
f0101f34:	56                   	push   %esi
f0101f35:	53                   	push   %ebx
f0101f36:	83 ec 0c             	sub    $0xc,%esp
f0101f39:	8b 5c 24 18          	mov    0x18(%esp),%ebx
	printk("TRAP frame at %p \n", tf);
f0101f3d:	53                   	push   %ebx
f0101f3e:	68 41 68 10 f0       	push   $0xf0106841
f0101f43:	e8 e0 03 00 00       	call   f0102328 <printk>
	print_regs(&tf->tf_regs);
f0101f48:	89 1c 24             	mov    %ebx,(%esp)
f0101f4b:	e8 62 ff ff ff       	call   f0101eb2 <print_regs>
	printk("  es   0x----%04x\n", tf->tf_es);
f0101f50:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0101f54:	5a                   	pop    %edx
f0101f55:	59                   	pop    %ecx
f0101f56:	50                   	push   %eax
f0101f57:	68 54 68 10 f0       	push   $0xf0106854
f0101f5c:	e8 c7 03 00 00       	call   f0102328 <printk>
	printk("  ds   0x----%04x\n", tf->tf_ds);
f0101f61:	5e                   	pop    %esi
f0101f62:	58                   	pop    %eax
f0101f63:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0101f67:	50                   	push   %eax
f0101f68:	68 67 68 10 f0       	push   $0xf0106867
f0101f6d:	e8 b6 03 00 00       	call   f0102328 <printk>
	printk("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0101f72:	8b 43 28             	mov    0x28(%ebx),%eax
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
f0101f75:	83 c4 10             	add    $0x10,%esp
f0101f78:	83 f8 13             	cmp    $0x13,%eax
f0101f7b:	77 09                	ja     f0101f86 <print_trapframe+0x52>
		return excnames[trapno];
f0101f7d:	8b 14 85 98 6a 10 f0 	mov    -0xfef9568(,%eax,4),%edx
f0101f84:	eb 1d                	jmp    f0101fa3 <print_trapframe+0x6f>
	if (trapno == T_SYSCALL)
f0101f86:	83 f8 30             	cmp    $0x30,%eax
		return "System call";
f0101f89:	ba e5 67 10 f0       	mov    $0xf01067e5,%edx
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
f0101f8e:	74 13                	je     f0101fa3 <print_trapframe+0x6f>
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0101f90:	8d 48 e0             	lea    -0x20(%eax),%ecx
		return "Hardware Interrupt";
f0101f93:	ba f1 67 10 f0       	mov    $0xf01067f1,%edx
f0101f98:	83 f9 0f             	cmp    $0xf,%ecx
f0101f9b:	b9 04 68 10 f0       	mov    $0xf0106804,%ecx
f0101fa0:	0f 47 d1             	cmova  %ecx,%edx
{
	printk("TRAP frame at %p \n", tf);
	print_regs(&tf->tf_regs);
	printk("  es   0x----%04x\n", tf->tf_es);
	printk("  ds   0x----%04x\n", tf->tf_ds);
	printk("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0101fa3:	51                   	push   %ecx
f0101fa4:	52                   	push   %edx
f0101fa5:	50                   	push   %eax
f0101fa6:	68 7a 68 10 f0       	push   $0xf010687a
f0101fab:	e8 78 03 00 00       	call   f0102328 <printk>
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0101fb0:	83 c4 10             	add    $0x10,%esp
f0101fb3:	3b 1d 18 5e 11 f0    	cmp    0xf0115e18,%ebx
f0101fb9:	75 19                	jne    f0101fd4 <print_trapframe+0xa0>
f0101fbb:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0101fbf:	75 13                	jne    f0101fd4 <print_trapframe+0xa0>
f0101fc1:	0f 20 d0             	mov    %cr2,%eax
		printk("  cr2  0x%08x\n", rcr2());
f0101fc4:	52                   	push   %edx
f0101fc5:	52                   	push   %edx
f0101fc6:	50                   	push   %eax
f0101fc7:	68 8c 68 10 f0       	push   $0xf010688c
f0101fcc:	e8 57 03 00 00       	call   f0102328 <printk>
f0101fd1:	83 c4 10             	add    $0x10,%esp
	printk("  err  0x%08x", tf->tf_err);
f0101fd4:	56                   	push   %esi
f0101fd5:	56                   	push   %esi
f0101fd6:	ff 73 2c             	pushl  0x2c(%ebx)
f0101fd9:	68 9b 68 10 f0       	push   $0xf010689b
f0101fde:	e8 45 03 00 00       	call   f0102328 <printk>
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
f0101fe3:	83 c4 10             	add    $0x10,%esp
f0101fe6:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0101fea:	75 43                	jne    f010202f <print_trapframe+0xfb>
		printk(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
f0101fec:	8b 73 2c             	mov    0x2c(%ebx),%esi
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		printk(" [%s, %s, %s]\n",
f0101fef:	b8 1e 68 10 f0       	mov    $0xf010681e,%eax
f0101ff4:	b9 13 68 10 f0       	mov    $0xf0106813,%ecx
f0101ff9:	ba 2a 68 10 f0       	mov    $0xf010682a,%edx
f0101ffe:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0102004:	0f 44 c8             	cmove  %eax,%ecx
f0102007:	f7 c6 02 00 00 00    	test   $0x2,%esi
f010200d:	b8 30 68 10 f0       	mov    $0xf0106830,%eax
f0102012:	0f 44 d0             	cmove  %eax,%edx
f0102015:	83 e6 04             	and    $0x4,%esi
f0102018:	51                   	push   %ecx
f0102019:	b8 35 68 10 f0       	mov    $0xf0106835,%eax
f010201e:	be 3a 68 10 f0       	mov    $0xf010683a,%esi
f0102023:	52                   	push   %edx
f0102024:	0f 44 c6             	cmove  %esi,%eax
f0102027:	50                   	push   %eax
f0102028:	68 a9 68 10 f0       	push   $0xf01068a9
f010202d:	eb 08                	jmp    f0102037 <print_trapframe+0x103>
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		printk("\n");
f010202f:	83 ec 0c             	sub    $0xc,%esp
f0102032:	68 52 68 10 f0       	push   $0xf0106852
f0102037:	e8 ec 02 00 00       	call   f0102328 <printk>
f010203c:	5a                   	pop    %edx
f010203d:	59                   	pop    %ecx
	printk("  eip  0x%08x\n", tf->tf_eip);
f010203e:	ff 73 30             	pushl  0x30(%ebx)
f0102041:	68 b8 68 10 f0       	push   $0xf01068b8
f0102046:	e8 dd 02 00 00       	call   f0102328 <printk>
	printk("  cs   0x----%04x\n", tf->tf_cs);
f010204b:	5e                   	pop    %esi
f010204c:	58                   	pop    %eax
f010204d:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0102051:	50                   	push   %eax
f0102052:	68 c7 68 10 f0       	push   $0xf01068c7
f0102057:	e8 cc 02 00 00       	call   f0102328 <printk>
	printk("  flag 0x%08x\n", tf->tf_eflags);
f010205c:	5a                   	pop    %edx
f010205d:	59                   	pop    %ecx
f010205e:	ff 73 38             	pushl  0x38(%ebx)
f0102061:	68 da 68 10 f0       	push   $0xf01068da
f0102066:	e8 bd 02 00 00       	call   f0102328 <printk>
	if ((tf->tf_cs & 3) != 0) {
f010206b:	83 c4 10             	add    $0x10,%esp
f010206e:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0102072:	74 23                	je     f0102097 <print_trapframe+0x163>
		printk("  esp  0x%08x\n", tf->tf_esp);
f0102074:	50                   	push   %eax
f0102075:	50                   	push   %eax
f0102076:	ff 73 3c             	pushl  0x3c(%ebx)
f0102079:	68 e9 68 10 f0       	push   $0xf01068e9
f010207e:	e8 a5 02 00 00       	call   f0102328 <printk>
		printk("  ss   0x----%04x\n", tf->tf_ss);
f0102083:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0102087:	59                   	pop    %ecx
f0102088:	5e                   	pop    %esi
f0102089:	50                   	push   %eax
f010208a:	68 f8 68 10 f0       	push   $0xf01068f8
f010208f:	e8 94 02 00 00       	call   f0102328 <printk>
f0102094:	83 c4 10             	add    $0x10,%esp
	}
}
f0102097:	83 c4 04             	add    $0x4,%esp
f010209a:	5b                   	pop    %ebx
f010209b:	5e                   	pop    %esi
f010209c:	c3                   	ret    

f010209d <register_handler>:
	printk("  ecx  0x%08x\n", regs->reg_ecx);
	printk("  eax  0x%08x\n", regs->reg_eax);
}

void register_handler(int trapno, TrapHandler hnd, void (*trap_entry)(void), int isTrap, int dpl)
{
f010209d:	53                   	push   %ebx
f010209e:	8b 4c 24 10          	mov    0x10(%esp),%ecx
f01020a2:	8b 44 24 08          	mov    0x8(%esp),%eax
	if (trapno >= 0 && trapno < 256 && trap_entry != NULL)
f01020a6:	85 c9                	test   %ecx,%ecx
f01020a8:	74 5a                	je     f0102104 <register_handler+0x67>
f01020aa:	3d ff 00 00 00       	cmp    $0xff,%eax
f01020af:	77 53                	ja     f0102104 <register_handler+0x67>
	{
		trap_hnd[trapno] = hnd;
f01020b1:	8b 54 24 0c          	mov    0xc(%esp),%edx
		/* Set trap gate */
		SETGATE(idt[trapno], isTrap, GD_KT, trap_entry, dpl);
f01020b5:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
f01020ba:	8b 5c 24 18          	mov    0x18(%esp),%ebx
f01020be:	66 89 0c c5 18 52 11 	mov    %cx,-0xfeeade8(,%eax,8)
f01020c5:	f0 

void register_handler(int trapno, TrapHandler hnd, void (*trap_entry)(void), int isTrap, int dpl)
{
	if (trapno >= 0 && trapno < 256 && trap_entry != NULL)
	{
		trap_hnd[trapno] = hnd;
f01020c6:	89 14 85 18 5a 11 f0 	mov    %edx,-0xfeea5e8(,%eax,4)
		/* Set trap gate */
		SETGATE(idt[trapno], isTrap, GD_KT, trap_entry, dpl);
f01020cd:	19 d2                	sbb    %edx,%edx
f01020cf:	83 c2 0f             	add    $0xf,%edx
f01020d2:	83 e3 03             	and    $0x3,%ebx
f01020d5:	83 e2 0f             	and    $0xf,%edx
f01020d8:	c1 e3 05             	shl    $0x5,%ebx
f01020db:	09 da                	or     %ebx,%edx
f01020dd:	83 ca 80             	or     $0xffffff80,%edx
f01020e0:	c1 e9 10             	shr    $0x10,%ecx
f01020e3:	66 c7 04 c5 1a 52 11 	movw   $0x8,-0xfeeade6(,%eax,8)
f01020ea:	f0 08 00 
f01020ed:	c6 04 c5 1c 52 11 f0 	movb   $0x0,-0xfeeade4(,%eax,8)
f01020f4:	00 
f01020f5:	88 14 c5 1d 52 11 f0 	mov    %dl,-0xfeeade3(,%eax,8)
f01020fc:	66 89 0c c5 1e 52 11 	mov    %cx,-0xfeeade2(,%eax,8)
f0102103:	f0 
	}
}
f0102104:	5b                   	pop    %ebx
f0102105:	c3                   	ret    

f0102106 <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0102106:	83 ec 10             	sub    $0x10,%esp
	__asm __volatile("movl %0,%%esp\n"
f0102109:	8b 64 24 14          	mov    0x14(%esp),%esp
f010210d:	61                   	popa   
f010210e:	07                   	pop    %es
f010210f:	1f                   	pop    %ds
f0102110:	83 c4 08             	add    $0x8,%esp
f0102113:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0102114:	68 0b 69 10 f0       	push   $0xf010690b
f0102119:	68 83 00 00 00       	push   $0x83
f010211e:	68 17 69 10 f0       	push   $0xf0106917
f0102123:	e8 2c 21 00 00       	call   f0104254 <_panic>

f0102128 <default_trap_handler>:
	panic("Unexpected trap!");
	
}

void default_trap_handler(struct Trapframe *tf)
{
f0102128:	57                   	push   %edi
f0102129:	56                   	push   %esi
f010212a:	83 ec 04             	sub    $0x4,%esp
f010212d:	8b 74 24 10          	mov    0x10(%esp),%esi
trap_dispatch(struct Trapframe *tf)
{
	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f0102131:	8b 46 28             	mov    0x28(%esi),%eax

void default_trap_handler(struct Trapframe *tf)
{
	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;
f0102134:	89 35 18 5e 11 f0    	mov    %esi,0xf0115e18
trap_dispatch(struct Trapframe *tf)
{
	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f010213a:	83 f8 27             	cmp    $0x27,%eax
f010213d:	75 1b                	jne    f010215a <default_trap_handler+0x32>
		printk("Spurious interrupt on irq 7\n");
f010213f:	83 ec 0c             	sub    $0xc,%esp
f0102142:	68 25 69 10 f0       	push   $0xf0106925
f0102147:	e8 dc 01 00 00       	call   f0102328 <printk>
		print_trapframe(tf);
f010214c:	89 74 24 20          	mov    %esi,0x20(%esp)
	// print_trapframe can print some additional information.
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);
}
f0102150:	83 c4 14             	add    $0x14,%esp
f0102153:	5e                   	pop    %esi
f0102154:	5f                   	pop    %edi
	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
		printk("Spurious interrupt on irq 7\n");
		print_trapframe(tf);
f0102155:	e9 da fd ff ff       	jmp    f0101f34 <print_trapframe>
		return;
	}

	last_tf = tf;
	/* Lab3: Check the trap number and call the interrupt handler. */
	if (trap_hnd[tf->tf_trapno] != NULL)
f010215a:	83 3c 85 18 5a 11 f0 	cmpl   $0x0,-0xfeea5e8(,%eax,4)
f0102161:	00 
f0102162:	74 3b                	je     f010219f <default_trap_handler+0x77>
	{
	
		if ((tf->tf_cs & 3) == 3)
f0102164:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0102168:	83 e0 03             	and    $0x3,%eax
f010216b:	83 f8 03             	cmp    $0x3,%eax
f010216e:	75 13                	jne    f0102183 <default_trap_handler+0x5b>
			// Trapped from user mode.
			extern Task *cur_task;

			// Disable interrupt first
			// Think: Why we disable interrupt here?
			__asm __volatile("cli");
f0102170:	fa                   	cli    

			// Copy trap frame (which is currently on the stack)
			// into 'cur_task->tf', so that running the environment
			// will restart at the trap point.
			cur_task->tf = *tf;
f0102171:	a1 2c 5e 11 f0       	mov    0xf0115e2c,%eax
f0102176:	b9 11 00 00 00       	mov    $0x11,%ecx
f010217b:	8d 78 08             	lea    0x8(%eax),%edi
f010217e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			tf = &(cur_task->tf);
f0102180:	8d 70 08             	lea    0x8(%eax),%esi
				
		}
		// Do ISR
		trap_hnd[tf->tf_trapno](tf);
f0102183:	8b 46 28             	mov    0x28(%esi),%eax
f0102186:	83 ec 0c             	sub    $0xc,%esp
f0102189:	56                   	push   %esi
f010218a:	ff 14 85 18 5a 11 f0 	call   *-0xfeea5e8(,%eax,4)
		
		// Pop the kernel stack 
		env_pop_tf(tf);
f0102191:	89 74 24 20          	mov    %esi,0x20(%esp)
	// print_trapframe can print some additional information.
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);
}
f0102195:	83 c4 14             	add    $0x14,%esp
f0102198:	5e                   	pop    %esi
f0102199:	5f                   	pop    %edi
		}
		// Do ISR
		trap_hnd[tf->tf_trapno](tf);
		
		// Pop the kernel stack 
		env_pop_tf(tf);
f010219a:	e9 67 ff ff ff       	jmp    f0102106 <env_pop_tf>
		return;
	}

	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
f010219f:	83 ec 0c             	sub    $0xc,%esp
f01021a2:	56                   	push   %esi
f01021a3:	e8 8c fd ff ff       	call   f0101f34 <print_trapframe>
	panic("Unexpected trap!");
f01021a8:	83 c4 0c             	add    $0xc,%esp
f01021ab:	68 42 69 10 f0       	push   $0xf0106942
f01021b0:	68 b1 00 00 00       	push   $0xb1
f01021b5:	68 17 69 10 f0       	push   $0xf0106917
f01021ba:	e8 95 20 00 00       	call   f0104254 <_panic>

f01021bf <trap_init>:
	int i;
	/* Initial interrupt descrip table for all traps */
	extern void Default_ISR();
	for (i = 0; i < 256; i++)
	{
		SETGATE(idt[i], 1, GD_KT, Default_ISR, 0);
f01021bf:	b9 84 22 10 f0       	mov    $0xf0102284,%ecx
void trap_init()
{
	int i;
	/* Initial interrupt descrip table for all traps */
	extern void Default_ISR();
	for (i = 0; i < 256; i++)
f01021c4:	31 c0                	xor    %eax,%eax
	{
		SETGATE(idt[i], 1, GD_KT, Default_ISR, 0);
f01021c6:	c1 e9 10             	shr    $0x10,%ecx
f01021c9:	ba 84 22 10 f0       	mov    $0xf0102284,%edx
f01021ce:	66 89 14 c5 18 52 11 	mov    %dx,-0xfeeade8(,%eax,8)
f01021d5:	f0 
f01021d6:	66 c7 04 c5 1a 52 11 	movw   $0x8,-0xfeeade6(,%eax,8)
f01021dd:	f0 08 00 
f01021e0:	c6 04 c5 1c 52 11 f0 	movb   $0x0,-0xfeeade4(,%eax,8)
f01021e7:	00 
f01021e8:	c6 04 c5 1d 52 11 f0 	movb   $0x8f,-0xfeeade3(,%eax,8)
f01021ef:	8f 
f01021f0:	66 89 0c c5 1e 52 11 	mov    %cx,-0xfeeade2(,%eax,8)
f01021f7:	f0 
		trap_hnd[i] = NULL;
f01021f8:	c7 04 85 18 5a 11 f0 	movl   $0x0,-0xfeea5e8(,%eax,4)
f01021ff:	00 00 00 00 
void trap_init()
{
	int i;
	/* Initial interrupt descrip table for all traps */
	extern void Default_ISR();
	for (i = 0; i < 256; i++)
f0102203:	40                   	inc    %eax
f0102204:	3d 00 01 00 00       	cmp    $0x100,%eax
f0102209:	75 c3                	jne    f01021ce <trap_init+0xf>
	extern void STACK_ISR();
	SETGATE(idt[T_STACK], 1, GD_KT, STACK_ISR, 0);

  /* Using custom trap handler */
	extern void PGFLT();
    register_handler(T_PGFLT, page_fault_handler, PGFLT, 1, 0);
f010220b:	6a 00                	push   $0x0
	}


  /* Using default_trap_handler */
	extern void GPFLT();
	SETGATE(idt[T_GPFLT], 1, GD_KT, GPFLT, 0);
f010220d:	b8 a0 22 10 f0       	mov    $0xf01022a0,%eax
	extern void STACK_ISR();
	SETGATE(idt[T_STACK], 1, GD_KT, STACK_ISR, 0);

  /* Using custom trap handler */
	extern void PGFLT();
    register_handler(T_PGFLT, page_fault_handler, PGFLT, 1, 0);
f0102212:	6a 01                	push   $0x1
f0102214:	68 ac 22 10 f0       	push   $0xf01022ac
f0102219:	68 9c 1e 10 f0       	push   $0xf0101e9c
f010221e:	6a 0e                	push   $0xe
	}


  /* Using default_trap_handler */
	extern void GPFLT();
	SETGATE(idt[T_GPFLT], 1, GD_KT, GPFLT, 0);
f0102220:	66 a3 80 52 11 f0    	mov    %ax,0xf0115280
f0102226:	c1 e8 10             	shr    $0x10,%eax
f0102229:	66 a3 86 52 11 f0    	mov    %ax,0xf0115286
	extern void STACK_ISR();
	SETGATE(idt[T_STACK], 1, GD_KT, STACK_ISR, 0);
f010222f:	b8 a6 22 10 f0       	mov    $0xf01022a6,%eax
f0102234:	66 a3 78 52 11 f0    	mov    %ax,0xf0115278
f010223a:	c1 e8 10             	shr    $0x10,%eax
f010223d:	66 a3 7e 52 11 f0    	mov    %ax,0xf011527e
	}


  /* Using default_trap_handler */
	extern void GPFLT();
	SETGATE(idt[T_GPFLT], 1, GD_KT, GPFLT, 0);
f0102243:	66 c7 05 82 52 11 f0 	movw   $0x8,0xf0115282
f010224a:	08 00 
f010224c:	c6 05 84 52 11 f0 00 	movb   $0x0,0xf0115284
f0102253:	c6 05 85 52 11 f0 8f 	movb   $0x8f,0xf0115285
	extern void STACK_ISR();
	SETGATE(idt[T_STACK], 1, GD_KT, STACK_ISR, 0);
f010225a:	66 c7 05 7a 52 11 f0 	movw   $0x8,0xf011527a
f0102261:	08 00 
f0102263:	c6 05 7c 52 11 f0 00 	movb   $0x0,0xf011527c
f010226a:	c6 05 7d 52 11 f0 8f 	movb   $0x8f,0xf011527d

  /* Using custom trap handler */
	extern void PGFLT();
    register_handler(T_PGFLT, page_fault_handler, PGFLT, 1, 0);
f0102271:	e8 27 fe ff ff       	call   f010209d <register_handler>
}

static __inline void
lidt(void *p)
{
	__asm __volatile("lidt (%0)" : : "r" (p));
f0102276:	b8 50 83 10 f0       	mov    $0xf0108350,%eax
f010227b:	0f 01 18             	lidtl  (%eax)
f010227e:	83 c4 14             	add    $0x14,%esp

	lidt(&idt_pd);
}
f0102281:	c3                   	ret    
	...

f0102284 <Default_ISR>:
	jmp _alltraps

.text

/* ISRs */
TRAPHANDLER_NOEC(Default_ISR, T_DEFAULT)
f0102284:	6a 00                	push   $0x0
f0102286:	68 f4 01 00 00       	push   $0x1f4
f010228b:	eb 25                	jmp    f01022b2 <_alltraps>
f010228d:	90                   	nop

f010228e <KBD_Input>:
TRAPHANDLER_NOEC(KBD_Input, IRQ_OFFSET+IRQ_KBD)
f010228e:	6a 00                	push   $0x0
f0102290:	6a 21                	push   $0x21
f0102292:	eb 1e                	jmp    f01022b2 <_alltraps>

f0102294 <TIM_ISR>:
TRAPHANDLER_NOEC(TIM_ISR, IRQ_OFFSET+IRQ_TIMER)
f0102294:	6a 00                	push   $0x0
f0102296:	6a 20                	push   $0x20
f0102298:	eb 18                	jmp    f01022b2 <_alltraps>

f010229a <do_sys>:
TRAPHANDLER_NOEC(do_sys, T_SYSCALL)
f010229a:	6a 00                	push   $0x0
f010229c:	6a 30                	push   $0x30
f010229e:	eb 12                	jmp    f01022b2 <_alltraps>

f01022a0 <GPFLT>:
// TODO: Lab 5
// Please add interface of system call

TRAPHANDLER_NOEC(GPFLT, T_GPFLT)
f01022a0:	6a 00                	push   $0x0
f01022a2:	6a 0d                	push   $0xd
f01022a4:	eb 0c                	jmp    f01022b2 <_alltraps>

f01022a6 <STACK_ISR>:
TRAPHANDLER_NOEC(STACK_ISR, T_STACK)
f01022a6:	6a 00                	push   $0x0
f01022a8:	6a 0c                	push   $0xc
f01022aa:	eb 06                	jmp    f01022b2 <_alltraps>

f01022ac <PGFLT>:
TRAPHANDLER_NOEC(PGFLT, T_PGFLT)
f01022ac:	6a 00                	push   $0x0
f01022ae:	6a 0e                	push   $0xe
f01022b0:	eb 00                	jmp    f01022b2 <_alltraps>

f01022b2 <_alltraps>:
_alltraps:
	/* Lab3: Push the registers into stack( fill the Trapframe structure )
	 * You can reference the http://www.osdever.net/bkerndev/Docs/isrs.htm
	 * After stack parpared, just "call default_trap_handler".
	 */
	pushl %ds
f01022b2:	1e                   	push   %ds
	pushl %es
f01022b3:	06                   	push   %es
	pushal # Push all general register into stack, it maps to Trapframe.tf_regs
f01022b4:	60                   	pusha  
	/* Load the Kernel Data Segment descriptor */
	mov $(GD_KD), %ax
f01022b5:	66 b8 10 00          	mov    $0x10,%ax
	mov %ax, %ds
f01022b9:	8e d8                	mov    %eax,%ds
	mov %ax, %es
f01022bb:	8e c0                	mov    %eax,%es
	mov %ax, %fs
f01022bd:	8e e0                	mov    %eax,%fs
	mov %ax, %gs
f01022bf:	8e e8                	mov    %eax,%gs
	
	pushl %esp # Pass a pointer to the Trapframe as an argument to default_trap_handler()
f01022c1:	54                   	push   %esp
	call default_trap_handler
f01022c2:	e8 61 fe ff ff       	call   f0102128 <default_trap_handler>
	
	/* Restore fs and gs to user data segmemnt */
	push %ax
f01022c7:	66 50                	push   %ax
	mov $(GD_UD), %ax
f01022c9:	66 b8 20 00          	mov    $0x20,%ax
	or $3, %ax
f01022cd:	66 83 c8 03          	or     $0x3,%ax
	mov %ax, %fs
f01022d1:	8e e0                	mov    %eax,%fs
	mov %ax, %gs
f01022d3:	8e e8                	mov    %eax,%gs
	pop %ax 
f01022d5:	66 58                	pop    %ax
	add $4, %esp
f01022d7:	83 c4 04             	add    $0x4,%esp

f01022da <trapret>:

# Return falls through to trapret...
.globl trapret
trapret:
  popal
f01022da:	61                   	popa   
  popl %es
f01022db:	07                   	pop    %es
  popl %ds
f01022dc:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
f01022dd:	83 c4 08             	add    $0x8,%esp
  iret
f01022e0:	cf                   	iret   
f01022e1:	00 00                	add    %al,(%eax)
	...

f01022e4 <putch>:
#include <inc/types.h>
#include <inc/stdio.h>

static void
putch(int ch, int *cnt)
{
f01022e4:	53                   	push   %ebx
f01022e5:	83 ec 14             	sub    $0x14,%esp
	k_putch(ch); // in kernel/screen.c
f01022e8:	0f b6 44 24 1c       	movzbl 0x1c(%esp),%eax
#include <inc/types.h>
#include <inc/stdio.h>

static void
putch(int ch, int *cnt)
{
f01022ed:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	k_putch(ch); // in kernel/screen.c
f01022f1:	50                   	push   %eax
f01022f2:	e8 80 fa ff ff       	call   f0101d77 <k_putch>
	(*cnt)++;
f01022f7:	ff 03                	incl   (%ebx)
}
f01022f9:	83 c4 18             	add    $0x18,%esp
f01022fc:	5b                   	pop    %ebx
f01022fd:	c3                   	ret    

f01022fe <vprintk>:

int
vprintk(const char *fmt, va_list ap)
{
f01022fe:	83 ec 1c             	sub    $0x1c,%esp
	int cnt = 0;
f0102301:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0102308:	00 

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0102309:	ff 74 24 24          	pushl  0x24(%esp)
f010230d:	ff 74 24 24          	pushl  0x24(%esp)
f0102311:	8d 44 24 14          	lea    0x14(%esp),%eax
f0102315:	50                   	push   %eax
f0102316:	68 e4 22 10 f0       	push   $0xf01022e4
f010231b:	e8 4f e3 ff ff       	call   f010066f <vprintfmt>
	return cnt;
}
f0102320:	8b 44 24 1c          	mov    0x1c(%esp),%eax
f0102324:	83 c4 2c             	add    $0x2c,%esp
f0102327:	c3                   	ret    

f0102328 <printk>:

int
printk(const char *fmt, ...)
{
f0102328:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f010232b:	8d 44 24 14          	lea    0x14(%esp),%eax
	cnt = vprintk(fmt, ap);
f010232f:	52                   	push   %edx
f0102330:	52                   	push   %edx
f0102331:	50                   	push   %eax
f0102332:	ff 74 24 1c          	pushl  0x1c(%esp)
f0102336:	e8 c3 ff ff ff       	call   f01022fe <vprintk>
	va_end(ap);

	return cnt;
}
f010233b:	83 c4 1c             	add    $0x1c,%esp
f010233e:	c3                   	ret    
	...

f0102340 <page2pa>:
}

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0102340:	2b 05 d4 86 11 f0    	sub    0xf01186d4,%eax
f0102346:	c1 f8 03             	sar    $0x3,%eax
f0102349:	c1 e0 0c             	shl    $0xc,%eax
}
f010234c:	c3                   	ret    

f010234d <boot_alloc>:
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,#end is behind on bss
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f010234d:	83 3d 24 5e 11 f0 00 	cmpl   $0x0,0xf0115e24
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
// boot_alloc return the address which can be used
static void *
boot_alloc(uint32_t n)
{
f0102354:	89 c2                	mov    %eax,%edx
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,#end is behind on bss
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0102356:	75 11                	jne    f0102369 <boot_alloc+0x1c>
		extern char end[];
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0102358:	b9 ff af 15 f0       	mov    $0xf015afff,%ecx
f010235d:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0102363:	89 0d 24 5e 11 f0    	mov    %ecx,0xf0115e24

	//!! Allocate a chunk large enough to hold 'n' bytes, then update
	//!! nextfree.  Make sure nextfree is kept aligned
	//!!! to a multiple of PGSIZE.
    //if n is zero return the address currently, else return the address can be div by page
    if (n == 0)
f0102369:	85 d2                	test   %edx,%edx
f010236b:	a1 24 5e 11 f0       	mov    0xf0115e24,%eax
f0102370:	74 15                	je     f0102387 <boot_alloc+0x3a>
        return nextfree;
    else if (n > 0)
    {
        result = nextfree;
        nextfree += ROUNDUP(n, PGSIZE);//find the nearest address which is nearest to address is be div by pagesize
f0102372:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
f0102378:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010237e:	8d 14 10             	lea    (%eax,%edx,1),%edx
f0102381:	89 15 24 5e 11 f0    	mov    %edx,0xf0115e24
    }

	return result;
}
f0102387:	c3                   	ret    

f0102388 <_kaddr>:
	return (physaddr_t)kva - KERNBASE;
}

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
f0102388:	53                   	push   %ebx
	if (PGNUM(pa) >= npages)
f0102389:	89 cb                	mov    %ecx,%ebx
	return (physaddr_t)kva - KERNBASE;
}

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
f010238b:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
f010238e:	c1 eb 0c             	shr    $0xc,%ebx
f0102391:	3b 1d c8 86 11 f0    	cmp    0xf01186c8,%ebx
f0102397:	72 0d                	jb     f01023a6 <_kaddr+0x1e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102399:	51                   	push   %ecx
f010239a:	68 e8 6a 10 f0       	push   $0xf0106ae8
f010239f:	52                   	push   %edx
f01023a0:	50                   	push   %eax
f01023a1:	e8 ae 1e 00 00       	call   f0104254 <_panic>
	return (void *)(pa + KERNBASE);
f01023a6:	8d 81 00 00 00 f0    	lea    -0x10000000(%ecx),%eax
}
f01023ac:	83 c4 08             	add    $0x8,%esp
f01023af:	5b                   	pop    %ebx
f01023b0:	c3                   	ret    

f01023b1 <page2kva>:
	return &pages[PGNUM(pa)];
}

static inline void*
page2kva(struct PageInfo *pp)
{
f01023b1:	83 ec 0c             	sub    $0xc,%esp
	return KADDR(page2pa(pp));
f01023b4:	e8 87 ff ff ff       	call   f0102340 <page2pa>
f01023b9:	ba 55 00 00 00       	mov    $0x55,%edx
}
f01023be:	83 c4 0c             	add    $0xc,%esp
}

static inline void*
page2kva(struct PageInfo *pp)
{
	return KADDR(page2pa(pp));
f01023c1:	89 c1                	mov    %eax,%ecx
f01023c3:	b8 0b 6b 10 f0       	mov    $0xf0106b0b,%eax
f01023c8:	eb be                	jmp    f0102388 <_kaddr>

f01023ca <check_va2pa>:
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f01023ca:	56                   	push   %esi
f01023cb:	89 d6                	mov    %edx,%esi
f01023cd:	53                   	push   %ebx
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
		return ~0;
f01023ce:	83 cb ff             	or     $0xffffffff,%ebx
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f01023d1:	c1 ea 16             	shr    $0x16,%edx
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f01023d4:	83 ec 04             	sub    $0x4,%esp
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
f01023d7:	8b 0c 90             	mov    (%eax,%edx,4),%ecx
f01023da:	f6 c1 01             	test   $0x1,%cl
f01023dd:	74 2e                	je     f010240d <check_va2pa+0x43>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f01023df:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01023e5:	ba b7 03 00 00       	mov    $0x3b7,%edx
f01023ea:	b8 1a 6b 10 f0       	mov    $0xf0106b1a,%eax
f01023ef:	e8 94 ff ff ff       	call   f0102388 <_kaddr>
	if (!(p[PTX(va)] & PTE_P))
f01023f4:	c1 ee 0c             	shr    $0xc,%esi
f01023f7:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
f01023fd:	8b 04 b0             	mov    (%eax,%esi,4),%eax
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0102400:	89 c2                	mov    %eax,%edx
f0102402:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102408:	a8 01                	test   $0x1,%al
f010240a:	0f 45 da             	cmovne %edx,%ebx
}
f010240d:	89 d8                	mov    %ebx,%eax
f010240f:	83 c4 04             	add    $0x4,%esp
f0102412:	5b                   	pop    %ebx
f0102413:	5e                   	pop    %esi
f0102414:	c3                   	ret    

f0102415 <pa2page>:
	return (pp - pages) << PGSHIFT;
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
f0102415:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f0102418:	c1 e8 0c             	shr    $0xc,%eax
f010241b:	3b 05 c8 86 11 f0    	cmp    0xf01186c8,%eax
f0102421:	72 12                	jb     f0102435 <pa2page+0x20>
		panic("pa2page called with invalid pa");
f0102423:	50                   	push   %eax
f0102424:	68 27 6b 10 f0       	push   $0xf0106b27
f0102429:	6a 4e                	push   $0x4e
f010242b:	68 0b 6b 10 f0       	push   $0xf0106b0b
f0102430:	e8 1f 1e 00 00       	call   f0104254 <_panic>
	return &pages[PGNUM(pa)];
f0102435:	c1 e0 03             	shl    $0x3,%eax
f0102438:	03 05 d4 86 11 f0    	add    0xf01186d4,%eax
}
f010243e:	83 c4 0c             	add    $0xc,%esp
f0102441:	c3                   	ret    

f0102442 <check_page_free_list>:
//
// Check that the pages on the page_free_list are reasonable.
//
static void
check_page_free_list(bool only_low_memory)
{
f0102442:	55                   	push   %ebp
f0102443:	57                   	push   %edi
f0102444:	56                   	push   %esi
f0102445:	53                   	push   %ebx
f0102446:	83 ec 1c             	sub    $0x1c,%esp
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
f0102449:	8b 1d 1c 5e 11 f0    	mov    0xf0115e1c,%ebx
//
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f010244f:	3c 01                	cmp    $0x1,%al
f0102451:	19 f6                	sbb    %esi,%esi
f0102453:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
f0102459:	46                   	inc    %esi
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
f010245a:	85 db                	test   %ebx,%ebx
f010245c:	75 10                	jne    f010246e <check_page_free_list+0x2c>
		panic("'page_free_list' is a null pointer!");
f010245e:	51                   	push   %ecx
f010245f:	68 46 6b 10 f0       	push   $0xf0106b46
f0102464:	68 ec 02 00 00       	push   $0x2ec
f0102469:	e9 b6 00 00 00       	jmp    f0102524 <check_page_free_list+0xe2>

	if (only_low_memory) {
f010246e:	84 c0                	test   %al,%al
f0102470:	74 4b                	je     f01024bd <check_page_free_list+0x7b>
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0102472:	8d 44 24 0c          	lea    0xc(%esp),%eax
f0102476:	89 04 24             	mov    %eax,(%esp)
f0102479:	8d 44 24 08          	lea    0x8(%esp),%eax
f010247d:	89 44 24 04          	mov    %eax,0x4(%esp)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0102481:	89 d8                	mov    %ebx,%eax
f0102483:	e8 b8 fe ff ff       	call   f0102340 <page2pa>
f0102488:	c1 e8 16             	shr    $0x16,%eax
f010248b:	39 f0                	cmp    %esi,%eax
f010248d:	0f 93 c0             	setae  %al
f0102490:	0f b6 c0             	movzbl %al,%eax
			*tp[pagetype] = pp;
f0102493:	8b 14 84             	mov    (%esp,%eax,4),%edx
f0102496:	89 1a                	mov    %ebx,(%edx)
			tp[pagetype] = &pp->pp_link;
f0102498:	89 1c 84             	mov    %ebx,(%esp,%eax,4)
	if (only_low_memory) {
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f010249b:	8b 1b                	mov    (%ebx),%ebx
f010249d:	85 db                	test   %ebx,%ebx
f010249f:	75 e0                	jne    f0102481 <check_page_free_list+0x3f>
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
			*tp[pagetype] = pp;
			tp[pagetype] = &pp->pp_link;
		}
		*tp[1] = 0;
f01024a1:	8b 44 24 04          	mov    0x4(%esp),%eax
f01024a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f01024ab:	8b 04 24             	mov    (%esp),%eax
f01024ae:	8b 54 24 08          	mov    0x8(%esp),%edx
f01024b2:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f01024b4:	8b 44 24 0c          	mov    0xc(%esp),%eax
f01024b8:	a3 1c 5e 11 f0       	mov    %eax,0xf0115e1c
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01024bd:	8b 1d 1c 5e 11 f0    	mov    0xf0115e1c,%ebx
f01024c3:	eb 2b                	jmp    f01024f0 <check_page_free_list+0xae>
		if (PDX(page2pa(pp)) < pdx_limit)
f01024c5:	89 d8                	mov    %ebx,%eax
f01024c7:	e8 74 fe ff ff       	call   f0102340 <page2pa>
f01024cc:	c1 e8 16             	shr    $0x16,%eax
f01024cf:	39 f0                	cmp    %esi,%eax
f01024d1:	73 1b                	jae    f01024ee <check_page_free_list+0xac>
			memset(page2kva(pp), 0x97, 128);
f01024d3:	89 d8                	mov    %ebx,%eax
f01024d5:	e8 d7 fe ff ff       	call   f01023b1 <page2kva>
f01024da:	52                   	push   %edx
f01024db:	68 80 00 00 00       	push   $0x80
f01024e0:	68 97 00 00 00       	push   $0x97
f01024e5:	50                   	push   %eax
f01024e6:	e8 e4 dc ff ff       	call   f01001cf <memset>
f01024eb:	83 c4 10             	add    $0x10,%esp
		page_free_list = pp1;
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01024ee:	8b 1b                	mov    (%ebx),%ebx
f01024f0:	85 db                	test   %ebx,%ebx
f01024f2:	75 d1                	jne    f01024c5 <check_page_free_list+0x83>
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
f01024f4:	31 c0                	xor    %eax,%eax
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
f01024f6:	31 f6                	xor    %esi,%esi
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
f01024f8:	e8 50 fe ff ff       	call   f010234d <boot_alloc>
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
f01024fd:	31 ff                	xor    %edi,%edi
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f01024ff:	8b 1d 1c 5e 11 f0    	mov    0xf0115e1c,%ebx
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
f0102505:	89 c5                	mov    %eax,%ebp
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0102507:	e9 1a 01 00 00       	jmp    f0102626 <check_page_free_list+0x1e4>
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f010250c:	a1 d4 86 11 f0       	mov    0xf01186d4,%eax
f0102511:	39 c3                	cmp    %eax,%ebx
f0102513:	73 19                	jae    f010252e <check_page_free_list+0xec>
f0102515:	68 6a 6b 10 f0       	push   $0xf0106b6a
f010251a:	68 76 6b 10 f0       	push   $0xf0106b76
f010251f:	68 06 03 00 00       	push   $0x306
f0102524:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102529:	e8 26 1d 00 00       	call   f0104254 <_panic>
		assert(pp < pages + npages);
f010252e:	8b 15 c8 86 11 f0    	mov    0xf01186c8,%edx
f0102534:	8d 14 d0             	lea    (%eax,%edx,8),%edx
f0102537:	39 d3                	cmp    %edx,%ebx
f0102539:	72 11                	jb     f010254c <check_page_free_list+0x10a>
f010253b:	68 8b 6b 10 f0       	push   $0xf0106b8b
f0102540:	68 76 6b 10 f0       	push   $0xf0106b76
f0102545:	68 07 03 00 00       	push   $0x307
f010254a:	eb d8                	jmp    f0102524 <check_page_free_list+0xe2>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f010254c:	89 da                	mov    %ebx,%edx
f010254e:	29 c2                	sub    %eax,%edx
f0102550:	89 d0                	mov    %edx,%eax
f0102552:	a8 07                	test   $0x7,%al
f0102554:	74 11                	je     f0102567 <check_page_free_list+0x125>
f0102556:	68 9f 6b 10 f0       	push   $0xf0106b9f
f010255b:	68 76 6b 10 f0       	push   $0xf0106b76
f0102560:	68 08 03 00 00       	push   $0x308
f0102565:	eb bd                	jmp    f0102524 <check_page_free_list+0xe2>

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp) != 0);
f0102567:	89 d8                	mov    %ebx,%eax
f0102569:	e8 d2 fd ff ff       	call   f0102340 <page2pa>
f010256e:	85 c0                	test   %eax,%eax
f0102570:	75 11                	jne    f0102583 <check_page_free_list+0x141>
f0102572:	68 d1 6b 10 f0       	push   $0xf0106bd1
f0102577:	68 76 6b 10 f0       	push   $0xf0106b76
f010257c:	68 0b 03 00 00       	push   $0x30b
f0102581:	eb a1                	jmp    f0102524 <check_page_free_list+0xe2>
		assert(page2pa(pp) != IOPHYSMEM);
f0102583:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0102588:	75 11                	jne    f010259b <check_page_free_list+0x159>
f010258a:	68 e2 6b 10 f0       	push   $0xf0106be2
f010258f:	68 76 6b 10 f0       	push   $0xf0106b76
f0102594:	68 0c 03 00 00       	push   $0x30c
f0102599:	eb 89                	jmp    f0102524 <check_page_free_list+0xe2>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f010259b:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f01025a0:	75 14                	jne    f01025b6 <check_page_free_list+0x174>
f01025a2:	68 fb 6b 10 f0       	push   $0xf0106bfb
f01025a7:	68 76 6b 10 f0       	push   $0xf0106b76
f01025ac:	68 0d 03 00 00       	push   $0x30d
f01025b1:	e9 6e ff ff ff       	jmp    f0102524 <check_page_free_list+0xe2>
		assert(page2pa(pp) != EXTPHYSMEM);
f01025b6:	3d 00 00 10 00       	cmp    $0x100000,%eax
f01025bb:	75 14                	jne    f01025d1 <check_page_free_list+0x18f>
f01025bd:	68 1e 6c 10 f0       	push   $0xf0106c1e
f01025c2:	68 76 6b 10 f0       	push   $0xf0106b76
f01025c7:	68 0e 03 00 00       	push   $0x30e
f01025cc:	e9 53 ff ff ff       	jmp    f0102524 <check_page_free_list+0xe2>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f01025d1:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f01025d6:	76 1f                	jbe    f01025f7 <check_page_free_list+0x1b5>
f01025d8:	89 d8                	mov    %ebx,%eax
f01025da:	e8 d2 fd ff ff       	call   f01023b1 <page2kva>
f01025df:	39 e8                	cmp    %ebp,%eax
f01025e1:	73 14                	jae    f01025f7 <check_page_free_list+0x1b5>
f01025e3:	68 38 6c 10 f0       	push   $0xf0106c38
f01025e8:	68 76 6b 10 f0       	push   $0xf0106b76
f01025ed:	68 0f 03 00 00       	push   $0x30f
f01025f2:	e9 2d ff ff ff       	jmp    f0102524 <check_page_free_list+0xe2>
    		// (new test for Lab6)
    		assert(page2pa(pp) != MPENTRY_PADDR);
f01025f7:	89 d8                	mov    %ebx,%eax
f01025f9:	e8 42 fd ff ff       	call   f0102340 <page2pa>
f01025fe:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0102603:	75 14                	jne    f0102619 <check_page_free_list+0x1d7>
f0102605:	68 7d 6c 10 f0       	push   $0xf0106c7d
f010260a:	68 76 6b 10 f0       	push   $0xf0106b76
f010260f:	68 11 03 00 00       	push   $0x311
f0102614:	e9 0b ff ff ff       	jmp    f0102524 <check_page_free_list+0xe2>

		if (page2pa(pp) < EXTPHYSMEM)
f0102619:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f010261e:	77 03                	ja     f0102623 <check_page_free_list+0x1e1>
			++nfree_basemem;
f0102620:	47                   	inc    %edi
f0102621:	eb 01                	jmp    f0102624 <check_page_free_list+0x1e2>
		else
			++nfree_extmem;
f0102623:	46                   	inc    %esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0102624:	8b 1b                	mov    (%ebx),%ebx
f0102626:	85 db                	test   %ebx,%ebx
f0102628:	0f 85 de fe ff ff    	jne    f010250c <check_page_free_list+0xca>
			++nfree_basemem;
		else
			++nfree_extmem;
	}

	assert(nfree_basemem > 0);
f010262e:	85 ff                	test   %edi,%edi
f0102630:	75 14                	jne    f0102646 <check_page_free_list+0x204>
f0102632:	68 9a 6c 10 f0       	push   $0xf0106c9a
f0102637:	68 76 6b 10 f0       	push   $0xf0106b76
f010263c:	68 19 03 00 00       	push   $0x319
f0102641:	e9 de fe ff ff       	jmp    f0102524 <check_page_free_list+0xe2>
	assert(nfree_extmem > 0);
f0102646:	85 f6                	test   %esi,%esi
f0102648:	75 14                	jne    f010265e <check_page_free_list+0x21c>
f010264a:	68 ac 6c 10 f0       	push   $0xf0106cac
f010264f:	68 76 6b 10 f0       	push   $0xf0106b76
f0102654:	68 1a 03 00 00       	push   $0x31a
f0102659:	e9 c6 fe ff ff       	jmp    f0102524 <check_page_free_list+0xe2>
	printk("check_page_free_list() succeeded!\n");
f010265e:	83 ec 0c             	sub    $0xc,%esp
f0102661:	68 bd 6c 10 f0       	push   $0xf0106cbd
f0102666:	e8 bd fc ff ff       	call   f0102328 <printk>
}
f010266b:	83 c4 2c             	add    $0x2c,%esp
f010266e:	5b                   	pop    %ebx
f010266f:	5e                   	pop    %esi
f0102670:	5f                   	pop    %edi
f0102671:	5d                   	pop    %ebp
f0102672:	c3                   	ret    

f0102673 <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0102673:	56                   	push   %esi
f0102674:	53                   	push   %ebx
f0102675:	89 c3                	mov    %eax,%ebx
f0102677:	83 ec 10             	sub    $0x10,%esp
  return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f010267a:	43                   	inc    %ebx
f010267b:	50                   	push   %eax
f010267c:	e8 57 1c 00 00       	call   f01042d8 <mc146818_read>
f0102681:	89 1c 24             	mov    %ebx,(%esp)
f0102684:	89 c6                	mov    %eax,%esi
f0102686:	e8 4d 1c 00 00       	call   f01042d8 <mc146818_read>
}
f010268b:	83 c4 14             	add    $0x14,%esp
f010268e:	5b                   	pop    %ebx
// --------------------------------------------------------------

static int
nvram_read(int r)
{
  return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f010268f:	c1 e0 08             	shl    $0x8,%eax
f0102692:	09 f0                	or     %esi,%eax
}
f0102694:	5e                   	pop    %esi
f0102695:	c3                   	ret    

f0102696 <_paddr.clone.0>:


/* -------------- Inline Functions --------------  */

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
f0102696:	83 ec 0c             	sub    $0xc,%esp
{
	if ((uint32_t)kva < KERNBASE)
f0102699:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f010269f:	77 11                	ja     f01026b2 <_paddr.clone.0+0x1c>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01026a1:	52                   	push   %edx
f01026a2:	68 f6 64 10 f0       	push   $0xf01064f6
f01026a7:	50                   	push   %eax
f01026a8:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01026ad:	e8 a2 1b 00 00       	call   f0104254 <_panic>
	return (physaddr_t)kva - KERNBASE;
f01026b2:	8d 82 00 00 00 10    	lea    0x10000000(%edx),%eax
}
f01026b8:	83 c4 0c             	add    $0xc,%esp
f01026bb:	c3                   	ret    

f01026bc <page_init>:
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f01026bc:	57                   	push   %edi
	 * MPENTRY_PADDR to the free list, so that we can safely
	 * copy and run AP bootstrap code at that physical address
	 *
	 */
    size_t i;
	for (i = 0; i < npages; i++) {
f01026bd:	31 ff                	xor    %edi,%edi
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f01026bf:	56                   	push   %esi
	 * MPENTRY_PADDR to the free list, so that we can safely
	 * copy and run AP bootstrap code at that physical address
	 *
	 */
    size_t i;
	for (i = 0; i < npages; i++) {
f01026c0:	31 f6                	xor    %esi,%esi
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f01026c2:	53                   	push   %ebx
	 * MPENTRY_PADDR to the free list, so that we can safely
	 * copy and run AP bootstrap code at that physical address
	 *
	 */
    size_t i;
	for (i = 0; i < npages; i++) {
f01026c3:	31 db                	xor    %ebx,%ebx
f01026c5:	eb 76                	jmp    f010273d <page_init+0x81>
        if(i ==0)
f01026c7:	85 db                	test   %ebx,%ebx
f01026c9:	75 07                	jne    f01026d2 <page_init+0x16>
        {
            pages[i].pp_ref = 1; //from the hint tell us the 0 page is taken
f01026cb:	a1 d4 86 11 f0       	mov    0xf01186d4,%eax
f01026d0:	eb 39                	jmp    f010270b <page_init+0x4f>
            pages[i].pp_link=NULL;
        }
        else if(i<npages_basemem)
f01026d2:	3b 1d 20 5e 11 f0    	cmp    0xf0115e20,%ebx
f01026d8:	73 12                	jae    f01026ec <page_init+0x30>
        {
            size_t phyaddr = i * PGSIZE;
            if (phyaddr >= ROUNDDOWN(MPENTRY_PADDR, PGSIZE) && phyaddr <= ROUNDUP(MPENTRY_PADDR+PGSIZE, PGSIZE)) {
f01026da:	81 ff ff 6f 00 00    	cmp    $0x6fff,%edi
f01026e0:	76 37                	jbe    f0102719 <page_init+0x5d>
f01026e2:	81 ff 00 80 00 00    	cmp    $0x8000,%edi
f01026e8:	76 49                	jbe    f0102733 <page_init+0x77>
f01026ea:	eb 2d                	jmp    f0102719 <page_init+0x5d>
            pages[i].pp_ref = 0;//free
            pages[i].pp_link = page_free_list;
            page_free_list = &pages[i];
        }
        //(ext-io)/pg is number of io , the other is number of part of ext(kernel)
        else if(i < ((EXTPHYSMEM-IOPHYSMEM)/PGSIZE) || i < ((uint32_t)boot_alloc(0)- KERNBASE)/PGSIZE)
f01026ec:	83 fb 5f             	cmp    $0x5f,%ebx
f01026ef:	76 13                	jbe    f0102704 <page_init+0x48>
f01026f1:	31 c0                	xor    %eax,%eax
f01026f3:	e8 55 fc ff ff       	call   f010234d <boot_alloc>
f01026f8:	05 00 00 00 10       	add    $0x10000000,%eax
f01026fd:	c1 e8 0c             	shr    $0xc,%eax
f0102700:	39 c3                	cmp    %eax,%ebx
f0102702:	73 15                	jae    f0102719 <page_init+0x5d>
        {
            pages[i].pp_ref = 1; //from the hint tell us the 0 page is taken
f0102704:	a1 d4 86 11 f0       	mov    0xf01186d4,%eax
f0102709:	01 f0                	add    %esi,%eax
f010270b:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
            pages[i].pp_link=NULL;
f0102711:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f0102717:	eb 1a                	jmp    f0102733 <page_init+0x77>
        }
        else
        {
            pages[i].pp_ref = 0;
f0102719:	a1 d4 86 11 f0       	mov    0xf01186d4,%eax
            pages[i].pp_link = page_free_list;
f010271e:	8b 15 1c 5e 11 f0    	mov    0xf0115e1c,%edx
            pages[i].pp_ref = 1; //from the hint tell us the 0 page is taken
            pages[i].pp_link=NULL;
        }
        else
        {
            pages[i].pp_ref = 0;
f0102724:	01 f0                	add    %esi,%eax
f0102726:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
            pages[i].pp_link = page_free_list;
f010272c:	89 10                	mov    %edx,(%eax)
            page_free_list = &pages[i];
f010272e:	a3 1c 5e 11 f0       	mov    %eax,0xf0115e1c
	 * MPENTRY_PADDR to the free list, so that we can safely
	 * copy and run AP bootstrap code at that physical address
	 *
	 */
    size_t i;
	for (i = 0; i < npages; i++) {
f0102733:	43                   	inc    %ebx
f0102734:	81 c7 00 10 00 00    	add    $0x1000,%edi
f010273a:	83 c6 08             	add    $0x8,%esi
f010273d:	3b 1d c8 86 11 f0    	cmp    0xf01186c8,%ebx
f0102743:	72 82                	jb     f01026c7 <page_init+0xb>
            pages[i].pp_ref = 0;
            pages[i].pp_link = page_free_list;
            page_free_list = &pages[i];
        }
    }
}
f0102745:	5b                   	pop    %ebx
f0102746:	5e                   	pop    %esi
f0102747:	5f                   	pop    %edi
f0102748:	c3                   	ret    

f0102749 <page_alloc>:
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
f0102749:	53                   	push   %ebx
f010274a:	83 ec 08             	sub    $0x8,%esp
    /* TODO */
    if(!page_free_list)
f010274d:	8b 1d 1c 5e 11 f0    	mov    0xf0115e1c,%ebx
f0102753:	85 db                	test   %ebx,%ebx
f0102755:	74 2c                	je     f0102783 <page_alloc+0x3a>
        return NULL;
    struct PageInfo *newpage;
    newpage = page_free_list;
    page_free_list = newpage->pp_link;
f0102757:	8b 03                	mov    (%ebx),%eax
    newpage->pp_link = NULL;
    //get the page and let the link to next page


    if(alloc_flags & ALLOC_ZERO)
f0102759:	f6 44 24 10 01       	testb  $0x1,0x10(%esp)
    if(!page_free_list)
        return NULL;
    struct PageInfo *newpage;
    newpage = page_free_list;
    page_free_list = newpage->pp_link;
    newpage->pp_link = NULL;
f010275e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    /* TODO */
    if(!page_free_list)
        return NULL;
    struct PageInfo *newpage;
    newpage = page_free_list;
    page_free_list = newpage->pp_link;
f0102764:	a3 1c 5e 11 f0       	mov    %eax,0xf0115e1c
    newpage->pp_link = NULL;
    //get the page and let the link to next page


    if(alloc_flags & ALLOC_ZERO)
f0102769:	74 18                	je     f0102783 <page_alloc+0x3a>
         memset(page2kva(newpage),'\0',PGSIZE);
f010276b:	89 d8                	mov    %ebx,%eax
f010276d:	e8 3f fc ff ff       	call   f01023b1 <page2kva>
f0102772:	52                   	push   %edx
f0102773:	68 00 10 00 00       	push   $0x1000
f0102778:	6a 00                	push   $0x0
f010277a:	50                   	push   %eax
f010277b:	e8 4f da ff ff       	call   f01001cf <memset>
f0102780:	83 c4 10             	add    $0x10,%esp
         return newpage;
}
f0102783:	89 d8                	mov    %ebx,%eax
f0102785:	83 c4 08             	add    $0x8,%esp
f0102788:	5b                   	pop    %ebx
f0102789:	c3                   	ret    

f010278a <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct PageInfo *pp)
{
f010278a:	83 ec 0c             	sub    $0xc,%esp
f010278d:	8b 44 24 10          	mov    0x10(%esp),%eax
	// Fill this function in
	// Hint: You may want to panic if pp->pp_ref is nonzero or
	// pp->pp_link is not NULL.
    /* TODO */
    if(pp->pp_link != NULL || pp->pp_ref != 0)
f0102791:	83 38 00             	cmpl   $0x0,(%eax)
f0102794:	75 07                	jne    f010279d <page_free+0x13>
f0102796:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f010279b:	74 15                	je     f01027b2 <page_free+0x28>
    {
        panic("the page can't return free");
f010279d:	51                   	push   %ecx
f010279e:	68 e0 6c 10 f0       	push   $0xf0106ce0
f01027a3:	68 84 01 00 00       	push   $0x184
f01027a8:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01027ad:	e8 a2 1a 00 00       	call   f0104254 <_panic>
        return;
    }   
    pp->pp_link = page_free_list;
f01027b2:	8b 15 1c 5e 11 f0    	mov    0xf0115e1c,%edx
    page_free_list = pp;
f01027b8:	a3 1c 5e 11 f0       	mov    %eax,0xf0115e1c
    if(pp->pp_link != NULL || pp->pp_ref != 0)
    {
        panic("the page can't return free");
        return;
    }   
    pp->pp_link = page_free_list;
f01027bd:	89 10                	mov    %edx,(%eax)
    page_free_list = pp;
}
f01027bf:	83 c4 0c             	add    $0xc,%esp
f01027c2:	c3                   	ret    

f01027c3 <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
f01027c3:	83 ec 0c             	sub    $0xc,%esp
f01027c6:	8b 44 24 10          	mov    0x10(%esp),%eax
	if (--pp->pp_ref == 0)
f01027ca:	8b 50 04             	mov    0x4(%eax),%edx
f01027cd:	4a                   	dec    %edx
f01027ce:	66 85 d2             	test   %dx,%dx
f01027d1:	66 89 50 04          	mov    %dx,0x4(%eax)
f01027d5:	75 08                	jne    f01027df <page_decref+0x1c>
		page_free(pp);
}
f01027d7:	83 c4 0c             	add    $0xc,%esp
//
void
page_decref(struct PageInfo* pp)
{
	if (--pp->pp_ref == 0)
		page_free(pp);
f01027da:	e9 ab ff ff ff       	jmp    f010278a <page_free>
}
f01027df:	83 c4 0c             	add    $0xc,%esp
f01027e2:	c3                   	ret    

f01027e3 <pgdir_walk>:
//
//check a va which have pte?if has ,return it
//if no we create
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
f01027e3:	57                   	push   %edi
f01027e4:	56                   	push   %esi
f01027e5:	53                   	push   %ebx
f01027e6:	8b 5c 24 14          	mov    0x14(%esp),%ebx
	// Fill this function in
    /* TODO */
    int pagedir_index = PDX(va);
f01027ea:	89 de                	mov    %ebx,%esi
f01027ec:	c1 ee 16             	shr    $0x16,%esi
    int pagetable_index = PTX(va);
    //chech the page table entry which is in memory?

    if(!(pgdir[pagedir_index] & PTE_P)){//check the page table(the offset if padir) that can present(inc/mmu.h)
f01027ef:	c1 e6 02             	shl    $0x2,%esi
f01027f2:	03 74 24 10          	add    0x10(%esp),%esi
f01027f6:	8b 3e                	mov    (%esi),%edi
f01027f8:	83 e7 01             	and    $0x1,%edi
f01027fb:	75 2a                	jne    f0102827 <pgdir_walk+0x44>
                return NULL;//return false
            page->pp_ref++;
            pgdir[pagedir_index] =( page2pa(page) | PTE_P | PTE_U | PTE_W); //present read/write user/kernel can use , all OR with page2pa
        }
        else 
            return NULL;
f01027fd:	31 d2                	xor    %edx,%edx
    int pagedir_index = PDX(va);
    int pagetable_index = PTX(va);
    //chech the page table entry which is in memory?

    if(!(pgdir[pagedir_index] & PTE_P)){//check the page table(the offset if padir) that can present(inc/mmu.h)
        if(create){
f01027ff:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
f0102804:	74 44                	je     f010284a <pgdir_walk+0x67>
            struct PageInfo *page = page_alloc(ALLOC_ZERO);//a zero page
f0102806:	83 ec 0c             	sub    $0xc,%esp
f0102809:	6a 01                	push   $0x1
f010280b:	e8 39 ff ff ff       	call   f0102749 <page_alloc>
            if(!page)
f0102810:	83 c4 10             	add    $0x10,%esp
                return NULL;//return false
f0102813:	89 fa                	mov    %edi,%edx
    //chech the page table entry which is in memory?

    if(!(pgdir[pagedir_index] & PTE_P)){//check the page table(the offset if padir) that can present(inc/mmu.h)
        if(create){
            struct PageInfo *page = page_alloc(ALLOC_ZERO);//a zero page
            if(!page)
f0102815:	85 c0                	test   %eax,%eax
f0102817:	74 31                	je     f010284a <pgdir_walk+0x67>
                return NULL;//return false
            page->pp_ref++;
f0102819:	66 ff 40 04          	incw   0x4(%eax)
            pgdir[pagedir_index] =( page2pa(page) | PTE_P | PTE_U | PTE_W); //present read/write user/kernel can use , all OR with page2pa
f010281d:	e8 1e fb ff ff       	call   f0102340 <page2pa>
f0102822:	83 c8 07             	or     $0x7,%eax
f0102825:	89 06                	mov    %eax,(%esi)
        }
        else 
            return NULL;
    }
    pte_t *result;
    result = KADDR(PTE_ADDR(pgdir[pagedir_index]));//PTE_ADDR , the address of page table or dir,inc/mmu.h,KADDR is phy addr to kernel viruial addr , kernel/mem.h
f0102827:	8b 0e                	mov    (%esi),%ecx
f0102829:	ba c5 01 00 00       	mov    $0x1c5,%edx
f010282e:	b8 1a 6b 10 f0       	mov    $0xf0106b1a,%eax
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
	// Fill this function in
    /* TODO */
    int pagedir_index = PDX(va);
    int pagetable_index = PTX(va);
f0102833:	c1 eb 0a             	shr    $0xa,%ebx
        else 
            return NULL;
    }
    pte_t *result;
    result = KADDR(PTE_ADDR(pgdir[pagedir_index]));//PTE_ADDR , the address of page table or dir,inc/mmu.h,KADDR is phy addr to kernel viruial addr , kernel/mem.h
    return &result[pagetable_index];
f0102836:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
        }
        else 
            return NULL;
    }
    pte_t *result;
    result = KADDR(PTE_ADDR(pgdir[pagedir_index]));//PTE_ADDR , the address of page table or dir,inc/mmu.h,KADDR is phy addr to kernel viruial addr , kernel/mem.h
f010283c:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0102842:	e8 41 fb ff ff       	call   f0102388 <_kaddr>
    return &result[pagetable_index];
f0102847:	8d 14 18             	lea    (%eax,%ebx,1),%edx
}
f010284a:	89 d0                	mov    %edx,%eax
f010284c:	5b                   	pop    %ebx
f010284d:	5e                   	pop    %esi
f010284e:	5f                   	pop    %edi
f010284f:	c3                   	ret    

f0102850 <boot_map_region>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)//perm means permission
{
f0102850:	55                   	push   %ebp
f0102851:	89 cd                	mov    %ecx,%ebp
f0102853:	57                   	push   %edi
    /* TODO */
    pte_t *pte;
    int i;
    for (i = 0; i < size/PGSIZE; i++)
f0102854:	31 ff                	xor    %edi,%edi
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)//perm means permission
{
f0102856:	56                   	push   %esi
f0102857:	89 d6                	mov    %edx,%esi
f0102859:	53                   	push   %ebx
f010285a:	89 c3                	mov    %eax,%ebx
f010285c:	83 ec 0c             	sub    $0xc,%esp
    /* TODO */
    pte_t *pte;
    int i;
    for (i = 0; i < size/PGSIZE; i++)
f010285f:	c1 ed 0c             	shr    $0xc,%ebp
    {
        pte = pgdir_walk(pgdir,(void*)va,1);//1 mean create 
        *pte = (pa | perm | PTE_P);
f0102862:	83 4c 24 24 01       	orl    $0x1,0x24(%esp)
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)//perm means permission
{
    /* TODO */
    pte_t *pte;
    int i;
    for (i = 0; i < size/PGSIZE; i++)
f0102867:	eb 26                	jmp    f010288f <boot_map_region+0x3f>
    {
        pte = pgdir_walk(pgdir,(void*)va,1);//1 mean create 
f0102869:	50                   	push   %eax
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)//perm means permission
{
    /* TODO */
    pte_t *pte;
    int i;
    for (i = 0; i < size/PGSIZE; i++)
f010286a:	47                   	inc    %edi
    {
        pte = pgdir_walk(pgdir,(void*)va,1);//1 mean create 
f010286b:	6a 01                	push   $0x1
f010286d:	56                   	push   %esi
        *pte = (pa | perm | PTE_P);
        pa += PGSIZE;
        va += PGSIZE;
f010286e:	81 c6 00 10 00 00    	add    $0x1000,%esi
    /* TODO */
    pte_t *pte;
    int i;
    for (i = 0; i < size/PGSIZE; i++)
    {
        pte = pgdir_walk(pgdir,(void*)va,1);//1 mean create 
f0102874:	53                   	push   %ebx
f0102875:	e8 69 ff ff ff       	call   f01027e3 <pgdir_walk>
        *pte = (pa | perm | PTE_P);
f010287a:	8b 54 24 34          	mov    0x34(%esp),%edx
f010287e:	0b 54 24 30          	or     0x30(%esp),%edx
f0102882:	89 10                	mov    %edx,(%eax)
        pa += PGSIZE;
f0102884:	81 44 24 30 00 10 00 	addl   $0x1000,0x30(%esp)
f010288b:	00 
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)//perm means permission
{
    /* TODO */
    pte_t *pte;
    int i;
    for (i = 0; i < size/PGSIZE; i++)
f010288c:	83 c4 10             	add    $0x10,%esp
f010288f:	39 ef                	cmp    %ebp,%edi
f0102891:	72 d6                	jb     f0102869 <boot_map_region+0x19>
        *pte = (pa | perm | PTE_P);
        pa += PGSIZE;
        va += PGSIZE;
    }
    
}
f0102893:	83 c4 0c             	add    $0xc,%esp
f0102896:	5b                   	pop    %ebx
f0102897:	5e                   	pop    %esi
f0102898:	5f                   	pop    %edi
f0102899:	5d                   	pop    %ebp
f010289a:	c3                   	ret    

f010289b <page_lookup>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
f010289b:	53                   	push   %ebx
f010289c:	83 ec 0c             	sub    $0xc,%esp
f010289f:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
    /* TODO */
    pte_t *pte=pgdir_walk(pgdir,(void *)va,0);
f01028a3:	6a 00                	push   $0x0
f01028a5:	ff 74 24 1c          	pushl  0x1c(%esp)
f01028a9:	ff 74 24 1c          	pushl  0x1c(%esp)
f01028ad:	e8 31 ff ff ff       	call   f01027e3 <pgdir_walk>
    if(pte==NULL)
f01028b2:	83 c4 10             	add    $0x10,%esp
f01028b5:	85 c0                	test   %eax,%eax
f01028b7:	74 1d                	je     f01028d6 <page_lookup+0x3b>
        return NULL;
    if(!(*pte & PTE_P))
f01028b9:	8b 10                	mov    (%eax),%edx
f01028bb:	f6 c2 01             	test   $0x1,%dl
f01028be:	74 16                	je     f01028d6 <page_lookup+0x3b>
        return NULL;
    if(pte_store)
f01028c0:	85 db                	test   %ebx,%ebx
f01028c2:	74 02                	je     f01028c6 <page_lookup+0x2b>
        *pte_store = pte;//if pte_store is not zero ,then put the pde to the pte_store
f01028c4:	89 03                	mov    %eax,(%ebx)
    return pa2page(PTE_ADDR(*pte));
}
f01028c6:	83 c4 08             	add    $0x8,%esp
        return NULL;
    if(!(*pte & PTE_P))
        return NULL;
    if(pte_store)
        *pte_store = pte;//if pte_store is not zero ,then put the pde to the pte_store
    return pa2page(PTE_ADDR(*pte));
f01028c9:	89 d0                	mov    %edx,%eax
}
f01028cb:	5b                   	pop    %ebx
        return NULL;
    if(!(*pte & PTE_P))
        return NULL;
    if(pte_store)
        *pte_store = pte;//if pte_store is not zero ,then put the pde to the pte_store
    return pa2page(PTE_ADDR(*pte));
f01028cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01028d1:	e9 3f fb ff ff       	jmp    f0102415 <pa2page>
}
f01028d6:	31 c0                	xor    %eax,%eax
f01028d8:	83 c4 08             	add    $0x8,%esp
f01028db:	5b                   	pop    %ebx
f01028dc:	c3                   	ret    

f01028dd <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
f01028dd:	53                   	push   %ebx
f01028de:	83 ec 1c             	sub    $0x1c,%esp
f01028e1:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    /* TODO */
    pte_t *pte;
    struct PageInfo *page = page_lookup(pgdir,(void *)va,&pte);
f01028e5:	8d 44 24 10          	lea    0x10(%esp),%eax
f01028e9:	50                   	push   %eax
f01028ea:	53                   	push   %ebx
f01028eb:	ff 74 24 2c          	pushl  0x2c(%esp)
f01028ef:	e8 a7 ff ff ff       	call   f010289b <page_lookup>
    if(page == NULL)
f01028f4:	83 c4 10             	add    $0x10,%esp
f01028f7:	85 c0                	test   %eax,%eax
f01028f9:	74 19                	je     f0102914 <page_remove+0x37>
        return NULL;
    page_decref(page);
f01028fb:	83 ec 0c             	sub    $0xc,%esp
f01028fe:	50                   	push   %eax
f01028ff:	e8 bf fe ff ff       	call   f01027c3 <page_decref>
    *pte = 0;//the page table entry set to 0
f0102904:	8b 44 24 1c          	mov    0x1c(%esp),%eax
f0102908:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}

static __inline void
invlpg(void *addr)
{
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
f010290e:	0f 01 3b             	invlpg (%ebx)
f0102911:	83 c4 10             	add    $0x10,%esp
    tlb_invalidate(pgdir, va);
}
f0102914:	83 c4 18             	add    $0x18,%esp
f0102917:	5b                   	pop    %ebx
f0102918:	c3                   	ret    

f0102919 <page_insert>:
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
f0102919:	55                   	push   %ebp
f010291a:	57                   	push   %edi
f010291b:	56                   	push   %esi
f010291c:	53                   	push   %ebx
f010291d:	83 ec 10             	sub    $0x10,%esp
f0102920:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
f0102924:	8b 7c 24 24          	mov    0x24(%esp),%edi
f0102928:	8b 74 24 28          	mov    0x28(%esp),%esi
    
    /* TODO */
    
    pte_t *pte = pgdir_walk(pgdir,(void *)va,1);
f010292c:	6a 01                	push   $0x1
f010292e:	55                   	push   %ebp
f010292f:	57                   	push   %edi
f0102930:	e8 ae fe ff ff       	call   f01027e3 <pgdir_walk>
    if(pte==NULL)
f0102935:	83 c4 10             	add    $0x10,%esp
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
    
    /* TODO */
    
    pte_t *pte = pgdir_walk(pgdir,(void *)va,1);
f0102938:	89 c3                	mov    %eax,%ebx
    if(pte==NULL)
        return -E_NO_MEM;
f010293a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
{
    
    /* TODO */
    
    pte_t *pte = pgdir_walk(pgdir,(void *)va,1);
    if(pte==NULL)
f010293f:	85 db                	test   %ebx,%ebx
f0102941:	74 29                	je     f010296c <page_insert+0x53>
        return -E_NO_MEM;
    pp->pp_ref++;
f0102943:	66 ff 46 04          	incw   0x4(%esi)
    if(*pte &PTE_P)
f0102947:	f6 03 01             	testb  $0x1,(%ebx)
f010294a:	74 0c                	je     f0102958 <page_insert+0x3f>
        page_remove(pgdir,va);
f010294c:	52                   	push   %edx
f010294d:	52                   	push   %edx
f010294e:	55                   	push   %ebp
f010294f:	57                   	push   %edi
f0102950:	e8 88 ff ff ff       	call   f01028dd <page_remove>
f0102955:	83 c4 10             	add    $0x10,%esp
    *pte = page2pa(pp) | perm | PTE_P;
f0102958:	89 f0                	mov    %esi,%eax
f010295a:	e8 e1 f9 ff ff       	call   f0102340 <page2pa>
f010295f:	8b 54 24 2c          	mov    0x2c(%esp),%edx
f0102963:	83 ca 01             	or     $0x1,%edx
f0102966:	09 c2                	or     %eax,%edx
    return 0;
f0102968:	31 c0                	xor    %eax,%eax
    if(pte==NULL)
        return -E_NO_MEM;
    pp->pp_ref++;
    if(*pte &PTE_P)
        page_remove(pgdir,va);
    *pte = page2pa(pp) | perm | PTE_P;
f010296a:	89 13                	mov    %edx,(%ebx)
    return 0;
    
}
f010296c:	83 c4 0c             	add    $0xc,%esp
f010296f:	5b                   	pop    %ebx
f0102970:	5e                   	pop    %esi
f0102971:	5f                   	pop    %edi
f0102972:	5d                   	pop    %ebp
f0102973:	c3                   	ret    

f0102974 <ptable_remove>:
    tlb_invalidate(pgdir, va);
}

void
ptable_remove(pde_t *pgdir)
{
f0102974:	56                   	push   %esi
f0102975:	53                   	push   %ebx
  int i;
  /* Free Page Tables */
  for (i = 0; i < 1024; i++)
f0102976:	31 db                	xor    %ebx,%ebx
    tlb_invalidate(pgdir, va);
}

void
ptable_remove(pde_t *pgdir)
{
f0102978:	83 ec 04             	sub    $0x4,%esp
f010297b:	8b 74 24 10          	mov    0x10(%esp),%esi
  int i;
  /* Free Page Tables */
  for (i = 0; i < 1024; i++)
  {
    if (pgdir[i] & PTE_P)
f010297f:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
f0102982:	a8 01                	test   $0x1,%al
f0102984:	74 16                	je     f010299c <ptable_remove+0x28>
      page_decref(pa2page(PTE_ADDR(pgdir[i])));
f0102986:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010298b:	e8 85 fa ff ff       	call   f0102415 <pa2page>
f0102990:	83 ec 0c             	sub    $0xc,%esp
f0102993:	50                   	push   %eax
f0102994:	e8 2a fe ff ff       	call   f01027c3 <page_decref>
f0102999:	83 c4 10             	add    $0x10,%esp
void
ptable_remove(pde_t *pgdir)
{
  int i;
  /* Free Page Tables */
  for (i = 0; i < 1024; i++)
f010299c:	43                   	inc    %ebx
f010299d:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f01029a3:	75 da                	jne    f010297f <ptable_remove+0xb>
  {
    if (pgdir[i] & PTE_P)
      page_decref(pa2page(PTE_ADDR(pgdir[i])));
  }
}
f01029a5:	83 c4 04             	add    $0x4,%esp
f01029a8:	5b                   	pop    %ebx
f01029a9:	5e                   	pop    %esi
f01029aa:	c3                   	ret    

f01029ab <pgdir_remove>:


void
pgdir_remove(pde_t *pgdir)
{
f01029ab:	83 ec 0c             	sub    $0xc,%esp
  page_free(pa2page(PADDR(pgdir)));
f01029ae:	b8 53 02 00 00       	mov    $0x253,%eax
f01029b3:	8b 54 24 10          	mov    0x10(%esp),%edx
f01029b7:	e8 da fc ff ff       	call   f0102696 <_paddr.clone.0>
f01029bc:	e8 54 fa ff ff       	call   f0102415 <pa2page>
f01029c1:	89 44 24 10          	mov    %eax,0x10(%esp)
}
f01029c5:	83 c4 0c             	add    $0xc,%esp


void
pgdir_remove(pde_t *pgdir)
{
  page_free(pa2page(PADDR(pgdir)));
f01029c8:	e9 bd fd ff ff       	jmp    f010278a <page_free>

f01029cd <tlb_invalidate>:
f01029cd:	8b 44 24 08          	mov    0x8(%esp),%eax
f01029d1:	0f 01 38             	invlpg (%eax)
tlb_invalidate(pde_t *pgdir, void *va)
{
	// Flush the entry only if we're modifying the current address space.
	// For now, there is only one address space, so always invalidate.
	invlpg(va);
}
f01029d4:	c3                   	ret    

f01029d5 <mmio_map_region>:
// location.  Return the base of the reserved region.  size does *not*
// have to be multiple of PGSIZE.
//
void *
mmio_map_region(physaddr_t pa, size_t size)
{
f01029d5:	56                   	push   %esi
f01029d6:	53                   	push   %ebx
f01029d7:	83 ec 0c             	sub    $0xc,%esp
	//
	// Hint: The TA solution uses boot_map_region.
	//
	// Lab6 TODO
	// Your code here:
    uintptr_t ret_base = base;
f01029da:	8b 35 58 83 10 f0    	mov    0xf0108358,%esi
    boot_map_region(kern_pgdir, base, ROUNDUP(size, PGSIZE), pa, PTE_PCD|PTE_PWT|PTE_W); 
f01029e0:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
f01029e4:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f01029e9:	6a 1a                	push   $0x1a
f01029eb:	ff 74 24 1c          	pushl  0x1c(%esp)
f01029ef:	89 f2                	mov    %esi,%edx
f01029f1:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
f01029f7:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
f01029fd:	89 d9                	mov    %ebx,%ecx
f01029ff:	e8 4c fe ff ff       	call   f0102850 <boot_map_region>
    base += ROUNDUP(size, PGSIZE);
    return ret_base;
	 //   panic("mmio_map_region not implemented");
}
f0102a04:	89 f0                	mov    %esi,%eax
	//
	// Lab6 TODO
	// Your code here:
    uintptr_t ret_base = base;
    boot_map_region(kern_pgdir, base, ROUNDUP(size, PGSIZE), pa, PTE_PCD|PTE_PWT|PTE_W); 
    base += ROUNDUP(size, PGSIZE);
f0102a06:	01 1d 58 83 10 f0    	add    %ebx,0xf0108358
    return ret_base;
	 //   panic("mmio_map_region not implemented");
}
f0102a0c:	83 c4 14             	add    $0x14,%esp
f0102a0f:	5b                   	pop    %ebx
f0102a10:	5e                   	pop    %esi
f0102a11:	c3                   	ret    

f0102a12 <mem_init>:
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f0102a12:	55                   	push   %ebp
{
  size_t npages_extmem;

  // Use CMOS calls to measure available base & extended memory.
  // (CMOS calls return results in kilobytes.)
  npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
f0102a13:	b8 15 00 00 00       	mov    $0x15,%eax
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f0102a18:	57                   	push   %edi
f0102a19:	56                   	push   %esi
f0102a1a:	53                   	push   %ebx
{
  size_t npages_extmem;

  // Use CMOS calls to measure available base & extended memory.
  // (CMOS calls return results in kilobytes.)
  npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
f0102a1b:	bb 04 00 00 00       	mov    $0x4,%ebx
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f0102a20:	83 ec 2c             	sub    $0x2c,%esp
	uint32_t cr0;
    nextfree = 0;
f0102a23:	c7 05 24 5e 11 f0 00 	movl   $0x0,0xf0115e24
f0102a2a:	00 00 00 
    page_free_list = 0;
f0102a2d:	c7 05 1c 5e 11 f0 00 	movl   $0x0,0xf0115e1c
f0102a34:	00 00 00 
{
  size_t npages_extmem;

  // Use CMOS calls to measure available base & extended memory.
  // (CMOS calls return results in kilobytes.)
  npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
f0102a37:	e8 37 fc ff ff       	call   f0102673 <nvram_read>
f0102a3c:	99                   	cltd   
f0102a3d:	f7 fb                	idiv   %ebx
f0102a3f:	a3 20 5e 11 f0       	mov    %eax,0xf0115e20
  npages_extmem = (nvram_read(NVRAM_EXTLO) * 1024) / PGSIZE;
f0102a44:	b8 17 00 00 00       	mov    $0x17,%eax
f0102a49:	e8 25 fc ff ff       	call   f0102673 <nvram_read>
f0102a4e:	99                   	cltd   
f0102a4f:	f7 fb                	idiv   %ebx

  // Calculate the number of physical pages available in both base
  // and extended memory.
  if (npages_extmem)
f0102a51:	85 c0                	test   %eax,%eax
    npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
f0102a53:	8d 90 00 01 00 00    	lea    0x100(%eax),%edx
  npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
  npages_extmem = (nvram_read(NVRAM_EXTLO) * 1024) / PGSIZE;

  // Calculate the number of physical pages available in both base
  // and extended memory.
  if (npages_extmem)
f0102a59:	75 06                	jne    f0102a61 <mem_init+0x4f>
    npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
  else
    npages = npages_basemem;
f0102a5b:	8b 15 20 5e 11 f0    	mov    0xf0115e20,%edx

  printk("Physical memory: %uK available, base = %uK, extended = %uK\n",
      npages * PGSIZE / 1024,
      npages_basemem * PGSIZE / 1024,
      npages_extmem * PGSIZE / 1024);
f0102a61:	c1 e0 0c             	shl    $0xc,%eax
  if (npages_extmem)
    npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
  else
    npages = npages_basemem;

  printk("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0102a64:	c1 e8 0a             	shr    $0xa,%eax
f0102a67:	50                   	push   %eax
      npages * PGSIZE / 1024,
      npages_basemem * PGSIZE / 1024,
f0102a68:	a1 20 5e 11 f0       	mov    0xf0115e20,%eax
  // Calculate the number of physical pages available in both base
  // and extended memory.
  if (npages_extmem)
    npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
  else
    npages = npages_basemem;
f0102a6d:	89 15 c8 86 11 f0    	mov    %edx,0xf01186c8

  printk("Physical memory: %uK available, base = %uK, extended = %uK\n",
      npages * PGSIZE / 1024,
      npages_basemem * PGSIZE / 1024,
f0102a73:	c1 e0 0c             	shl    $0xc,%eax
  if (npages_extmem)
    npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
  else
    npages = npages_basemem;

  printk("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0102a76:	c1 e8 0a             	shr    $0xa,%eax
f0102a79:	50                   	push   %eax
      npages * PGSIZE / 1024,
f0102a7a:	a1 c8 86 11 f0       	mov    0xf01186c8,%eax
f0102a7f:	c1 e0 0c             	shl    $0xc,%eax
  if (npages_extmem)
    npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
  else
    npages = npages_basemem;

  printk("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0102a82:	c1 e8 0a             	shr    $0xa,%eax
f0102a85:	50                   	push   %eax
f0102a86:	68 fb 6c 10 f0       	push   $0xf0106cfb
f0102a8b:	e8 98 f8 ff ff       	call   f0102328 <printk>
	// Find out how much memory the machine has (npages & npages_basemem).
	i386_detect_memory();//get the number of membase page(can be used) ,io hole page(not) ,extmem page(ok)

	//////////////////////////////////////////////////////////////////////
	//!!! create initial page directory.
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);//in inc/mmu.h PGSIZE is 4096b = 4KB
f0102a90:	b8 00 10 00 00       	mov    $0x1000,%eax
f0102a95:	e8 b3 f8 ff ff       	call   f010234d <boot_alloc>
	memset(kern_pgdir, 0, PGSIZE);//memset(start addr , content, size)
f0102a9a:	83 c4 0c             	add    $0xc,%esp
f0102a9d:	68 00 10 00 00       	push   $0x1000
f0102aa2:	6a 00                	push   $0x0
f0102aa4:	50                   	push   %eax
	// Find out how much memory the machine has (npages & npages_basemem).
	i386_detect_memory();//get the number of membase page(can be used) ,io hole page(not) ,extmem page(ok)

	//////////////////////////////////////////////////////////////////////
	//!!! create initial page directory.
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);//in inc/mmu.h PGSIZE is 4096b = 4KB
f0102aa5:	a3 cc 86 11 f0       	mov    %eax,0xf01186cc
	memset(kern_pgdir, 0, PGSIZE);//memset(start addr , content, size)
f0102aaa:	e8 20 d7 ff ff       	call   f01001cf <memset>
	// (For now, you don't have understand the greater purpose of the
	// following line.)

	// Permissions: kernel R, user R
    // UVPT is a virtual address in memlayout.h , the address is map to the kern_pgdir(physcial addr)
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f0102aaf:	8b 1d cc 86 11 f0    	mov    0xf01186cc,%ebx
f0102ab5:	b8 92 00 00 00       	mov    $0x92,%eax
f0102aba:	89 da                	mov    %ebx,%edx
f0102abc:	e8 d5 fb ff ff       	call   f0102696 <_paddr.clone.0>
f0102ac1:	83 c8 05             	or     $0x5,%eax
f0102ac4:	89 83 f4 0e 00 00    	mov    %eax,0xef4(%ebx)
	// each physical page, there is a corresponding struct PageInfo in this
	// array.  'npages' is the number of physical pages in memory.  Use memset
	// to initialize all fields of each struct PageInfo to 0.
	// Your code goes here:
    /* TODO */
    pages = (struct PageInfo *)boot_alloc(sizeof(struct PageInfo)*npages);
f0102aca:	a1 c8 86 11 f0       	mov    0xf01186c8,%eax
f0102acf:	c1 e0 03             	shl    $0x3,%eax
f0102ad2:	e8 76 f8 ff ff       	call   f010234d <boot_alloc>
    memset(pages,0,npages*(sizeof(struct PageInfo)));
f0102ad7:	8b 15 c8 86 11 f0    	mov    0xf01186c8,%edx
f0102add:	83 c4 0c             	add    $0xc,%esp
f0102ae0:	c1 e2 03             	shl    $0x3,%edx
f0102ae3:	52                   	push   %edx
f0102ae4:	6a 00                	push   $0x0
f0102ae6:	50                   	push   %eax
	// each physical page, there is a corresponding struct PageInfo in this
	// array.  'npages' is the number of physical pages in memory.  Use memset
	// to initialize all fields of each struct PageInfo to 0.
	// Your code goes here:
    /* TODO */
    pages = (struct PageInfo *)boot_alloc(sizeof(struct PageInfo)*npages);
f0102ae7:	a3 d4 86 11 f0       	mov    %eax,0xf01186d4
    memset(pages,0,npages*(sizeof(struct PageInfo)));
f0102aec:	e8 de d6 ff ff       	call   f01001cf <memset>
	// Now that we've allocated the initial kernel data structures, we set
	// up the list of free physical pages. Once we've done so, all further
	// memory management will go through the page_* functions. In
	// particular, we can now map memory using boot_map_region
	// or page_insert
	page_init();
f0102af1:	e8 c6 fb ff ff       	call   f01026bc <page_init>

	check_page_free_list(1);
f0102af6:	b8 01 00 00 00       	mov    $0x1,%eax
f0102afb:	e8 42 f9 ff ff       	call   f0102442 <check_page_free_list>
	int nfree;
	struct PageInfo *fl;
	char *c;
	int i;

	if (!pages)
f0102b00:	83 c4 10             	add    $0x10,%esp
f0102b03:	83 3d d4 86 11 f0 00 	cmpl   $0x0,0xf01186d4
f0102b0a:	75 15                	jne    f0102b21 <mem_init+0x10f>
		panic("'pages' is a null pointer!");
f0102b0c:	51                   	push   %ecx
f0102b0d:	68 37 6d 10 f0       	push   $0xf0106d37
f0102b12:	68 2c 03 00 00       	push   $0x32c
f0102b17:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102b1c:	e8 33 17 00 00       	call   f0104254 <_panic>

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0102b21:	a1 1c 5e 11 f0       	mov    0xf0115e1c,%eax
f0102b26:	31 f6                	xor    %esi,%esi
f0102b28:	eb 03                	jmp    f0102b2d <mem_init+0x11b>
f0102b2a:	8b 00                	mov    (%eax),%eax
		++nfree;
f0102b2c:	46                   	inc    %esi

	if (!pages)
		panic("'pages' is a null pointer!");

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0102b2d:	85 c0                	test   %eax,%eax
f0102b2f:	75 f9                	jne    f0102b2a <mem_init+0x118>
		++nfree;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102b31:	83 ec 0c             	sub    $0xc,%esp
f0102b34:	6a 00                	push   $0x0
f0102b36:	e8 0e fc ff ff       	call   f0102749 <page_alloc>
f0102b3b:	89 44 24 18          	mov    %eax,0x18(%esp)
f0102b3f:	83 c4 10             	add    $0x10,%esp
f0102b42:	85 c0                	test   %eax,%eax
f0102b44:	75 19                	jne    f0102b5f <mem_init+0x14d>
f0102b46:	68 52 6d 10 f0       	push   $0xf0106d52
f0102b4b:	68 76 6b 10 f0       	push   $0xf0106b76
f0102b50:	68 34 03 00 00       	push   $0x334
f0102b55:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102b5a:	e8 f5 16 00 00       	call   f0104254 <_panic>
	assert((pp1 = page_alloc(0)));
f0102b5f:	83 ec 0c             	sub    $0xc,%esp
f0102b62:	6a 00                	push   $0x0
f0102b64:	e8 e0 fb ff ff       	call   f0102749 <page_alloc>
f0102b69:	83 c4 10             	add    $0x10,%esp
f0102b6c:	85 c0                	test   %eax,%eax
f0102b6e:	89 c7                	mov    %eax,%edi
f0102b70:	75 19                	jne    f0102b8b <mem_init+0x179>
f0102b72:	68 68 6d 10 f0       	push   $0xf0106d68
f0102b77:	68 76 6b 10 f0       	push   $0xf0106b76
f0102b7c:	68 35 03 00 00       	push   $0x335
f0102b81:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102b86:	e8 c9 16 00 00       	call   f0104254 <_panic>
	assert((pp2 = page_alloc(0)));
f0102b8b:	83 ec 0c             	sub    $0xc,%esp
f0102b8e:	6a 00                	push   $0x0
f0102b90:	e8 b4 fb ff ff       	call   f0102749 <page_alloc>
f0102b95:	83 c4 10             	add    $0x10,%esp
f0102b98:	85 c0                	test   %eax,%eax
f0102b9a:	89 c3                	mov    %eax,%ebx
f0102b9c:	75 19                	jne    f0102bb7 <mem_init+0x1a5>
f0102b9e:	68 7e 6d 10 f0       	push   $0xf0106d7e
f0102ba3:	68 76 6b 10 f0       	push   $0xf0106b76
f0102ba8:	68 36 03 00 00       	push   $0x336
f0102bad:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102bb2:	e8 9d 16 00 00       	call   f0104254 <_panic>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0102bb7:	3b 7c 24 08          	cmp    0x8(%esp),%edi
f0102bbb:	75 19                	jne    f0102bd6 <mem_init+0x1c4>
f0102bbd:	68 94 6d 10 f0       	push   $0xf0106d94
f0102bc2:	68 76 6b 10 f0       	push   $0xf0106b76
f0102bc7:	68 39 03 00 00       	push   $0x339
f0102bcc:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102bd1:	e8 7e 16 00 00       	call   f0104254 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102bd6:	39 f8                	cmp    %edi,%eax
f0102bd8:	74 06                	je     f0102be0 <mem_init+0x1ce>
f0102bda:	3b 44 24 08          	cmp    0x8(%esp),%eax
f0102bde:	75 19                	jne    f0102bf9 <mem_init+0x1e7>
f0102be0:	68 a6 6d 10 f0       	push   $0xf0106da6
f0102be5:	68 76 6b 10 f0       	push   $0xf0106b76
f0102bea:	68 3a 03 00 00       	push   $0x33a
f0102bef:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102bf4:	e8 5b 16 00 00       	call   f0104254 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f0102bf9:	8b 44 24 08          	mov    0x8(%esp),%eax
f0102bfd:	e8 3e f7 ff ff       	call   f0102340 <page2pa>
f0102c02:	8b 2d c8 86 11 f0    	mov    0xf01186c8,%ebp
f0102c08:	c1 e5 0c             	shl    $0xc,%ebp
f0102c0b:	39 e8                	cmp    %ebp,%eax
f0102c0d:	72 19                	jb     f0102c28 <mem_init+0x216>
f0102c0f:	68 c6 6d 10 f0       	push   $0xf0106dc6
f0102c14:	68 76 6b 10 f0       	push   $0xf0106b76
f0102c19:	68 3b 03 00 00       	push   $0x33b
f0102c1e:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102c23:	e8 2c 16 00 00       	call   f0104254 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f0102c28:	89 f8                	mov    %edi,%eax
f0102c2a:	e8 11 f7 ff ff       	call   f0102340 <page2pa>
f0102c2f:	39 e8                	cmp    %ebp,%eax
f0102c31:	72 19                	jb     f0102c4c <mem_init+0x23a>
f0102c33:	68 e3 6d 10 f0       	push   $0xf0106de3
f0102c38:	68 76 6b 10 f0       	push   $0xf0106b76
f0102c3d:	68 3c 03 00 00       	push   $0x33c
f0102c42:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102c47:	e8 08 16 00 00       	call   f0104254 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0102c4c:	89 d8                	mov    %ebx,%eax
f0102c4e:	e8 ed f6 ff ff       	call   f0102340 <page2pa>
f0102c53:	39 e8                	cmp    %ebp,%eax
f0102c55:	72 19                	jb     f0102c70 <mem_init+0x25e>
f0102c57:	68 00 6e 10 f0       	push   $0xf0106e00
f0102c5c:	68 76 6b 10 f0       	push   $0xf0106b76
f0102c61:	68 3d 03 00 00       	push   $0x33d
f0102c66:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102c6b:	e8 e4 15 00 00       	call   f0104254 <_panic>
	// temporarily steal the rest of the free pages
	fl = page_free_list;
	page_free_list = 0;

	// should be no free memory
	assert(!page_alloc(0));
f0102c70:	83 ec 0c             	sub    $0xc,%esp
	assert(page2pa(pp0) < npages*PGSIZE);
	assert(page2pa(pp1) < npages*PGSIZE);
	assert(page2pa(pp2) < npages*PGSIZE);

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0102c73:	8b 2d 1c 5e 11 f0    	mov    0xf0115e1c,%ebp
	page_free_list = 0;

	// should be no free memory
	assert(!page_alloc(0));
f0102c79:	6a 00                	push   $0x0
	assert(page2pa(pp1) < npages*PGSIZE);
	assert(page2pa(pp2) < npages*PGSIZE);

	// temporarily steal the rest of the free pages
	fl = page_free_list;
	page_free_list = 0;
f0102c7b:	c7 05 1c 5e 11 f0 00 	movl   $0x0,0xf0115e1c
f0102c82:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0102c85:	e8 bf fa ff ff       	call   f0102749 <page_alloc>
f0102c8a:	83 c4 10             	add    $0x10,%esp
f0102c8d:	85 c0                	test   %eax,%eax
f0102c8f:	74 19                	je     f0102caa <mem_init+0x298>
f0102c91:	68 1d 6e 10 f0       	push   $0xf0106e1d
f0102c96:	68 76 6b 10 f0       	push   $0xf0106b76
f0102c9b:	68 44 03 00 00       	push   $0x344
f0102ca0:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102ca5:	e8 aa 15 00 00       	call   f0104254 <_panic>

	// free and re-allocate?
	page_free(pp0);
f0102caa:	83 ec 0c             	sub    $0xc,%esp
f0102cad:	ff 74 24 14          	pushl  0x14(%esp)
f0102cb1:	e8 d4 fa ff ff       	call   f010278a <page_free>
	page_free(pp1);
f0102cb6:	89 3c 24             	mov    %edi,(%esp)
f0102cb9:	e8 cc fa ff ff       	call   f010278a <page_free>
	page_free(pp2);
f0102cbe:	89 1c 24             	mov    %ebx,(%esp)
f0102cc1:	e8 c4 fa ff ff       	call   f010278a <page_free>
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102cc6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102ccd:	e8 77 fa ff ff       	call   f0102749 <page_alloc>
f0102cd2:	83 c4 10             	add    $0x10,%esp
f0102cd5:	85 c0                	test   %eax,%eax
f0102cd7:	89 c3                	mov    %eax,%ebx
f0102cd9:	75 19                	jne    f0102cf4 <mem_init+0x2e2>
f0102cdb:	68 52 6d 10 f0       	push   $0xf0106d52
f0102ce0:	68 76 6b 10 f0       	push   $0xf0106b76
f0102ce5:	68 4b 03 00 00       	push   $0x34b
f0102cea:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102cef:	e8 60 15 00 00       	call   f0104254 <_panic>
	assert((pp1 = page_alloc(0)));
f0102cf4:	83 ec 0c             	sub    $0xc,%esp
f0102cf7:	6a 00                	push   $0x0
f0102cf9:	e8 4b fa ff ff       	call   f0102749 <page_alloc>
f0102cfe:	89 44 24 18          	mov    %eax,0x18(%esp)
f0102d02:	83 c4 10             	add    $0x10,%esp
f0102d05:	85 c0                	test   %eax,%eax
f0102d07:	75 19                	jne    f0102d22 <mem_init+0x310>
f0102d09:	68 68 6d 10 f0       	push   $0xf0106d68
f0102d0e:	68 76 6b 10 f0       	push   $0xf0106b76
f0102d13:	68 4c 03 00 00       	push   $0x34c
f0102d18:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102d1d:	e8 32 15 00 00       	call   f0104254 <_panic>
	assert((pp2 = page_alloc(0)));
f0102d22:	83 ec 0c             	sub    $0xc,%esp
f0102d25:	6a 00                	push   $0x0
f0102d27:	e8 1d fa ff ff       	call   f0102749 <page_alloc>
f0102d2c:	83 c4 10             	add    $0x10,%esp
f0102d2f:	85 c0                	test   %eax,%eax
f0102d31:	89 c7                	mov    %eax,%edi
f0102d33:	75 19                	jne    f0102d4e <mem_init+0x33c>
f0102d35:	68 7e 6d 10 f0       	push   $0xf0106d7e
f0102d3a:	68 76 6b 10 f0       	push   $0xf0106b76
f0102d3f:	68 4d 03 00 00       	push   $0x34d
f0102d44:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102d49:	e8 06 15 00 00       	call   f0104254 <_panic>
	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0102d4e:	39 5c 24 08          	cmp    %ebx,0x8(%esp)
f0102d52:	75 19                	jne    f0102d6d <mem_init+0x35b>
f0102d54:	68 94 6d 10 f0       	push   $0xf0106d94
f0102d59:	68 76 6b 10 f0       	push   $0xf0106b76
f0102d5e:	68 4f 03 00 00       	push   $0x34f
f0102d63:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102d68:	e8 e7 14 00 00       	call   f0104254 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102d6d:	3b 44 24 08          	cmp    0x8(%esp),%eax
f0102d71:	74 04                	je     f0102d77 <mem_init+0x365>
f0102d73:	39 d8                	cmp    %ebx,%eax
f0102d75:	75 19                	jne    f0102d90 <mem_init+0x37e>
f0102d77:	68 a6 6d 10 f0       	push   $0xf0106da6
f0102d7c:	68 76 6b 10 f0       	push   $0xf0106b76
f0102d81:	68 50 03 00 00       	push   $0x350
f0102d86:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102d8b:	e8 c4 14 00 00       	call   f0104254 <_panic>
	assert(!page_alloc(0));
f0102d90:	83 ec 0c             	sub    $0xc,%esp
f0102d93:	6a 00                	push   $0x0
f0102d95:	e8 af f9 ff ff       	call   f0102749 <page_alloc>
f0102d9a:	83 c4 10             	add    $0x10,%esp
f0102d9d:	85 c0                	test   %eax,%eax
f0102d9f:	74 19                	je     f0102dba <mem_init+0x3a8>
f0102da1:	68 1d 6e 10 f0       	push   $0xf0106e1d
f0102da6:	68 76 6b 10 f0       	push   $0xf0106b76
f0102dab:	68 51 03 00 00       	push   $0x351
f0102db0:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102db5:	e8 9a 14 00 00       	call   f0104254 <_panic>

	// test flags
	memset(page2kva(pp0), 1, PGSIZE);
f0102dba:	89 d8                	mov    %ebx,%eax
f0102dbc:	e8 f0 f5 ff ff       	call   f01023b1 <page2kva>
f0102dc1:	52                   	push   %edx
f0102dc2:	68 00 10 00 00       	push   $0x1000
f0102dc7:	6a 01                	push   $0x1
f0102dc9:	50                   	push   %eax
f0102dca:	e8 00 d4 ff ff       	call   f01001cf <memset>
	page_free(pp0);
f0102dcf:	89 1c 24             	mov    %ebx,(%esp)
f0102dd2:	e8 b3 f9 ff ff       	call   f010278a <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0102dd7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0102dde:	e8 66 f9 ff ff       	call   f0102749 <page_alloc>
f0102de3:	83 c4 10             	add    $0x10,%esp
f0102de6:	85 c0                	test   %eax,%eax
f0102de8:	75 19                	jne    f0102e03 <mem_init+0x3f1>
f0102dea:	68 2c 6e 10 f0       	push   $0xf0106e2c
f0102def:	68 76 6b 10 f0       	push   $0xf0106b76
f0102df4:	68 56 03 00 00       	push   $0x356
f0102df9:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102dfe:	e8 51 14 00 00       	call   f0104254 <_panic>
	assert(pp && pp0 == pp);
f0102e03:	39 c3                	cmp    %eax,%ebx
f0102e05:	74 19                	je     f0102e20 <mem_init+0x40e>
f0102e07:	68 4a 6e 10 f0       	push   $0xf0106e4a
f0102e0c:	68 76 6b 10 f0       	push   $0xf0106b76
f0102e11:	68 57 03 00 00       	push   $0x357
f0102e16:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102e1b:	e8 34 14 00 00       	call   f0104254 <_panic>
	c = page2kva(pp);
f0102e20:	89 d8                	mov    %ebx,%eax
f0102e22:	e8 8a f5 ff ff       	call   f01023b1 <page2kva>
	for (i = 0; i < PGSIZE; i++)
f0102e27:	31 d2                	xor    %edx,%edx
		assert(c[i] == 0);
f0102e29:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
f0102e2d:	74 19                	je     f0102e48 <mem_init+0x436>
f0102e2f:	68 5a 6e 10 f0       	push   $0xf0106e5a
f0102e34:	68 76 6b 10 f0       	push   $0xf0106b76
f0102e39:	68 5a 03 00 00       	push   $0x35a
f0102e3e:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102e43:	e8 0c 14 00 00       	call   f0104254 <_panic>
	memset(page2kva(pp0), 1, PGSIZE);
	page_free(pp0);
	assert((pp = page_alloc(ALLOC_ZERO)));
	assert(pp && pp0 == pp);
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
f0102e48:	42                   	inc    %edx
f0102e49:	81 fa 00 10 00 00    	cmp    $0x1000,%edx
f0102e4f:	75 d8                	jne    f0102e29 <mem_init+0x417>

	// give free list back
	page_free_list = fl;

	// free the pages we took
	page_free(pp0);
f0102e51:	83 ec 0c             	sub    $0xc,%esp
f0102e54:	53                   	push   %ebx
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
		assert(c[i] == 0);

	// give free list back
	page_free_list = fl;
f0102e55:	89 2d 1c 5e 11 f0    	mov    %ebp,0xf0115e1c

	// free the pages we took
	page_free(pp0);
f0102e5b:	e8 2a f9 ff ff       	call   f010278a <page_free>
	page_free(pp1);
f0102e60:	5b                   	pop    %ebx
f0102e61:	ff 74 24 14          	pushl  0x14(%esp)
f0102e65:	e8 20 f9 ff ff       	call   f010278a <page_free>
	page_free(pp2);
f0102e6a:	89 3c 24             	mov    %edi,(%esp)
f0102e6d:	e8 18 f9 ff ff       	call   f010278a <page_free>

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0102e72:	a1 1c 5e 11 f0       	mov    0xf0115e1c,%eax
f0102e77:	83 c4 10             	add    $0x10,%esp
f0102e7a:	eb 03                	jmp    f0102e7f <mem_init+0x46d>
f0102e7c:	8b 00                	mov    (%eax),%eax
		--nfree;
f0102e7e:	4e                   	dec    %esi
	page_free(pp0);
	page_free(pp1);
	page_free(pp2);

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0102e7f:	85 c0                	test   %eax,%eax
f0102e81:	75 f9                	jne    f0102e7c <mem_init+0x46a>
		--nfree;
	assert(nfree == 0);
f0102e83:	85 f6                	test   %esi,%esi
f0102e85:	74 19                	je     f0102ea0 <mem_init+0x48e>
f0102e87:	68 64 6e 10 f0       	push   $0xf0106e64
f0102e8c:	68 76 6b 10 f0       	push   $0xf0106b76
f0102e91:	68 67 03 00 00       	push   $0x367
f0102e96:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102e9b:	e8 b4 13 00 00       	call   f0104254 <_panic>

	printk("check_page_alloc() succeeded!\n");
f0102ea0:	83 ec 0c             	sub    $0xc,%esp
f0102ea3:	68 6f 6e 10 f0       	push   $0xf0106e6f
f0102ea8:	e8 7b f4 ff ff       	call   f0102328 <printk>
	void *va;
	int i;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102ead:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102eb4:	e8 90 f8 ff ff       	call   f0102749 <page_alloc>
f0102eb9:	83 c4 10             	add    $0x10,%esp
f0102ebc:	85 c0                	test   %eax,%eax
f0102ebe:	89 c6                	mov    %eax,%esi
f0102ec0:	75 19                	jne    f0102edb <mem_init+0x4c9>
f0102ec2:	68 52 6d 10 f0       	push   $0xf0106d52
f0102ec7:	68 76 6b 10 f0       	push   $0xf0106b76
f0102ecc:	68 cb 03 00 00       	push   $0x3cb
f0102ed1:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102ed6:	e8 79 13 00 00       	call   f0104254 <_panic>
	assert((pp1 = page_alloc(0)));
f0102edb:	83 ec 0c             	sub    $0xc,%esp
f0102ede:	6a 00                	push   $0x0
f0102ee0:	e8 64 f8 ff ff       	call   f0102749 <page_alloc>
f0102ee5:	83 c4 10             	add    $0x10,%esp
f0102ee8:	85 c0                	test   %eax,%eax
f0102eea:	89 c3                	mov    %eax,%ebx
f0102eec:	75 19                	jne    f0102f07 <mem_init+0x4f5>
f0102eee:	68 68 6d 10 f0       	push   $0xf0106d68
f0102ef3:	68 76 6b 10 f0       	push   $0xf0106b76
f0102ef8:	68 cc 03 00 00       	push   $0x3cc
f0102efd:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102f02:	e8 4d 13 00 00       	call   f0104254 <_panic>
	assert((pp2 = page_alloc(0)));
f0102f07:	83 ec 0c             	sub    $0xc,%esp
f0102f0a:	6a 00                	push   $0x0
f0102f0c:	e8 38 f8 ff ff       	call   f0102749 <page_alloc>
f0102f11:	83 c4 10             	add    $0x10,%esp
f0102f14:	85 c0                	test   %eax,%eax
f0102f16:	89 c7                	mov    %eax,%edi
f0102f18:	75 19                	jne    f0102f33 <mem_init+0x521>
f0102f1a:	68 7e 6d 10 f0       	push   $0xf0106d7e
f0102f1f:	68 76 6b 10 f0       	push   $0xf0106b76
f0102f24:	68 cd 03 00 00       	push   $0x3cd
f0102f29:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102f2e:	e8 21 13 00 00       	call   f0104254 <_panic>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0102f33:	39 f3                	cmp    %esi,%ebx
f0102f35:	75 19                	jne    f0102f50 <mem_init+0x53e>
f0102f37:	68 94 6d 10 f0       	push   $0xf0106d94
f0102f3c:	68 76 6b 10 f0       	push   $0xf0106b76
f0102f41:	68 d0 03 00 00       	push   $0x3d0
f0102f46:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102f4b:	e8 04 13 00 00       	call   f0104254 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102f50:	39 d8                	cmp    %ebx,%eax
f0102f52:	74 04                	je     f0102f58 <mem_init+0x546>
f0102f54:	39 f0                	cmp    %esi,%eax
f0102f56:	75 19                	jne    f0102f71 <mem_init+0x55f>
f0102f58:	68 a6 6d 10 f0       	push   $0xf0106da6
f0102f5d:	68 76 6b 10 f0       	push   $0xf0106b76
f0102f62:	68 d1 03 00 00       	push   $0x3d1
f0102f67:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102f6c:	e8 e3 12 00 00       	call   f0104254 <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0102f71:	a1 1c 5e 11 f0       	mov    0xf0115e1c,%eax
	page_free_list = 0;
f0102f76:	c7 05 1c 5e 11 f0 00 	movl   $0x0,0xf0115e1c
f0102f7d:	00 00 00 
	assert(pp0);
	assert(pp1 && pp1 != pp0);
	assert(pp2 && pp2 != pp1 && pp2 != pp0);

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0102f80:	89 44 24 08          	mov    %eax,0x8(%esp)
	page_free_list = 0;

	// should be no free memory
	assert(!page_alloc(0));
f0102f84:	83 ec 0c             	sub    $0xc,%esp
f0102f87:	6a 00                	push   $0x0
f0102f89:	e8 bb f7 ff ff       	call   f0102749 <page_alloc>
f0102f8e:	83 c4 10             	add    $0x10,%esp
f0102f91:	85 c0                	test   %eax,%eax
f0102f93:	74 19                	je     f0102fae <mem_init+0x59c>
f0102f95:	68 1d 6e 10 f0       	push   $0xf0106e1d
f0102f9a:	68 76 6b 10 f0       	push   $0xf0106b76
f0102f9f:	68 d8 03 00 00       	push   $0x3d8
f0102fa4:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102fa9:	e8 a6 12 00 00       	call   f0104254 <_panic>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0102fae:	51                   	push   %ecx
f0102faf:	8d 44 24 20          	lea    0x20(%esp),%eax
f0102fb3:	50                   	push   %eax
f0102fb4:	6a 00                	push   $0x0
f0102fb6:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f0102fbc:	e8 da f8 ff ff       	call   f010289b <page_lookup>
f0102fc1:	83 c4 10             	add    $0x10,%esp
f0102fc4:	85 c0                	test   %eax,%eax
f0102fc6:	74 19                	je     f0102fe1 <mem_init+0x5cf>
f0102fc8:	68 8e 6e 10 f0       	push   $0xf0106e8e
f0102fcd:	68 76 6b 10 f0       	push   $0xf0106b76
f0102fd2:	68 db 03 00 00       	push   $0x3db
f0102fd7:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0102fdc:	e8 73 12 00 00       	call   f0104254 <_panic>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102fe1:	6a 02                	push   $0x2
f0102fe3:	6a 00                	push   $0x0
f0102fe5:	53                   	push   %ebx
f0102fe6:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f0102fec:	e8 28 f9 ff ff       	call   f0102919 <page_insert>
f0102ff1:	83 c4 10             	add    $0x10,%esp
f0102ff4:	85 c0                	test   %eax,%eax
f0102ff6:	78 19                	js     f0103011 <mem_init+0x5ff>
f0102ff8:	68 c3 6e 10 f0       	push   $0xf0106ec3
f0102ffd:	68 76 6b 10 f0       	push   $0xf0106b76
f0103002:	68 de 03 00 00       	push   $0x3de
f0103007:	68 1a 6b 10 f0       	push   $0xf0106b1a
f010300c:	e8 43 12 00 00       	call   f0104254 <_panic>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0103011:	83 ec 0c             	sub    $0xc,%esp
f0103014:	56                   	push   %esi
f0103015:	e8 70 f7 ff ff       	call   f010278a <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f010301a:	6a 02                	push   $0x2
f010301c:	6a 00                	push   $0x0
f010301e:	53                   	push   %ebx
f010301f:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f0103025:	e8 ef f8 ff ff       	call   f0102919 <page_insert>
f010302a:	83 c4 20             	add    $0x20,%esp
f010302d:	85 c0                	test   %eax,%eax
f010302f:	74 19                	je     f010304a <mem_init+0x638>
f0103031:	68 f0 6e 10 f0       	push   $0xf0106ef0
f0103036:	68 76 6b 10 f0       	push   $0xf0106b76
f010303b:	68 e2 03 00 00       	push   $0x3e2
f0103040:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103045:	e8 0a 12 00 00       	call   f0104254 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010304a:	8b 2d cc 86 11 f0    	mov    0xf01186cc,%ebp
f0103050:	89 f0                	mov    %esi,%eax
f0103052:	e8 e9 f2 ff ff       	call   f0102340 <page2pa>
f0103057:	8b 55 00             	mov    0x0(%ebp),%edx
f010305a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0103060:	39 c2                	cmp    %eax,%edx
f0103062:	74 19                	je     f010307d <mem_init+0x66b>
f0103064:	68 1e 6f 10 f0       	push   $0xf0106f1e
f0103069:	68 76 6b 10 f0       	push   $0xf0106b76
f010306e:	68 e3 03 00 00       	push   $0x3e3
f0103073:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103078:	e8 d7 11 00 00       	call   f0104254 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f010307d:	31 d2                	xor    %edx,%edx
f010307f:	89 e8                	mov    %ebp,%eax
f0103081:	e8 44 f3 ff ff       	call   f01023ca <check_va2pa>
f0103086:	89 c5                	mov    %eax,%ebp
f0103088:	89 d8                	mov    %ebx,%eax
f010308a:	e8 b1 f2 ff ff       	call   f0102340 <page2pa>
f010308f:	39 c5                	cmp    %eax,%ebp
f0103091:	74 19                	je     f01030ac <mem_init+0x69a>
f0103093:	68 46 6f 10 f0       	push   $0xf0106f46
f0103098:	68 76 6b 10 f0       	push   $0xf0106b76
f010309d:	68 e4 03 00 00       	push   $0x3e4
f01030a2:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01030a7:	e8 a8 11 00 00       	call   f0104254 <_panic>
	assert(pp1->pp_ref == 1);
f01030ac:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01030b1:	74 19                	je     f01030cc <mem_init+0x6ba>
f01030b3:	68 73 6f 10 f0       	push   $0xf0106f73
f01030b8:	68 76 6b 10 f0       	push   $0xf0106b76
f01030bd:	68 e5 03 00 00       	push   $0x3e5
f01030c2:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01030c7:	e8 88 11 00 00       	call   f0104254 <_panic>
	assert(pp0->pp_ref == 1);
f01030cc:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f01030d1:	74 19                	je     f01030ec <mem_init+0x6da>
f01030d3:	68 84 6f 10 f0       	push   $0xf0106f84
f01030d8:	68 76 6b 10 f0       	push   $0xf0106b76
f01030dd:	68 e6 03 00 00       	push   $0x3e6
f01030e2:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01030e7:	e8 68 11 00 00       	call   f0104254 <_panic>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f01030ec:	6a 02                	push   $0x2
f01030ee:	68 00 10 00 00       	push   $0x1000
f01030f3:	57                   	push   %edi
f01030f4:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f01030fa:	e8 1a f8 ff ff       	call   f0102919 <page_insert>
f01030ff:	83 c4 10             	add    $0x10,%esp
f0103102:	85 c0                	test   %eax,%eax
f0103104:	74 19                	je     f010311f <mem_init+0x70d>
f0103106:	68 95 6f 10 f0       	push   $0xf0106f95
f010310b:	68 76 6b 10 f0       	push   $0xf0106b76
f0103110:	68 e9 03 00 00       	push   $0x3e9
f0103115:	68 1a 6b 10 f0       	push   $0xf0106b1a
f010311a:	e8 35 11 00 00       	call   f0104254 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010311f:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f0103124:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103129:	e8 9c f2 ff ff       	call   f01023ca <check_va2pa>
f010312e:	89 c5                	mov    %eax,%ebp
f0103130:	89 f8                	mov    %edi,%eax
f0103132:	e8 09 f2 ff ff       	call   f0102340 <page2pa>
f0103137:	39 c5                	cmp    %eax,%ebp
f0103139:	74 19                	je     f0103154 <mem_init+0x742>
f010313b:	68 ce 6f 10 f0       	push   $0xf0106fce
f0103140:	68 76 6b 10 f0       	push   $0xf0106b76
f0103145:	68 ea 03 00 00       	push   $0x3ea
f010314a:	68 1a 6b 10 f0       	push   $0xf0106b1a
f010314f:	e8 00 11 00 00       	call   f0104254 <_panic>
	assert(pp2->pp_ref == 1);
f0103154:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0103159:	74 19                	je     f0103174 <mem_init+0x762>
f010315b:	68 fe 6f 10 f0       	push   $0xf0106ffe
f0103160:	68 76 6b 10 f0       	push   $0xf0106b76
f0103165:	68 eb 03 00 00       	push   $0x3eb
f010316a:	68 1a 6b 10 f0       	push   $0xf0106b1a
f010316f:	e8 e0 10 00 00       	call   f0104254 <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f0103174:	83 ec 0c             	sub    $0xc,%esp
f0103177:	6a 00                	push   $0x0
f0103179:	e8 cb f5 ff ff       	call   f0102749 <page_alloc>
f010317e:	83 c4 10             	add    $0x10,%esp
f0103181:	85 c0                	test   %eax,%eax
f0103183:	74 19                	je     f010319e <mem_init+0x78c>
f0103185:	68 1d 6e 10 f0       	push   $0xf0106e1d
f010318a:	68 76 6b 10 f0       	push   $0xf0106b76
f010318f:	68 ee 03 00 00       	push   $0x3ee
f0103194:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103199:	e8 b6 10 00 00       	call   f0104254 <_panic>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010319e:	6a 02                	push   $0x2
f01031a0:	68 00 10 00 00       	push   $0x1000
f01031a5:	57                   	push   %edi
f01031a6:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f01031ac:	e8 68 f7 ff ff       	call   f0102919 <page_insert>
f01031b1:	83 c4 10             	add    $0x10,%esp
f01031b4:	85 c0                	test   %eax,%eax
f01031b6:	74 19                	je     f01031d1 <mem_init+0x7bf>
f01031b8:	68 95 6f 10 f0       	push   $0xf0106f95
f01031bd:	68 76 6b 10 f0       	push   $0xf0106b76
f01031c2:	68 f1 03 00 00       	push   $0x3f1
f01031c7:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01031cc:	e8 83 10 00 00       	call   f0104254 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01031d1:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f01031d6:	ba 00 10 00 00       	mov    $0x1000,%edx
f01031db:	e8 ea f1 ff ff       	call   f01023ca <check_va2pa>
f01031e0:	89 c5                	mov    %eax,%ebp
f01031e2:	89 f8                	mov    %edi,%eax
f01031e4:	e8 57 f1 ff ff       	call   f0102340 <page2pa>
f01031e9:	39 c5                	cmp    %eax,%ebp
f01031eb:	74 19                	je     f0103206 <mem_init+0x7f4>
f01031ed:	68 ce 6f 10 f0       	push   $0xf0106fce
f01031f2:	68 76 6b 10 f0       	push   $0xf0106b76
f01031f7:	68 f2 03 00 00       	push   $0x3f2
f01031fc:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103201:	e8 4e 10 00 00       	call   f0104254 <_panic>
	assert(pp2->pp_ref == 1);
f0103206:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f010320b:	74 19                	je     f0103226 <mem_init+0x814>
f010320d:	68 fe 6f 10 f0       	push   $0xf0106ffe
f0103212:	68 76 6b 10 f0       	push   $0xf0106b76
f0103217:	68 f3 03 00 00       	push   $0x3f3
f010321c:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103221:	e8 2e 10 00 00       	call   f0104254 <_panic>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0103226:	83 ec 0c             	sub    $0xc,%esp
f0103229:	6a 00                	push   $0x0
f010322b:	e8 19 f5 ff ff       	call   f0102749 <page_alloc>
f0103230:	83 c4 10             	add    $0x10,%esp
f0103233:	85 c0                	test   %eax,%eax
f0103235:	74 19                	je     f0103250 <mem_init+0x83e>
f0103237:	68 1d 6e 10 f0       	push   $0xf0106e1d
f010323c:	68 76 6b 10 f0       	push   $0xf0106b76
f0103241:	68 f7 03 00 00       	push   $0x3f7
f0103246:	68 1a 6b 10 f0       	push   $0xf0106b1a
f010324b:	e8 04 10 00 00       	call   f0104254 <_panic>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0103250:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f0103255:	ba fa 03 00 00       	mov    $0x3fa,%edx
f010325a:	8b 08                	mov    (%eax),%ecx
f010325c:	b8 1a 6b 10 f0       	mov    $0xf0106b1a,%eax
f0103261:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0103267:	e8 1c f1 ff ff       	call   f0102388 <_kaddr>
f010326c:	89 44 24 1c          	mov    %eax,0x1c(%esp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0103270:	52                   	push   %edx
f0103271:	6a 00                	push   $0x0
f0103273:	68 00 10 00 00       	push   $0x1000
f0103278:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f010327e:	e8 60 f5 ff ff       	call   f01027e3 <pgdir_walk>
f0103283:	8b 54 24 2c          	mov    0x2c(%esp),%edx
f0103287:	83 c4 10             	add    $0x10,%esp
f010328a:	83 c2 04             	add    $0x4,%edx
f010328d:	39 d0                	cmp    %edx,%eax
f010328f:	74 19                	je     f01032aa <mem_init+0x898>
f0103291:	68 0f 70 10 f0       	push   $0xf010700f
f0103296:	68 76 6b 10 f0       	push   $0xf0106b76
f010329b:	68 fb 03 00 00       	push   $0x3fb
f01032a0:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01032a5:	e8 aa 0f 00 00       	call   f0104254 <_panic>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f01032aa:	6a 06                	push   $0x6
f01032ac:	68 00 10 00 00       	push   $0x1000
f01032b1:	57                   	push   %edi
f01032b2:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f01032b8:	e8 5c f6 ff ff       	call   f0102919 <page_insert>
f01032bd:	83 c4 10             	add    $0x10,%esp
f01032c0:	85 c0                	test   %eax,%eax
f01032c2:	74 19                	je     f01032dd <mem_init+0x8cb>
f01032c4:	68 4c 70 10 f0       	push   $0xf010704c
f01032c9:	68 76 6b 10 f0       	push   $0xf0106b76
f01032ce:	68 fe 03 00 00       	push   $0x3fe
f01032d3:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01032d8:	e8 77 0f 00 00       	call   f0104254 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01032dd:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f01032e2:	ba 00 10 00 00       	mov    $0x1000,%edx
f01032e7:	e8 de f0 ff ff       	call   f01023ca <check_va2pa>
f01032ec:	89 c5                	mov    %eax,%ebp
f01032ee:	89 f8                	mov    %edi,%eax
f01032f0:	e8 4b f0 ff ff       	call   f0102340 <page2pa>
f01032f5:	39 c5                	cmp    %eax,%ebp
f01032f7:	74 19                	je     f0103312 <mem_init+0x900>
f01032f9:	68 ce 6f 10 f0       	push   $0xf0106fce
f01032fe:	68 76 6b 10 f0       	push   $0xf0106b76
f0103303:	68 ff 03 00 00       	push   $0x3ff
f0103308:	68 1a 6b 10 f0       	push   $0xf0106b1a
f010330d:	e8 42 0f 00 00       	call   f0104254 <_panic>
	assert(pp2->pp_ref == 1);
f0103312:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0103317:	74 19                	je     f0103332 <mem_init+0x920>
f0103319:	68 fe 6f 10 f0       	push   $0xf0106ffe
f010331e:	68 76 6b 10 f0       	push   $0xf0106b76
f0103323:	68 00 04 00 00       	push   $0x400
f0103328:	68 1a 6b 10 f0       	push   $0xf0106b1a
f010332d:	e8 22 0f 00 00       	call   f0104254 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0103332:	50                   	push   %eax
f0103333:	6a 00                	push   $0x0
f0103335:	68 00 10 00 00       	push   $0x1000
f010333a:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f0103340:	e8 9e f4 ff ff       	call   f01027e3 <pgdir_walk>
f0103345:	83 c4 10             	add    $0x10,%esp
f0103348:	f6 00 04             	testb  $0x4,(%eax)
f010334b:	75 19                	jne    f0103366 <mem_init+0x954>
f010334d:	68 8b 70 10 f0       	push   $0xf010708b
f0103352:	68 76 6b 10 f0       	push   $0xf0106b76
f0103357:	68 01 04 00 00       	push   $0x401
f010335c:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103361:	e8 ee 0e 00 00       	call   f0104254 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f0103366:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f010336b:	f6 00 04             	testb  $0x4,(%eax)
f010336e:	75 19                	jne    f0103389 <mem_init+0x977>
f0103370:	68 be 70 10 f0       	push   $0xf01070be
f0103375:	68 76 6b 10 f0       	push   $0xf0106b76
f010337a:	68 02 04 00 00       	push   $0x402
f010337f:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103384:	e8 cb 0e 00 00       	call   f0104254 <_panic>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0103389:	6a 02                	push   $0x2
f010338b:	68 00 10 00 00       	push   $0x1000
f0103390:	57                   	push   %edi
f0103391:	50                   	push   %eax
f0103392:	e8 82 f5 ff ff       	call   f0102919 <page_insert>
f0103397:	83 c4 10             	add    $0x10,%esp
f010339a:	85 c0                	test   %eax,%eax
f010339c:	74 19                	je     f01033b7 <mem_init+0x9a5>
f010339e:	68 95 6f 10 f0       	push   $0xf0106f95
f01033a3:	68 76 6b 10 f0       	push   $0xf0106b76
f01033a8:	68 05 04 00 00       	push   $0x405
f01033ad:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01033b2:	e8 9d 0e 00 00       	call   f0104254 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f01033b7:	55                   	push   %ebp
f01033b8:	6a 00                	push   $0x0
f01033ba:	68 00 10 00 00       	push   $0x1000
f01033bf:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f01033c5:	e8 19 f4 ff ff       	call   f01027e3 <pgdir_walk>
f01033ca:	83 c4 10             	add    $0x10,%esp
f01033cd:	f6 00 02             	testb  $0x2,(%eax)
f01033d0:	75 19                	jne    f01033eb <mem_init+0x9d9>
f01033d2:	68 d4 70 10 f0       	push   $0xf01070d4
f01033d7:	68 76 6b 10 f0       	push   $0xf0106b76
f01033dc:	68 06 04 00 00       	push   $0x406
f01033e1:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01033e6:	e8 69 0e 00 00       	call   f0104254 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01033eb:	51                   	push   %ecx
f01033ec:	6a 00                	push   $0x0
f01033ee:	68 00 10 00 00       	push   $0x1000
f01033f3:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f01033f9:	e8 e5 f3 ff ff       	call   f01027e3 <pgdir_walk>
f01033fe:	83 c4 10             	add    $0x10,%esp
f0103401:	f6 00 04             	testb  $0x4,(%eax)
f0103404:	74 19                	je     f010341f <mem_init+0xa0d>
f0103406:	68 07 71 10 f0       	push   $0xf0107107
f010340b:	68 76 6b 10 f0       	push   $0xf0106b76
f0103410:	68 07 04 00 00       	push   $0x407
f0103415:	68 1a 6b 10 f0       	push   $0xf0106b1a
f010341a:	e8 35 0e 00 00       	call   f0104254 <_panic>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f010341f:	6a 02                	push   $0x2
f0103421:	68 00 00 40 00       	push   $0x400000
f0103426:	56                   	push   %esi
f0103427:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f010342d:	e8 e7 f4 ff ff       	call   f0102919 <page_insert>
f0103432:	83 c4 10             	add    $0x10,%esp
f0103435:	85 c0                	test   %eax,%eax
f0103437:	78 19                	js     f0103452 <mem_init+0xa40>
f0103439:	68 3d 71 10 f0       	push   $0xf010713d
f010343e:	68 76 6b 10 f0       	push   $0xf0106b76
f0103443:	68 0a 04 00 00       	push   $0x40a
f0103448:	68 1a 6b 10 f0       	push   $0xf0106b1a
f010344d:	e8 02 0e 00 00       	call   f0104254 <_panic>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0103452:	6a 02                	push   $0x2
f0103454:	68 00 10 00 00       	push   $0x1000
f0103459:	53                   	push   %ebx
f010345a:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f0103460:	e8 b4 f4 ff ff       	call   f0102919 <page_insert>
f0103465:	83 c4 10             	add    $0x10,%esp
f0103468:	85 c0                	test   %eax,%eax
f010346a:	74 19                	je     f0103485 <mem_init+0xa73>
f010346c:	68 75 71 10 f0       	push   $0xf0107175
f0103471:	68 76 6b 10 f0       	push   $0xf0106b76
f0103476:	68 0d 04 00 00       	push   $0x40d
f010347b:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103480:	e8 cf 0d 00 00       	call   f0104254 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0103485:	52                   	push   %edx
f0103486:	6a 00                	push   $0x0
f0103488:	68 00 10 00 00       	push   $0x1000
f010348d:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f0103493:	e8 4b f3 ff ff       	call   f01027e3 <pgdir_walk>
f0103498:	83 c4 10             	add    $0x10,%esp
f010349b:	f6 00 04             	testb  $0x4,(%eax)
f010349e:	74 19                	je     f01034b9 <mem_init+0xaa7>
f01034a0:	68 07 71 10 f0       	push   $0xf0107107
f01034a5:	68 76 6b 10 f0       	push   $0xf0106b76
f01034aa:	68 0e 04 00 00       	push   $0x40e
f01034af:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01034b4:	e8 9b 0d 00 00       	call   f0104254 <_panic>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f01034b9:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f01034be:	31 d2                	xor    %edx,%edx
f01034c0:	e8 05 ef ff ff       	call   f01023ca <check_va2pa>
f01034c5:	89 c5                	mov    %eax,%ebp
f01034c7:	89 d8                	mov    %ebx,%eax
f01034c9:	e8 72 ee ff ff       	call   f0102340 <page2pa>
f01034ce:	39 c5                	cmp    %eax,%ebp
f01034d0:	74 19                	je     f01034eb <mem_init+0xad9>
f01034d2:	68 ae 71 10 f0       	push   $0xf01071ae
f01034d7:	68 76 6b 10 f0       	push   $0xf0106b76
f01034dc:	68 11 04 00 00       	push   $0x411
f01034e1:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01034e6:	e8 69 0d 00 00       	call   f0104254 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01034eb:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f01034f0:	ba 00 10 00 00       	mov    $0x1000,%edx
f01034f5:	e8 d0 ee ff ff       	call   f01023ca <check_va2pa>
f01034fa:	89 c5                	mov    %eax,%ebp
f01034fc:	89 d8                	mov    %ebx,%eax
f01034fe:	e8 3d ee ff ff       	call   f0102340 <page2pa>
f0103503:	39 c5                	cmp    %eax,%ebp
f0103505:	74 19                	je     f0103520 <mem_init+0xb0e>
f0103507:	68 d9 71 10 f0       	push   $0xf01071d9
f010350c:	68 76 6b 10 f0       	push   $0xf0106b76
f0103511:	68 12 04 00 00       	push   $0x412
f0103516:	68 1a 6b 10 f0       	push   $0xf0106b1a
f010351b:	e8 34 0d 00 00       	call   f0104254 <_panic>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0103520:	66 83 7b 04 02       	cmpw   $0x2,0x4(%ebx)
f0103525:	74 19                	je     f0103540 <mem_init+0xb2e>
f0103527:	68 09 72 10 f0       	push   $0xf0107209
f010352c:	68 76 6b 10 f0       	push   $0xf0106b76
f0103531:	68 14 04 00 00       	push   $0x414
f0103536:	68 1a 6b 10 f0       	push   $0xf0106b1a
f010353b:	e8 14 0d 00 00       	call   f0104254 <_panic>
	assert(pp2->pp_ref == 0);
f0103540:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0103545:	74 19                	je     f0103560 <mem_init+0xb4e>
f0103547:	68 1a 72 10 f0       	push   $0xf010721a
f010354c:	68 76 6b 10 f0       	push   $0xf0106b76
f0103551:	68 15 04 00 00       	push   $0x415
f0103556:	68 1a 6b 10 f0       	push   $0xf0106b1a
f010355b:	e8 f4 0c 00 00       	call   f0104254 <_panic>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0103560:	83 ec 0c             	sub    $0xc,%esp
f0103563:	6a 00                	push   $0x0
f0103565:	e8 df f1 ff ff       	call   f0102749 <page_alloc>
f010356a:	83 c4 10             	add    $0x10,%esp
f010356d:	85 c0                	test   %eax,%eax
f010356f:	89 c5                	mov    %eax,%ebp
f0103571:	74 04                	je     f0103577 <mem_init+0xb65>
f0103573:	39 f8                	cmp    %edi,%eax
f0103575:	74 19                	je     f0103590 <mem_init+0xb7e>
f0103577:	68 2b 72 10 f0       	push   $0xf010722b
f010357c:	68 76 6b 10 f0       	push   $0xf0106b76
f0103581:	68 18 04 00 00       	push   $0x418
f0103586:	68 1a 6b 10 f0       	push   $0xf0106b1a
f010358b:	e8 c4 0c 00 00       	call   f0104254 <_panic>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0103590:	50                   	push   %eax
f0103591:	50                   	push   %eax
f0103592:	6a 00                	push   $0x0
f0103594:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f010359a:	e8 3e f3 ff ff       	call   f01028dd <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010359f:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f01035a4:	31 d2                	xor    %edx,%edx
f01035a6:	e8 1f ee ff ff       	call   f01023ca <check_va2pa>
f01035ab:	83 c4 10             	add    $0x10,%esp
f01035ae:	40                   	inc    %eax
f01035af:	74 19                	je     f01035ca <mem_init+0xbb8>
f01035b1:	68 4d 72 10 f0       	push   $0xf010724d
f01035b6:	68 76 6b 10 f0       	push   $0xf0106b76
f01035bb:	68 1c 04 00 00       	push   $0x41c
f01035c0:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01035c5:	e8 8a 0c 00 00       	call   f0104254 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01035ca:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f01035cf:	ba 00 10 00 00       	mov    $0x1000,%edx
f01035d4:	e8 f1 ed ff ff       	call   f01023ca <check_va2pa>
f01035d9:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01035dd:	89 d8                	mov    %ebx,%eax
f01035df:	e8 5c ed ff ff       	call   f0102340 <page2pa>
f01035e4:	39 44 24 0c          	cmp    %eax,0xc(%esp)
f01035e8:	74 19                	je     f0103603 <mem_init+0xbf1>
f01035ea:	68 d9 71 10 f0       	push   $0xf01071d9
f01035ef:	68 76 6b 10 f0       	push   $0xf0106b76
f01035f4:	68 1d 04 00 00       	push   $0x41d
f01035f9:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01035fe:	e8 51 0c 00 00       	call   f0104254 <_panic>
	assert(pp1->pp_ref == 1);
f0103603:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0103608:	74 19                	je     f0103623 <mem_init+0xc11>
f010360a:	68 73 6f 10 f0       	push   $0xf0106f73
f010360f:	68 76 6b 10 f0       	push   $0xf0106b76
f0103614:	68 1e 04 00 00       	push   $0x41e
f0103619:	68 1a 6b 10 f0       	push   $0xf0106b1a
f010361e:	e8 31 0c 00 00       	call   f0104254 <_panic>
	assert(pp2->pp_ref == 0);
f0103623:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0103628:	74 19                	je     f0103643 <mem_init+0xc31>
f010362a:	68 1a 72 10 f0       	push   $0xf010721a
f010362f:	68 76 6b 10 f0       	push   $0xf0106b76
f0103634:	68 1f 04 00 00       	push   $0x41f
f0103639:	68 1a 6b 10 f0       	push   $0xf0106b1a
f010363e:	e8 11 0c 00 00       	call   f0104254 <_panic>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0103643:	6a 00                	push   $0x0
f0103645:	68 00 10 00 00       	push   $0x1000
f010364a:	53                   	push   %ebx
f010364b:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f0103651:	e8 c3 f2 ff ff       	call   f0102919 <page_insert>
f0103656:	83 c4 10             	add    $0x10,%esp
f0103659:	85 c0                	test   %eax,%eax
f010365b:	74 19                	je     f0103676 <mem_init+0xc64>
f010365d:	68 70 72 10 f0       	push   $0xf0107270
f0103662:	68 76 6b 10 f0       	push   $0xf0106b76
f0103667:	68 22 04 00 00       	push   $0x422
f010366c:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103671:	e8 de 0b 00 00       	call   f0104254 <_panic>
	assert(pp1->pp_ref);
f0103676:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f010367b:	75 19                	jne    f0103696 <mem_init+0xc84>
f010367d:	68 a5 72 10 f0       	push   $0xf01072a5
f0103682:	68 76 6b 10 f0       	push   $0xf0106b76
f0103687:	68 23 04 00 00       	push   $0x423
f010368c:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103691:	e8 be 0b 00 00       	call   f0104254 <_panic>
	assert(pp1->pp_link == NULL);
f0103696:	83 3b 00             	cmpl   $0x0,(%ebx)
f0103699:	74 19                	je     f01036b4 <mem_init+0xca2>
f010369b:	68 b1 72 10 f0       	push   $0xf01072b1
f01036a0:	68 76 6b 10 f0       	push   $0xf0106b76
f01036a5:	68 24 04 00 00       	push   $0x424
f01036aa:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01036af:	e8 a0 0b 00 00       	call   f0104254 <_panic>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f01036b4:	51                   	push   %ecx
f01036b5:	51                   	push   %ecx
f01036b6:	68 00 10 00 00       	push   $0x1000
f01036bb:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f01036c1:	e8 17 f2 ff ff       	call   f01028dd <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01036c6:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f01036cb:	31 d2                	xor    %edx,%edx
f01036cd:	e8 f8 ec ff ff       	call   f01023ca <check_va2pa>
f01036d2:	83 c4 10             	add    $0x10,%esp
f01036d5:	40                   	inc    %eax
f01036d6:	74 19                	je     f01036f1 <mem_init+0xcdf>
f01036d8:	68 4d 72 10 f0       	push   $0xf010724d
f01036dd:	68 76 6b 10 f0       	push   $0xf0106b76
f01036e2:	68 28 04 00 00       	push   $0x428
f01036e7:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01036ec:	e8 63 0b 00 00       	call   f0104254 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f01036f1:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f01036f6:	ba 00 10 00 00       	mov    $0x1000,%edx
f01036fb:	e8 ca ec ff ff       	call   f01023ca <check_va2pa>
f0103700:	40                   	inc    %eax
f0103701:	74 19                	je     f010371c <mem_init+0xd0a>
f0103703:	68 c6 72 10 f0       	push   $0xf01072c6
f0103708:	68 76 6b 10 f0       	push   $0xf0106b76
f010370d:	68 29 04 00 00       	push   $0x429
f0103712:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103717:	e8 38 0b 00 00       	call   f0104254 <_panic>
	assert(pp1->pp_ref == 0);
f010371c:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0103721:	74 19                	je     f010373c <mem_init+0xd2a>
f0103723:	68 ec 72 10 f0       	push   $0xf01072ec
f0103728:	68 76 6b 10 f0       	push   $0xf0106b76
f010372d:	68 2a 04 00 00       	push   $0x42a
f0103732:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103737:	e8 18 0b 00 00       	call   f0104254 <_panic>
	assert(pp2->pp_ref == 0);
f010373c:	66 83 7d 04 00       	cmpw   $0x0,0x4(%ebp)
f0103741:	74 19                	je     f010375c <mem_init+0xd4a>
f0103743:	68 1a 72 10 f0       	push   $0xf010721a
f0103748:	68 76 6b 10 f0       	push   $0xf0106b76
f010374d:	68 2b 04 00 00       	push   $0x42b
f0103752:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103757:	e8 f8 0a 00 00       	call   f0104254 <_panic>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f010375c:	83 ec 0c             	sub    $0xc,%esp
f010375f:	6a 00                	push   $0x0
f0103761:	e8 e3 ef ff ff       	call   f0102749 <page_alloc>
f0103766:	83 c4 10             	add    $0x10,%esp
f0103769:	85 c0                	test   %eax,%eax
f010376b:	89 c7                	mov    %eax,%edi
f010376d:	74 04                	je     f0103773 <mem_init+0xd61>
f010376f:	39 d8                	cmp    %ebx,%eax
f0103771:	74 19                	je     f010378c <mem_init+0xd7a>
f0103773:	68 fd 72 10 f0       	push   $0xf01072fd
f0103778:	68 76 6b 10 f0       	push   $0xf0106b76
f010377d:	68 2e 04 00 00       	push   $0x42e
f0103782:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103787:	e8 c8 0a 00 00       	call   f0104254 <_panic>

	// should be no free memory
	assert(!page_alloc(0));
f010378c:	83 ec 0c             	sub    $0xc,%esp
f010378f:	6a 00                	push   $0x0
f0103791:	e8 b3 ef ff ff       	call   f0102749 <page_alloc>
f0103796:	83 c4 10             	add    $0x10,%esp
f0103799:	85 c0                	test   %eax,%eax
f010379b:	74 19                	je     f01037b6 <mem_init+0xda4>
f010379d:	68 1d 6e 10 f0       	push   $0xf0106e1d
f01037a2:	68 76 6b 10 f0       	push   $0xf0106b76
f01037a7:	68 31 04 00 00       	push   $0x431
f01037ac:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01037b1:	e8 9e 0a 00 00       	call   f0104254 <_panic>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01037b6:	8b 1d cc 86 11 f0    	mov    0xf01186cc,%ebx
f01037bc:	89 f0                	mov    %esi,%eax
f01037be:	e8 7d eb ff ff       	call   f0102340 <page2pa>
f01037c3:	8b 13                	mov    (%ebx),%edx
f01037c5:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01037cb:	39 c2                	cmp    %eax,%edx
f01037cd:	74 19                	je     f01037e8 <mem_init+0xdd6>
f01037cf:	68 1e 6f 10 f0       	push   $0xf0106f1e
f01037d4:	68 76 6b 10 f0       	push   $0xf0106b76
f01037d9:	68 34 04 00 00       	push   $0x434
f01037de:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01037e3:	e8 6c 0a 00 00       	call   f0104254 <_panic>
	kern_pgdir[0] = 0;
	assert(pp0->pp_ref == 1);
f01037e8:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
	// should be no free memory
	assert(!page_alloc(0));

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
	kern_pgdir[0] = 0;
f01037ed:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	assert(pp0->pp_ref == 1);
f01037f3:	74 19                	je     f010380e <mem_init+0xdfc>
f01037f5:	68 84 6f 10 f0       	push   $0xf0106f84
f01037fa:	68 76 6b 10 f0       	push   $0xf0106b76
f01037ff:	68 36 04 00 00       	push   $0x436
f0103804:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103809:	e8 46 0a 00 00       	call   f0104254 <_panic>
	pp0->pp_ref = 0;

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f010380e:	83 ec 0c             	sub    $0xc,%esp

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
	kern_pgdir[0] = 0;
	assert(pp0->pp_ref == 1);
	pp0->pp_ref = 0;
f0103811:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0103817:	56                   	push   %esi
f0103818:	e8 6d ef ff ff       	call   f010278a <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f010381d:	83 c4 0c             	add    $0xc,%esp
f0103820:	6a 01                	push   $0x1
f0103822:	68 00 10 40 00       	push   $0x401000
f0103827:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f010382d:	e8 b1 ef ff ff       	call   f01027e3 <pgdir_walk>
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0103832:	ba 3d 04 00 00       	mov    $0x43d,%edx
	pp0->pp_ref = 0;

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f0103837:	89 44 24 2c          	mov    %eax,0x2c(%esp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f010383b:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f0103840:	8b 48 04             	mov    0x4(%eax),%ecx
f0103843:	b8 1a 6b 10 f0       	mov    $0xf0106b1a,%eax
f0103848:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f010384e:	e8 35 eb ff ff       	call   f0102388 <_kaddr>
	assert(ptep == ptep1 + PTX(va));
f0103853:	83 c4 10             	add    $0x10,%esp
f0103856:	83 c0 04             	add    $0x4,%eax
f0103859:	39 44 24 1c          	cmp    %eax,0x1c(%esp)
f010385d:	74 19                	je     f0103878 <mem_init+0xe66>
f010385f:	68 1f 73 10 f0       	push   $0xf010731f
f0103864:	68 76 6b 10 f0       	push   $0xf0106b76
f0103869:	68 3e 04 00 00       	push   $0x43e
f010386e:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103873:	e8 dc 09 00 00       	call   f0104254 <_panic>
	kern_pgdir[PDX(va)] = 0;
f0103878:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f010387d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	pp0->pp_ref = 0;

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0103884:	89 f0                	mov    %esi,%eax
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
	assert(ptep == ptep1 + PTX(va));
	kern_pgdir[PDX(va)] = 0;
	pp0->pp_ref = 0;
f0103886:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f010388c:	e8 20 eb ff ff       	call   f01023b1 <page2kva>
f0103891:	52                   	push   %edx
f0103892:	68 00 10 00 00       	push   $0x1000
f0103897:	68 ff 00 00 00       	push   $0xff
f010389c:	50                   	push   %eax
f010389d:	e8 2d c9 ff ff       	call   f01001cf <memset>
	page_free(pp0);
f01038a2:	89 34 24             	mov    %esi,(%esp)
f01038a5:	e8 e0 ee ff ff       	call   f010278a <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f01038aa:	83 c4 0c             	add    $0xc,%esp
f01038ad:	6a 01                	push   $0x1
f01038af:	6a 00                	push   $0x0
f01038b1:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f01038b7:	e8 27 ef ff ff       	call   f01027e3 <pgdir_walk>
	ptep = (pte_t *) page2kva(pp0);
f01038bc:	89 f0                	mov    %esi,%eax
f01038be:	e8 ee ea ff ff       	call   f01023b1 <page2kva>
	for(i=0; i<NPTENTRIES; i++)
f01038c3:	31 d2                	xor    %edx,%edx

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(kern_pgdir, 0x0, 1);
	ptep = (pte_t *) page2kva(pp0);
f01038c5:	89 44 24 2c          	mov    %eax,0x2c(%esp)
f01038c9:	83 c4 10             	add    $0x10,%esp
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f01038cc:	f6 04 90 01          	testb  $0x1,(%eax,%edx,4)
f01038d0:	74 19                	je     f01038eb <mem_init+0xed9>
f01038d2:	68 37 73 10 f0       	push   $0xf0107337
f01038d7:	68 76 6b 10 f0       	push   $0xf0106b76
f01038dc:	68 48 04 00 00       	push   $0x448
f01038e1:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01038e6:	e8 69 09 00 00       	call   f0104254 <_panic>
	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(kern_pgdir, 0x0, 1);
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
f01038eb:	42                   	inc    %edx
f01038ec:	81 fa 00 04 00 00    	cmp    $0x400,%edx
f01038f2:	75 d8                	jne    f01038cc <mem_init+0xeba>
		assert((ptep[i] & PTE_P) == 0);
	kern_pgdir[0] = 0;
f01038f4:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f01038f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;

	// give free list back
	page_free_list = fl;
f01038ff:	8b 44 24 08          	mov    0x8(%esp),%eax

	// free the pages we took
	page_free(pp0);
f0103903:	83 ec 0c             	sub    $0xc,%esp
	pgdir_walk(kern_pgdir, 0x0, 1);
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
	kern_pgdir[0] = 0;
	pp0->pp_ref = 0;
f0103906:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// give free list back
	page_free_list = fl;

	// free the pages we took
	page_free(pp0);
f010390c:	56                   	push   %esi
		assert((ptep[i] & PTE_P) == 0);
	kern_pgdir[0] = 0;
	pp0->pp_ref = 0;

	// give free list back
	page_free_list = fl;
f010390d:	a3 1c 5e 11 f0       	mov    %eax,0xf0115e1c

	// free the pages we took
	page_free(pp0);
f0103912:	e8 73 ee ff ff       	call   f010278a <page_free>
	page_free(pp1);
f0103917:	89 3c 24             	mov    %edi,(%esp)
f010391a:	e8 6b ee ff ff       	call   f010278a <page_free>
	page_free(pp2);
f010391f:	89 2c 24             	mov    %ebp,(%esp)
f0103922:	e8 63 ee ff ff       	call   f010278a <page_free>
	
	// Lab6
	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f0103927:	5d                   	pop    %ebp
f0103928:	58                   	pop    %eax
f0103929:	68 01 10 00 00       	push   $0x1001
f010392e:	6a 00                	push   $0x0
f0103930:	e8 a0 f0 ff ff       	call   f01029d5 <mmio_map_region>
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0103935:	5e                   	pop    %esi
f0103936:	5f                   	pop    %edi
f0103937:	68 00 10 00 00       	push   $0x1000
f010393c:	6a 00                	push   $0x0
	page_free(pp1);
	page_free(pp2);
	
	// Lab6
	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f010393e:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0103940:	e8 90 f0 ff ff       	call   f01029d5 <mmio_map_region>
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8096 < MMIOLIM);
f0103945:	83 c4 10             	add    $0x10,%esp
	page_free(pp2);
	
	// Lab6
	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0103948:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8096 < MMIOLIM);
f010394a:	8d 83 a0 1f 00 00    	lea    0x1fa0(%ebx),%eax
f0103950:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f0103955:	77 08                	ja     f010395f <mem_init+0xf4d>
f0103957:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f010395d:	77 19                	ja     f0103978 <mem_init+0xf66>
f010395f:	68 4e 73 10 f0       	push   $0xf010734e
f0103964:	68 76 6b 10 f0       	push   $0xf0106b76
f0103969:	68 59 04 00 00       	push   $0x459
f010396e:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103973:	e8 dc 08 00 00       	call   f0104254 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8096 < MMIOLIM);
f0103978:	8d 96 a0 1f 00 00    	lea    0x1fa0(%esi),%edx
f010397e:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f0103984:	77 08                	ja     f010398e <mem_init+0xf7c>
f0103986:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f010398c:	77 19                	ja     f01039a7 <mem_init+0xf95>
f010398e:	68 76 73 10 f0       	push   $0xf0107376
f0103993:	68 76 6b 10 f0       	push   $0xf0106b76
f0103998:	68 5a 04 00 00       	push   $0x45a
f010399d:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01039a2:	e8 ad 08 00 00       	call   f0104254 <_panic>
// will be setup later.
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
f01039a7:	89 f2                	mov    %esi,%edx
f01039a9:	09 da                	or     %ebx,%edx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8096 < MMIOLIM);
	assert(mm2 >= MMIOBASE && mm2 + 8096 < MMIOLIM);
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f01039ab:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
f01039b1:	74 19                	je     f01039cc <mem_init+0xfba>
f01039b3:	68 9e 73 10 f0       	push   $0xf010739e
f01039b8:	68 76 6b 10 f0       	push   $0xf0106b76
f01039bd:	68 5c 04 00 00       	push   $0x45c
f01039c2:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01039c7:	e8 88 08 00 00       	call   f0104254 <_panic>
	// check that they don't overlap
	assert(mm1 + 8096 <= mm2);
f01039cc:	39 f0                	cmp    %esi,%eax
f01039ce:	76 19                	jbe    f01039e9 <mem_init+0xfd7>
f01039d0:	68 c5 73 10 f0       	push   $0xf01073c5
f01039d5:	68 76 6b 10 f0       	push   $0xf0106b76
f01039da:	68 5e 04 00 00       	push   $0x45e
f01039df:	68 1a 6b 10 f0       	push   $0xf0106b1a
f01039e4:	e8 6b 08 00 00       	call   f0104254 <_panic>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f01039e9:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f01039ee:	89 da                	mov    %ebx,%edx
f01039f0:	e8 d5 e9 ff ff       	call   f01023ca <check_va2pa>
f01039f5:	85 c0                	test   %eax,%eax
f01039f7:	74 19                	je     f0103a12 <mem_init+0x1000>
f01039f9:	68 d7 73 10 f0       	push   $0xf01073d7
f01039fe:	68 76 6b 10 f0       	push   $0xf0106b76
f0103a03:	68 60 04 00 00       	push   $0x460
f0103a08:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103a0d:	e8 42 08 00 00       	call   f0104254 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0103a12:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f0103a17:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
f0103a1d:	89 fa                	mov    %edi,%edx
f0103a1f:	e8 a6 e9 ff ff       	call   f01023ca <check_va2pa>
f0103a24:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0103a29:	74 19                	je     f0103a44 <mem_init+0x1032>
f0103a2b:	68 f9 73 10 f0       	push   $0xf01073f9
f0103a30:	68 76 6b 10 f0       	push   $0xf0106b76
f0103a35:	68 61 04 00 00       	push   $0x461
f0103a3a:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103a3f:	e8 10 08 00 00       	call   f0104254 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0103a44:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f0103a49:	89 f2                	mov    %esi,%edx
f0103a4b:	e8 7a e9 ff ff       	call   f01023ca <check_va2pa>
f0103a50:	85 c0                	test   %eax,%eax
f0103a52:	74 19                	je     f0103a6d <mem_init+0x105b>
f0103a54:	68 27 74 10 f0       	push   $0xf0107427
f0103a59:	68 76 6b 10 f0       	push   $0xf0106b76
f0103a5e:	68 62 04 00 00       	push   $0x462
f0103a63:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103a68:	e8 e7 07 00 00       	call   f0104254 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0103a6d:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f0103a72:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f0103a78:	e8 4d e9 ff ff       	call   f01023ca <check_va2pa>
f0103a7d:	40                   	inc    %eax
f0103a7e:	74 19                	je     f0103a99 <mem_init+0x1087>
f0103a80:	68 49 74 10 f0       	push   $0xf0107449
f0103a85:	68 76 6b 10 f0       	push   $0xf0106b76
f0103a8a:	68 63 04 00 00       	push   $0x463
f0103a8f:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103a94:	e8 bb 07 00 00       	call   f0104254 <_panic>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0103a99:	51                   	push   %ecx
f0103a9a:	6a 00                	push   $0x0
f0103a9c:	53                   	push   %ebx
f0103a9d:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f0103aa3:	e8 3b ed ff ff       	call   f01027e3 <pgdir_walk>
f0103aa8:	83 c4 10             	add    $0x10,%esp
f0103aab:	f6 00 1a             	testb  $0x1a,(%eax)
f0103aae:	75 19                	jne    f0103ac9 <mem_init+0x10b7>
f0103ab0:	68 73 74 10 f0       	push   $0xf0107473
f0103ab5:	68 76 6b 10 f0       	push   $0xf0106b76
f0103aba:	68 65 04 00 00       	push   $0x465
f0103abf:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103ac4:	e8 8b 07 00 00       	call   f0104254 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0103ac9:	52                   	push   %edx
f0103aca:	6a 00                	push   $0x0
f0103acc:	53                   	push   %ebx
f0103acd:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f0103ad3:	e8 0b ed ff ff       	call   f01027e3 <pgdir_walk>
f0103ad8:	83 c4 10             	add    $0x10,%esp
f0103adb:	f6 00 04             	testb  $0x4,(%eax)
f0103ade:	74 19                	je     f0103af9 <mem_init+0x10e7>
f0103ae0:	68 b5 74 10 f0       	push   $0xf01074b5
f0103ae5:	68 76 6b 10 f0       	push   $0xf0106b76
f0103aea:	68 66 04 00 00       	push   $0x466
f0103aef:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103af4:	e8 5b 07 00 00       	call   f0104254 <_panic>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0103af9:	50                   	push   %eax
f0103afa:	6a 00                	push   $0x0
f0103afc:	53                   	push   %ebx
f0103afd:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f0103b03:	e8 db ec ff ff       	call   f01027e3 <pgdir_walk>
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0103b08:	83 c4 0c             	add    $0xc,%esp
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0103b0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0103b11:	6a 00                	push   $0x0
f0103b13:	57                   	push   %edi
f0103b14:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f0103b1a:	e8 c4 ec ff ff       	call   f01027e3 <pgdir_walk>
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0103b1f:	83 c4 0c             	add    $0xc,%esp
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f0103b22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f0103b28:	6a 00                	push   $0x0
f0103b2a:	56                   	push   %esi
f0103b2b:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f0103b31:	e8 ad ec ff ff       	call   f01027e3 <pgdir_walk>
f0103b36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)


	printk("check_page() succeeded!\n");
f0103b3c:	c7 04 24 e8 74 10 f0 	movl   $0xf01074e8,(%esp)
f0103b43:	e8 e0 e7 ff ff       	call   f0102328 <printk>
	// Permissions:
	//    - the new image at UPAGES -- kernel R, user R
	//      (ie. perm = PTE_U | PTE_P)
	//    - pages itself -- kernel RW, user NONE
	// Your code goes here:
    boot_map_region(kern_pgdir, UPAGES, ROUNDUP((sizeof(struct PageInfo) * npages), PGSIZE), PADDR(pages), (PTE_U | PTE_P));
f0103b48:	8b 15 d4 86 11 f0    	mov    0xf01186d4,%edx
f0103b4e:	b8 b3 00 00 00       	mov    $0xb3,%eax
f0103b53:	e8 3e eb ff ff       	call   f0102696 <_paddr.clone.0>
f0103b58:	8b 15 c8 86 11 f0    	mov    0xf01186c8,%edx
f0103b5e:	5f                   	pop    %edi
f0103b5f:	5d                   	pop    %ebp
f0103b60:	8d 0c d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%ecx
f0103b67:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0103b6c:	6a 05                	push   $0x5
f0103b6e:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0103b74:	50                   	push   %eax
f0103b75:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f0103b7a:	e8 d1 ec ff ff       	call   f0102850 <boot_map_region>
	//       the kernel overflows its stack, it will fault rather than
	//       overwrite memory.  Known as a "guard page".
	//     Permissions: kernel RW, user NONE
	// Your code goes here:
    /* TODO */
    boot_map_region(kern_pgdir,KSTACKTOP - KSTKSIZE,KSTKSIZE,PADDR(bootstack),PTE_W);
f0103b7f:	ba 00 d0 10 f0       	mov    $0xf010d000,%edx
f0103b84:	b8 c2 00 00 00       	mov    $0xc2,%eax
f0103b89:	e8 08 eb ff ff       	call   f0102696 <_paddr.clone.0>
f0103b8e:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0103b93:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0103b98:	5b                   	pop    %ebx
    /* TODO */
    boot_map_region(kern_pgdir,KERNBASE,0xffffffff-KERNBASE,0,PTE_W);

	//////////////////////////////////////////////////////////////////////
	// Map VA range [IOPHYSMEM, EXTPHYSMEM) to PA range [IOPHYSMEM, EXTPHYSMEM)
    boot_map_region(kern_pgdir, IOPHYSMEM, ROUNDUP((EXTPHYSMEM - IOPHYSMEM), PGSIZE), IOPHYSMEM, (PTE_W) | (PTE_P));
f0103b99:	bb 00 00 00 f0       	mov    $0xf0000000,%ebx
	//       the kernel overflows its stack, it will fault rather than
	//       overwrite memory.  Known as a "guard page".
	//     Permissions: kernel RW, user NONE
	// Your code goes here:
    /* TODO */
    boot_map_region(kern_pgdir,KSTACKTOP - KSTKSIZE,KSTKSIZE,PADDR(bootstack),PTE_W);
f0103b9e:	5e                   	pop    %esi
    /* TODO */
    boot_map_region(kern_pgdir,KERNBASE,0xffffffff-KERNBASE,0,PTE_W);

	//////////////////////////////////////////////////////////////////////
	// Map VA range [IOPHYSMEM, EXTPHYSMEM) to PA range [IOPHYSMEM, EXTPHYSMEM)
    boot_map_region(kern_pgdir, IOPHYSMEM, ROUNDUP((EXTPHYSMEM - IOPHYSMEM), PGSIZE), IOPHYSMEM, (PTE_W) | (PTE_P));
f0103b9f:	be 00 a0 11 f0       	mov    $0xf011a000,%esi
	//       the kernel overflows its stack, it will fault rather than
	//       overwrite memory.  Known as a "guard page".
	//     Permissions: kernel RW, user NONE
	// Your code goes here:
    /* TODO */
    boot_map_region(kern_pgdir,KSTACKTOP - KSTKSIZE,KSTKSIZE,PADDR(bootstack),PTE_W);
f0103ba4:	6a 02                	push   $0x2
f0103ba6:	50                   	push   %eax
f0103ba7:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f0103bac:	e8 9f ec ff ff       	call   f0102850 <boot_map_region>
	// We might not have 2^32 - KERNBASE bytes of physical memory, but
	// we just set up the mapping anyway.
	// Permissions: kernel RW, user NONE
	// Your code goes here:
    /* TODO */
    boot_map_region(kern_pgdir,KERNBASE,0xffffffff-KERNBASE,0,PTE_W);
f0103bb1:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f0103bb6:	5a                   	pop    %edx
f0103bb7:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0103bbc:	59                   	pop    %ecx
f0103bbd:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
f0103bc2:	6a 02                	push   $0x2
f0103bc4:	6a 00                	push   $0x0
f0103bc6:	e8 85 ec ff ff       	call   f0102850 <boot_map_region>

	//////////////////////////////////////////////////////////////////////
	// Map VA range [IOPHYSMEM, EXTPHYSMEM) to PA range [IOPHYSMEM, EXTPHYSMEM)
    boot_map_region(kern_pgdir, IOPHYSMEM, ROUNDUP((EXTPHYSMEM - IOPHYSMEM), PGSIZE), IOPHYSMEM, (PTE_W) | (PTE_P));
f0103bcb:	b9 00 00 06 00       	mov    $0x60000,%ecx
f0103bd0:	ba 00 00 0a 00       	mov    $0xa0000,%edx
f0103bd5:	5d                   	pop    %ebp
f0103bd6:	58                   	pop    %eax
f0103bd7:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f0103bdc:	6a 03                	push   $0x3
f0103bde:	68 00 00 0a 00       	push   $0xa0000
f0103be3:	e8 68 ec ff ff       	call   f0102850 <boot_map_region>
f0103be8:	c7 44 24 18 00 a0 11 	movl   $0xf011a000,0x18(%esp)
f0103bef:	f0 
f0103bf0:	83 c4 10             	add    $0x10,%esp
	// TODO:
	// Lab6: Your code here:
     int i;
     for (i = 0; i < NCPU; ++i) {
         uint32_t kstacktop_i = KSTACKTOP - i * (KSTKSIZE + KSTKGAP);
         boot_map_region(kern_pgdir, 
f0103bf3:	89 f2                	mov    %esi,%edx
f0103bf5:	b8 0b 01 00 00       	mov    $0x10b,%eax
f0103bfa:	e8 97 ea ff ff       	call   f0102696 <_paddr.clone.0>
                 ROUNDDOWN(kstacktop_i, PGSIZE) - KSTKSIZE,
f0103bff:	89 da                	mov    %ebx,%edx
	// TODO:
	// Lab6: Your code here:
     int i;
     for (i = 0; i < NCPU; ++i) {
         uint32_t kstacktop_i = KSTACKTOP - i * (KSTKSIZE + KSTKGAP);
         boot_map_region(kern_pgdir, 
f0103c01:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0103c06:	57                   	push   %edi
                 ROUNDDOWN(kstacktop_i, PGSIZE) - KSTKSIZE,
f0103c07:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	// TODO:
	// Lab6: Your code here:
     int i;
     for (i = 0; i < NCPU; ++i) {
         uint32_t kstacktop_i = KSTACKTOP - i * (KSTKSIZE + KSTKGAP);
         boot_map_region(kern_pgdir, 
f0103c0d:	57                   	push   %edi
f0103c0e:	81 ea 00 80 00 00    	sub    $0x8000,%edx
f0103c14:	6a 02                	push   $0x2
f0103c16:	81 eb 00 00 01 00    	sub    $0x10000,%ebx
f0103c1c:	81 c6 00 80 00 00    	add    $0x8000,%esi
f0103c22:	50                   	push   %eax
f0103c23:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
f0103c28:	e8 23 ec ff ff       	call   f0102850 <boot_map_region>
	//             Known as a "guard page".
	//     Permissions: kernel RW, user NONE
	// TODO:
	// Lab6: Your code here:
     int i;
     for (i = 0; i < NCPU; ++i) {
f0103c2d:	83 c4 10             	add    $0x10,%esp
f0103c30:	81 fb 00 00 f8 ef    	cmp    $0xeff80000,%ebx
f0103c36:	75 bb                	jne    f0103bf3 <mem_init+0x11e1>
check_kern_pgdir(void)
{
	uint32_t i, n;
	pde_t *pgdir;

	pgdir = kern_pgdir;
f0103c38:	8b 1d cc 86 11 f0    	mov    0xf01186cc,%ebx

    // check IO mem
    for (i = IOPHYSMEM; i < ROUNDUP(EXTPHYSMEM, PGSIZE); i += PGSIZE)
f0103c3e:	be 00 00 0a 00       	mov    $0xa0000,%esi
		assert(check_va2pa(pgdir, i) == i);
f0103c43:	89 f2                	mov    %esi,%edx
f0103c45:	89 d8                	mov    %ebx,%eax
f0103c47:	e8 7e e7 ff ff       	call   f01023ca <check_va2pa>
f0103c4c:	39 f0                	cmp    %esi,%eax
f0103c4e:	74 19                	je     f0103c69 <mem_init+0x1257>
f0103c50:	68 01 75 10 f0       	push   $0xf0107501
f0103c55:	68 76 6b 10 f0       	push   $0xf0106b76
f0103c5a:	68 7e 03 00 00       	push   $0x37e
f0103c5f:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103c64:	e8 eb 05 00 00       	call   f0104254 <_panic>
	pde_t *pgdir;

	pgdir = kern_pgdir;

    // check IO mem
    for (i = IOPHYSMEM; i < ROUNDUP(EXTPHYSMEM, PGSIZE); i += PGSIZE)
f0103c69:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0103c6f:	81 fe 00 00 10 00    	cmp    $0x100000,%esi
f0103c75:	75 cc                	jne    f0103c43 <mem_init+0x1231>
		assert(check_va2pa(pgdir, i) == i);

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f0103c77:	a1 c8 86 11 f0       	mov    0xf01186c8,%eax
	for (i = 0; i < n; i += PGSIZE)
f0103c7c:	31 f6                	xor    %esi,%esi
    // check IO mem
    for (i = IOPHYSMEM; i < ROUNDUP(EXTPHYSMEM, PGSIZE); i += PGSIZE)
		assert(check_va2pa(pgdir, i) == i);

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f0103c7e:	8d 3c c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%edi
f0103c85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
f0103c8b:	eb 44                	jmp    f0103cd1 <mem_init+0x12bf>
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0103c8d:	8d 96 00 00 00 ef    	lea    -0x11000000(%esi),%edx
f0103c93:	89 d8                	mov    %ebx,%eax
f0103c95:	e8 30 e7 ff ff       	call   f01023ca <check_va2pa>
f0103c9a:	8b 15 d4 86 11 f0    	mov    0xf01186d4,%edx
f0103ca0:	89 c5                	mov    %eax,%ebp
f0103ca2:	b8 83 03 00 00       	mov    $0x383,%eax
f0103ca7:	e8 ea e9 ff ff       	call   f0102696 <_paddr.clone.0>
f0103cac:	01 f0                	add    %esi,%eax
f0103cae:	39 c5                	cmp    %eax,%ebp
f0103cb0:	74 19                	je     f0103ccb <mem_init+0x12b9>
f0103cb2:	68 1c 75 10 f0       	push   $0xf010751c
f0103cb7:	68 76 6b 10 f0       	push   $0xf0106b76
f0103cbc:	68 83 03 00 00       	push   $0x383
f0103cc1:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103cc6:	e8 89 05 00 00       	call   f0104254 <_panic>
    for (i = IOPHYSMEM; i < ROUNDUP(EXTPHYSMEM, PGSIZE); i += PGSIZE)
		assert(check_va2pa(pgdir, i) == i);

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f0103ccb:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0103cd1:	39 fe                	cmp    %edi,%esi
f0103cd3:	72 b8                	jb     f0103c8d <mem_init+0x127b>
f0103cd5:	31 f6                	xor    %esi,%esi
f0103cd7:	eb 30                	jmp    f0103d09 <mem_init+0x12f7>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
    
	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0103cd9:	8d 96 00 00 00 f0    	lea    -0x10000000(%esi),%edx
f0103cdf:	89 d8                	mov    %ebx,%eax
f0103ce1:	e8 e4 e6 ff ff       	call   f01023ca <check_va2pa>
f0103ce6:	39 f0                	cmp    %esi,%eax
f0103ce8:	74 19                	je     f0103d03 <mem_init+0x12f1>
f0103cea:	68 4f 75 10 f0       	push   $0xf010754f
f0103cef:	68 76 6b 10 f0       	push   $0xf0106b76
f0103cf4:	68 87 03 00 00       	push   $0x387
f0103cf9:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103cfe:	e8 51 05 00 00       	call   f0104254 <_panic>
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
    
	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0103d03:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0103d09:	a1 c8 86 11 f0       	mov    0xf01186c8,%eax
f0103d0e:	c1 e0 0c             	shl    $0xc,%eax
f0103d11:	39 c6                	cmp    %eax,%esi
f0103d13:	72 c4                	jb     f0103cd9 <mem_init+0x12c7>
f0103d15:	be 00 00 ff ef       	mov    $0xefff0000,%esi

	// check kernel stack
	// (updated in Lab6 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0103d1a:	31 ff                	xor    %edi,%edi
// will be setup later.
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
f0103d1c:	8d ae 00 80 00 00    	lea    0x8000(%esi),%ebp
	// check kernel stack
	// (updated in Lab6 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0103d22:	8d 54 3d 00          	lea    0x0(%ebp,%edi,1),%edx
f0103d26:	89 d8                	mov    %ebx,%eax
f0103d28:	e8 9d e6 ff ff       	call   f01023ca <check_va2pa>
f0103d2d:	8b 54 24 08          	mov    0x8(%esp),%edx
f0103d31:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103d35:	b8 8f 03 00 00       	mov    $0x38f,%eax
f0103d3a:	e8 57 e9 ff ff       	call   f0102696 <_paddr.clone.0>
f0103d3f:	8d 04 07             	lea    (%edi,%eax,1),%eax
f0103d42:	39 44 24 0c          	cmp    %eax,0xc(%esp)
f0103d46:	74 19                	je     f0103d61 <mem_init+0x134f>
f0103d48:	68 75 75 10 f0       	push   $0xf0107575
f0103d4d:	68 76 6b 10 f0       	push   $0xf0106b76
f0103d52:	68 8f 03 00 00       	push   $0x38f
f0103d57:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103d5c:	e8 f3 04 00 00       	call   f0104254 <_panic>

	// check kernel stack
	// (updated in Lab6 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0103d61:	81 c7 00 10 00 00    	add    $0x1000,%edi
f0103d67:	81 ff 00 80 00 00    	cmp    $0x8000,%edi
f0103d6d:	75 b3                	jne    f0103d22 <mem_init+0x1310>
f0103d6f:	66 31 ff             	xor    %di,%di
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
					== PADDR(percpu_kstacks[n]) + i);
		for (i = 0; i < KSTKGAP; i += PGSIZE)
			assert(check_va2pa(pgdir, base + i) == ~0);
f0103d72:	8d 14 37             	lea    (%edi,%esi,1),%edx
f0103d75:	89 d8                	mov    %ebx,%eax
f0103d77:	e8 4e e6 ff ff       	call   f01023ca <check_va2pa>
f0103d7c:	40                   	inc    %eax
f0103d7d:	74 19                	je     f0103d98 <mem_init+0x1386>
f0103d7f:	68 bc 75 10 f0       	push   $0xf01075bc
f0103d84:	68 76 6b 10 f0       	push   $0xf0106b76
f0103d89:	68 91 03 00 00       	push   $0x391
f0103d8e:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103d93:	e8 bc 04 00 00       	call   f0104254 <_panic>
	for (n = 0; n < NCPU; n++) {
		uint32_t base = KSTACKTOP - (KSTKSIZE + KSTKGAP) * (n + 1);
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
					== PADDR(percpu_kstacks[n]) + i);
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0103d98:	81 c7 00 10 00 00    	add    $0x1000,%edi
f0103d9e:	81 ff 00 80 00 00    	cmp    $0x8000,%edi
f0103da4:	75 cc                	jne    f0103d72 <mem_init+0x1360>
f0103da6:	81 ee 00 00 01 00    	sub    $0x10000,%esi
f0103dac:	81 44 24 08 00 80 00 	addl   $0x8000,0x8(%esp)
f0103db3:	00 
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);

	// check kernel stack
	// (updated in Lab6 to check per-CPU kernel stacks)
	for (n = 0; n < NCPU; n++) {
f0103db4:	81 fe 00 00 f7 ef    	cmp    $0xeff70000,%esi
f0103dba:	0f 85 5a ff ff ff    	jne    f0103d1a <mem_init+0x1308>
f0103dc0:	31 c0                	xor    %eax,%eax
			assert(check_va2pa(pgdir, base + i) == ~0);
	}
	
	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
		switch (i) {
f0103dc2:	85 c0                	test   %eax,%eax
f0103dc4:	74 0b                	je     f0103dd1 <mem_init+0x13bf>
f0103dc6:	8d 90 44 fc ff ff    	lea    -0x3bc(%eax),%edx
f0103dcc:	83 fa 03             	cmp    $0x3,%edx
f0103dcf:	77 1f                	ja     f0103df0 <mem_init+0x13de>
        case PDX(IOPHYSMEM):
		case PDX(UVPT):
		case PDX(KSTACKTOP-1):
		case PDX(UPAGES):
      		case PDX(MMIOBASE):
			assert(pgdir[i] & PTE_P);
f0103dd1:	f6 04 83 01          	testb  $0x1,(%ebx,%eax,4)
f0103dd5:	75 7e                	jne    f0103e55 <mem_init+0x1443>
f0103dd7:	68 df 75 10 f0       	push   $0xf01075df
f0103ddc:	68 76 6b 10 f0       	push   $0xf0106b76
f0103de1:	68 9c 03 00 00       	push   $0x39c
f0103de6:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103deb:	e8 64 04 00 00       	call   f0104254 <_panic>
			break;
		default:
			if (i >= PDX(KERNBASE)) {
f0103df0:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f0103df5:	76 3f                	jbe    f0103e36 <mem_init+0x1424>
				assert(pgdir[i] & PTE_P);
f0103df7:	8b 14 83             	mov    (%ebx,%eax,4),%edx
f0103dfa:	f6 c2 01             	test   $0x1,%dl
f0103dfd:	75 19                	jne    f0103e18 <mem_init+0x1406>
f0103dff:	68 df 75 10 f0       	push   $0xf01075df
f0103e04:	68 76 6b 10 f0       	push   $0xf0106b76
f0103e09:	68 a0 03 00 00       	push   $0x3a0
f0103e0e:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103e13:	e8 3c 04 00 00       	call   f0104254 <_panic>
				assert(pgdir[i] & PTE_W);
f0103e18:	80 e2 02             	and    $0x2,%dl
f0103e1b:	75 38                	jne    f0103e55 <mem_init+0x1443>
f0103e1d:	68 f0 75 10 f0       	push   $0xf01075f0
f0103e22:	68 76 6b 10 f0       	push   $0xf0106b76
f0103e27:	68 a1 03 00 00       	push   $0x3a1
f0103e2c:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103e31:	e8 1e 04 00 00       	call   f0104254 <_panic>
			} else
				assert(pgdir[i] == 0);
f0103e36:	83 3c 83 00          	cmpl   $0x0,(%ebx,%eax,4)
f0103e3a:	74 19                	je     f0103e55 <mem_init+0x1443>
f0103e3c:	68 01 76 10 f0       	push   $0xf0107601
f0103e41:	68 76 6b 10 f0       	push   $0xf0106b76
f0103e46:	68 a3 03 00 00       	push   $0x3a3
f0103e4b:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103e50:	e8 ff 03 00 00       	call   f0104254 <_panic>
		for (i = 0; i < KSTKGAP; i += PGSIZE)
			assert(check_va2pa(pgdir, base + i) == ~0);
	}
	
	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
f0103e55:	40                   	inc    %eax
f0103e56:	3d 00 04 00 00       	cmp    $0x400,%eax
f0103e5b:	0f 85 61 ff ff ff    	jne    f0103dc2 <mem_init+0x13b0>
			} else
				assert(pgdir[i] == 0);
			break;
		}
	}
	printk("check_kern_pgdir() succeeded!\n");
f0103e61:	83 ec 0c             	sub    $0xc,%esp
f0103e64:	68 0f 76 10 f0       	push   $0xf010760f
f0103e69:	e8 ba e4 ff ff       	call   f0102328 <printk>
	// somewhere between KERNBASE and KERNBASE+4MB right now, which is
	// mapped the same way by both page tables.
	//
	// If the machine reboots at this point, you've probably set up your
	// kern_pgdir wrong.
	lcr3(PADDR(kern_pgdir));
f0103e6e:	8b 15 cc 86 11 f0    	mov    0xf01186cc,%edx
f0103e74:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0103e79:	e8 18 e8 ff ff       	call   f0102696 <_paddr.clone.0>
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0103e7e:	0f 22 d8             	mov    %eax,%cr3

	check_page_free_list(0);
f0103e81:	31 c0                	xor    %eax,%eax
f0103e83:	e8 ba e5 ff ff       	call   f0102442 <check_page_free_list>

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
f0103e88:	0f 20 c0             	mov    %cr0,%eax

	// entry.S set the really important flags in cr0 (including enabling
	// paging).  Here we configure the rest of the flags that we care about.
	cr0 = rcr0();
	cr0 |= CR0_PE|CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_MP;
f0103e8b:	0d 23 00 05 80       	or     $0x80050023,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0103e90:	83 e0 f3             	and    $0xfffffff3,%eax
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
f0103e93:	0f 22 c0             	mov    %eax,%cr0
{
	struct PageInfo *pp0, *pp1, *pp2;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0103e96:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0103e9d:	e8 a7 e8 ff ff       	call   f0102749 <page_alloc>
f0103ea2:	83 c4 10             	add    $0x10,%esp
f0103ea5:	85 c0                	test   %eax,%eax
f0103ea7:	89 c7                	mov    %eax,%edi
f0103ea9:	75 19                	jne    f0103ec4 <mem_init+0x14b2>
f0103eab:	68 52 6d 10 f0       	push   $0xf0106d52
f0103eb0:	68 76 6b 10 f0       	push   $0xf0106b76
f0103eb5:	68 78 04 00 00       	push   $0x478
f0103eba:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103ebf:	e8 90 03 00 00       	call   f0104254 <_panic>
	assert((pp1 = page_alloc(0)));
f0103ec4:	83 ec 0c             	sub    $0xc,%esp
f0103ec7:	6a 00                	push   $0x0
f0103ec9:	e8 7b e8 ff ff       	call   f0102749 <page_alloc>
f0103ece:	83 c4 10             	add    $0x10,%esp
f0103ed1:	85 c0                	test   %eax,%eax
f0103ed3:	89 c6                	mov    %eax,%esi
f0103ed5:	75 19                	jne    f0103ef0 <mem_init+0x14de>
f0103ed7:	68 68 6d 10 f0       	push   $0xf0106d68
f0103edc:	68 76 6b 10 f0       	push   $0xf0106b76
f0103ee1:	68 79 04 00 00       	push   $0x479
f0103ee6:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103eeb:	e8 64 03 00 00       	call   f0104254 <_panic>
	assert((pp2 = page_alloc(0)));
f0103ef0:	83 ec 0c             	sub    $0xc,%esp
f0103ef3:	6a 00                	push   $0x0
f0103ef5:	e8 4f e8 ff ff       	call   f0102749 <page_alloc>
f0103efa:	83 c4 10             	add    $0x10,%esp
f0103efd:	85 c0                	test   %eax,%eax
f0103eff:	89 c3                	mov    %eax,%ebx
f0103f01:	75 19                	jne    f0103f1c <mem_init+0x150a>
f0103f03:	68 7e 6d 10 f0       	push   $0xf0106d7e
f0103f08:	68 76 6b 10 f0       	push   $0xf0106b76
f0103f0d:	68 7a 04 00 00       	push   $0x47a
f0103f12:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103f17:	e8 38 03 00 00       	call   f0104254 <_panic>
	page_free(pp0);
f0103f1c:	83 ec 0c             	sub    $0xc,%esp
f0103f1f:	57                   	push   %edi
f0103f20:	e8 65 e8 ff ff       	call   f010278a <page_free>
	memset(page2kva(pp1), 1, PGSIZE);
f0103f25:	89 f0                	mov    %esi,%eax
f0103f27:	e8 85 e4 ff ff       	call   f01023b1 <page2kva>
f0103f2c:	83 c4 0c             	add    $0xc,%esp
f0103f2f:	68 00 10 00 00       	push   $0x1000
f0103f34:	6a 01                	push   $0x1
f0103f36:	50                   	push   %eax
f0103f37:	e8 93 c2 ff ff       	call   f01001cf <memset>
	memset(page2kva(pp2), 2, PGSIZE);
f0103f3c:	89 d8                	mov    %ebx,%eax
f0103f3e:	e8 6e e4 ff ff       	call   f01023b1 <page2kva>
f0103f43:	83 c4 0c             	add    $0xc,%esp
f0103f46:	68 00 10 00 00       	push   $0x1000
f0103f4b:	6a 02                	push   $0x2
f0103f4d:	50                   	push   %eax
f0103f4e:	e8 7c c2 ff ff       	call   f01001cf <memset>
	page_insert(kern_pgdir, pp1, (void*) EXTPHYSMEM, PTE_W);
f0103f53:	6a 02                	push   $0x2
f0103f55:	68 00 00 10 00       	push   $0x100000
f0103f5a:	56                   	push   %esi
f0103f5b:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f0103f61:	e8 b3 e9 ff ff       	call   f0102919 <page_insert>
	assert(pp1->pp_ref == 1);
f0103f66:	83 c4 20             	add    $0x20,%esp
f0103f69:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0103f6e:	74 19                	je     f0103f89 <mem_init+0x1577>
f0103f70:	68 73 6f 10 f0       	push   $0xf0106f73
f0103f75:	68 76 6b 10 f0       	push   $0xf0106b76
f0103f7a:	68 7f 04 00 00       	push   $0x47f
f0103f7f:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103f84:	e8 cb 02 00 00       	call   f0104254 <_panic>
	assert(*(uint32_t *)EXTPHYSMEM == 0x01010101U);
f0103f89:	81 3d 00 00 10 00 01 	cmpl   $0x1010101,0x100000
f0103f90:	01 01 01 
f0103f93:	74 19                	je     f0103fae <mem_init+0x159c>
f0103f95:	68 2e 76 10 f0       	push   $0xf010762e
f0103f9a:	68 76 6b 10 f0       	push   $0xf0106b76
f0103f9f:	68 80 04 00 00       	push   $0x480
f0103fa4:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103fa9:	e8 a6 02 00 00       	call   f0104254 <_panic>
	page_insert(kern_pgdir, pp2, (void*) EXTPHYSMEM, PTE_W);
f0103fae:	6a 02                	push   $0x2
f0103fb0:	68 00 00 10 00       	push   $0x100000
f0103fb5:	53                   	push   %ebx
f0103fb6:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f0103fbc:	e8 58 e9 ff ff       	call   f0102919 <page_insert>
	assert(*(uint32_t *)EXTPHYSMEM == 0x02020202U);
f0103fc1:	83 c4 10             	add    $0x10,%esp
f0103fc4:	81 3d 00 00 10 00 02 	cmpl   $0x2020202,0x100000
f0103fcb:	02 02 02 
f0103fce:	74 19                	je     f0103fe9 <mem_init+0x15d7>
f0103fd0:	68 55 76 10 f0       	push   $0xf0107655
f0103fd5:	68 76 6b 10 f0       	push   $0xf0106b76
f0103fda:	68 82 04 00 00       	push   $0x482
f0103fdf:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0103fe4:	e8 6b 02 00 00       	call   f0104254 <_panic>
	assert(pp2->pp_ref == 1);
f0103fe9:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0103fee:	74 19                	je     f0104009 <mem_init+0x15f7>
f0103ff0:	68 fe 6f 10 f0       	push   $0xf0106ffe
f0103ff5:	68 76 6b 10 f0       	push   $0xf0106b76
f0103ffa:	68 83 04 00 00       	push   $0x483
f0103fff:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0104004:	e8 4b 02 00 00       	call   f0104254 <_panic>
	assert(pp1->pp_ref == 0);
f0104009:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f010400e:	74 19                	je     f0104029 <mem_init+0x1617>
f0104010:	68 ec 72 10 f0       	push   $0xf01072ec
f0104015:	68 76 6b 10 f0       	push   $0xf0106b76
f010401a:	68 84 04 00 00       	push   $0x484
f010401f:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0104024:	e8 2b 02 00 00       	call   f0104254 <_panic>
	*(uint32_t *)EXTPHYSMEM = 0x03030303U;
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0104029:	89 d8                	mov    %ebx,%eax
	assert(*(uint32_t *)EXTPHYSMEM == 0x01010101U);
	page_insert(kern_pgdir, pp2, (void*) EXTPHYSMEM, PTE_W);
	assert(*(uint32_t *)EXTPHYSMEM == 0x02020202U);
	assert(pp2->pp_ref == 1);
	assert(pp1->pp_ref == 0);
	*(uint32_t *)EXTPHYSMEM = 0x03030303U;
f010402b:	c7 05 00 00 10 00 03 	movl   $0x3030303,0x100000
f0104032:	03 03 03 
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0104035:	e8 77 e3 ff ff       	call   f01023b1 <page2kva>
f010403a:	81 38 03 03 03 03    	cmpl   $0x3030303,(%eax)
f0104040:	74 19                	je     f010405b <mem_init+0x1649>
f0104042:	68 7c 76 10 f0       	push   $0xf010767c
f0104047:	68 76 6b 10 f0       	push   $0xf0106b76
f010404c:	68 86 04 00 00       	push   $0x486
f0104051:	68 1a 6b 10 f0       	push   $0xf0106b1a
f0104056:	e8 f9 01 00 00       	call   f0104254 <_panic>
	page_remove(kern_pgdir, (void*) EXTPHYSMEM);
f010405b:	51                   	push   %ecx
f010405c:	51                   	push   %ecx
f010405d:	68 00 00 10 00       	push   $0x100000
f0104062:	ff 35 cc 86 11 f0    	pushl  0xf01186cc
f0104068:	e8 70 e8 ff ff       	call   f01028dd <page_remove>
	assert(pp2->pp_ref == 0);
f010406d:	83 c4 10             	add    $0x10,%esp
f0104070:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0104075:	74 19                	je     f0104090 <mem_init+0x167e>
f0104077:	68 1a 72 10 f0       	push   $0xf010721a
f010407c:	68 76 6b 10 f0       	push   $0xf0106b76
f0104081:	68 88 04 00 00       	push   $0x488
f0104086:	68 1a 6b 10 f0       	push   $0xf0106b1a
f010408b:	e8 c4 01 00 00       	call   f0104254 <_panic>

	printk("check_page_installed_pgdir() succeeded!\n");
f0104090:	83 ec 0c             	sub    $0xc,%esp
f0104093:	68 a6 76 10 f0       	push   $0xf01076a6
f0104098:	e8 8b e2 ff ff       	call   f0102328 <printk>
	cr0 &= ~(CR0_TS|CR0_EM);
	lcr0(cr0);

	// Some more checks, only possible after kern_pgdir is installed.
	check_page_installed_pgdir();
}
f010409d:	83 c4 3c             	add    $0x3c,%esp
f01040a0:	5b                   	pop    %ebx
f01040a1:	5e                   	pop    %esi
f01040a2:	5f                   	pop    %edi
f01040a3:	5d                   	pop    %ebp
f01040a4:	c3                   	ret    

f01040a5 <setupvm>:
}

/* This is a simple wrapper function for mapping user program */
void
setupvm(pde_t *pgdir, uint32_t start, uint32_t size)
{
f01040a5:	56                   	push   %esi
  boot_map_region(pgdir, start, ROUNDUP(size, PGSIZE), PADDR((void*)start), PTE_W | PTE_U);
f01040a6:	b8 8d 02 00 00       	mov    $0x28d,%eax
}

/* This is a simple wrapper function for mapping user program */
void
setupvm(pde_t *pgdir, uint32_t start, uint32_t size)
{
f01040ab:	53                   	push   %ebx
f01040ac:	83 ec 04             	sub    $0x4,%esp
f01040af:	8b 5c 24 14          	mov    0x14(%esp),%ebx
f01040b3:	8b 74 24 10          	mov    0x10(%esp),%esi
  boot_map_region(pgdir, start, ROUNDUP(size, PGSIZE), PADDR((void*)start), PTE_W | PTE_U);
f01040b7:	89 da                	mov    %ebx,%edx
f01040b9:	e8 d8 e5 ff ff       	call   f0102696 <_paddr.clone.0>
f01040be:	8b 4c 24 18          	mov    0x18(%esp),%ecx
f01040c2:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
f01040c8:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01040ce:	52                   	push   %edx
f01040cf:	52                   	push   %edx
f01040d0:	89 da                	mov    %ebx,%edx
f01040d2:	6a 06                	push   $0x6
f01040d4:	50                   	push   %eax
f01040d5:	89 f0                	mov    %esi,%eax
f01040d7:	e8 74 e7 ff ff       	call   f0102850 <boot_map_region>
  assert(check_va2pa(pgdir, start) == PADDR((void*)start));
f01040dc:	89 da                	mov    %ebx,%edx
f01040de:	89 f0                	mov    %esi,%eax
f01040e0:	e8 e5 e2 ff ff       	call   f01023ca <check_va2pa>
f01040e5:	89 da                	mov    %ebx,%edx
f01040e7:	89 c6                	mov    %eax,%esi
f01040e9:	b8 8e 02 00 00       	mov    $0x28e,%eax
f01040ee:	e8 a3 e5 ff ff       	call   f0102696 <_paddr.clone.0>
f01040f3:	83 c4 10             	add    $0x10,%esp
f01040f6:	39 c6                	cmp    %eax,%esi
f01040f8:	74 19                	je     f0104113 <setupvm+0x6e>
f01040fa:	68 cf 76 10 f0       	push   $0xf01076cf
f01040ff:	68 76 6b 10 f0       	push   $0xf0106b76
f0104104:	68 8e 02 00 00       	push   $0x28e
f0104109:	68 1a 6b 10 f0       	push   $0xf0106b1a
f010410e:	e8 41 01 00 00       	call   f0104254 <_panic>
}
f0104113:	83 c4 04             	add    $0x4,%esp
f0104116:	5b                   	pop    %ebx
f0104117:	5e                   	pop    %esi
f0104118:	c3                   	ret    

f0104119 <setupkvm>:
 * 2. MMIO region for local apic
 *
 */
pde_t *
setupkvm()
{   
f0104119:	56                   	push   %esi
f010411a:	53                   	push   %ebx
f010411b:	83 ec 10             	sub    $0x10,%esp
    struct PageInfo *s;
    s = page_alloc(ALLOC_ZERO);
f010411e:	6a 01                	push   $0x1
f0104120:	e8 24 e6 ff ff       	call   f0102749 <page_alloc>
    pde_t *u_pgdir = page2kva(s);
f0104125:	e8 87 e2 ff ff       	call   f01023b1 <page2kva>
    boot_map_region(u_pgdir, UPAGES, ROUNDUP((sizeof(struct PageInfo) * npages), PGSIZE), PADDR(pages), (PTE_U | PTE_P));
f010412a:	8b 15 d4 86 11 f0    	mov    0xf01186d4,%edx
pde_t *
setupkvm()
{   
    struct PageInfo *s;
    s = page_alloc(ALLOC_ZERO);
    pde_t *u_pgdir = page2kva(s);
f0104130:	89 c3                	mov    %eax,%ebx
    boot_map_region(u_pgdir, UPAGES, ROUNDUP((sizeof(struct PageInfo) * npages), PGSIZE), PADDR(pages), (PTE_U | PTE_P));
f0104132:	b8 a3 02 00 00       	mov    $0x2a3,%eax
f0104137:	e8 5a e5 ff ff       	call   f0102696 <_paddr.clone.0>
f010413c:	8b 15 c8 86 11 f0    	mov    0xf01186c8,%edx
f0104142:	5e                   	pop    %esi
f0104143:	8d 0c d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%ecx
f010414a:	5a                   	pop    %edx
f010414b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0104151:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0104156:	6a 05                	push   $0x5
f0104158:	50                   	push   %eax
f0104159:	89 d8                	mov    %ebx,%eax
f010415b:	e8 f0 e6 ff ff       	call   f0102850 <boot_map_region>
    boot_map_region(u_pgdir,KSTACKTOP - KSTKSIZE,KSTKSIZE,PADDR(bootstack),PTE_W);
f0104160:	ba 00 d0 10 f0       	mov    $0xf010d000,%edx
f0104165:	b8 a4 02 00 00       	mov    $0x2a4,%eax
f010416a:	e8 27 e5 ff ff       	call   f0102696 <_paddr.clone.0>
f010416f:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0104174:	5e                   	pop    %esi
f0104175:	5a                   	pop    %edx
f0104176:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f010417b:	6a 02                	push   $0x2
f010417d:	50                   	push   %eax
f010417e:	89 d8                	mov    %ebx,%eax
f0104180:	e8 cb e6 ff ff       	call   f0102850 <boot_map_region>
    boot_map_region(u_pgdir,KERNBASE,0xffffffff-KERNBASE,0,PTE_W);
f0104185:	89 d8                	mov    %ebx,%eax
f0104187:	5a                   	pop    %edx
f0104188:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f010418d:	59                   	pop    %ecx
f010418e:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
f0104193:	6a 02                	push   $0x2
f0104195:	6a 00                	push   $0x0
f0104197:	e8 b4 e6 ff ff       	call   f0102850 <boot_map_region>
    boot_map_region(u_pgdir, IOPHYSMEM, ROUNDUP((EXTPHYSMEM - IOPHYSMEM), PGSIZE), IOPHYSMEM, (PTE_W) | (PTE_P));
f010419c:	b9 00 00 06 00       	mov    $0x60000,%ecx
f01041a1:	ba 00 00 0a 00       	mov    $0xa0000,%edx
f01041a6:	5e                   	pop    %esi
f01041a7:	58                   	pop    %eax
f01041a8:	89 d8                	mov    %ebx,%eax
f01041aa:	6a 03                	push   $0x3
f01041ac:	68 00 00 0a 00       	push   $0xa0000
f01041b1:	e8 9a e6 ff ff       	call   f0102850 <boot_map_region>
    boot_map_region(pgdir, KSTACKTOP-KSTKSIZE, KSTKSIZE, PADDR(bootstack), (PTE_W)); 
    boot_map_region(pgdir, KERNBASE, (1<<32)-KERNBASE, 0, (PTE_W));
    boot_map_region(pgdir, IOPHYSMEM, ROUNDUP((EXTPHYSMEM - IOPHYSMEM), PGSIZE), IOPHYSMEM, (PTE_W));
    */
    //lab6
    uint32_t kstacktop_i = KSTACKTOP - cpunum() * (KSTKSIZE + KSTKGAP);
f01041b6:	e8 bc 09 00 00       	call   f0104b77 <cpunum>
f01041bb:	89 c6                	mov    %eax,%esi

    boot_map_region(u_pgdir, 
                     ROUNDDOWN(kstacktop_i, PGSIZE) - KSTKSIZE,
                     KSTKSIZE, 
                     PADDR(percpu_kstacks[cpunum()]),
f01041bd:	e8 b5 09 00 00       	call   f0104b77 <cpunum>
    boot_map_region(pgdir, KSTACKTOP-KSTKSIZE, KSTKSIZE, PADDR(bootstack), (PTE_W)); 
    boot_map_region(pgdir, KERNBASE, (1<<32)-KERNBASE, 0, (PTE_W));
    boot_map_region(pgdir, IOPHYSMEM, ROUNDUP((EXTPHYSMEM - IOPHYSMEM), PGSIZE), IOPHYSMEM, (PTE_W));
    */
    //lab6
    uint32_t kstacktop_i = KSTACKTOP - cpunum() * (KSTKSIZE + KSTKGAP);
f01041c2:	69 f6 00 00 ff ff    	imul   $0xffff0000,%esi,%esi

    boot_map_region(u_pgdir, 
                     ROUNDDOWN(kstacktop_i, PGSIZE) - KSTKSIZE,
                     KSTKSIZE, 
                     PADDR(percpu_kstacks[cpunum()]),
f01041c8:	c1 e0 0f             	shl    $0xf,%eax
    boot_map_region(pgdir, IOPHYSMEM, ROUNDUP((EXTPHYSMEM - IOPHYSMEM), PGSIZE), IOPHYSMEM, (PTE_W));
    */
    //lab6
    uint32_t kstacktop_i = KSTACKTOP - cpunum() * (KSTKSIZE + KSTKGAP);

    boot_map_region(u_pgdir, 
f01041cb:	8d 90 00 a0 11 f0    	lea    -0xfee6000(%eax),%edx
f01041d1:	b8 b8 02 00 00       	mov    $0x2b8,%eax
f01041d6:	e8 bb e4 ff ff       	call   f0102696 <_paddr.clone.0>
f01041db:	5a                   	pop    %edx
f01041dc:	59                   	pop    %ecx
f01041dd:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01041e2:	8d 96 00 80 ff ef    	lea    -0x10008000(%esi),%edx
f01041e8:	6a 02                	push   $0x2
f01041ea:	50                   	push   %eax
f01041eb:	89 d8                	mov    %ebx,%eax
f01041ed:	e8 5e e6 ff ff       	call   f0102850 <boot_map_region>
                     PADDR(percpu_kstacks[cpunum()]),
                     PTE_W
                    );


    boot_map_region(u_pgdir, MMIOBASE + (3) * PGSIZE, PGSIZE, lapicaddr, PTE_PCD|PTE_PWT|PTE_W);
f01041f2:	89 d8                	mov    %ebx,%eax
f01041f4:	ba 00 30 80 ef       	mov    $0xef803000,%edx
f01041f9:	59                   	pop    %ecx
f01041fa:	b9 00 10 00 00       	mov    $0x1000,%ecx
f01041ff:	5e                   	pop    %esi
f0104200:	6a 1a                	push   $0x1a
f0104202:	ff 35 5c 8a 11 f0    	pushl  0xf0118a5c
f0104208:	e8 43 e6 ff ff       	call   f0102850 <boot_map_region>

    return u_pgdir;
}
f010420d:	89 d8                	mov    %ebx,%eax
f010420f:	83 c4 14             	add    $0x14,%esp
f0104212:	5b                   	pop    %ebx
f0104213:	5e                   	pop    %esi
f0104214:	c3                   	ret    

f0104215 <sys_get_num_free_page>:
 * Please maintain num_free_pages yourself
 */
/* This is the system call implementation of get_num_free_page */
int32_t
sys_get_num_free_page(void)
{
f0104215:	53                   	push   %ebx
/* TODO: Lab 5
 * Please maintain num_free_pages yourself
 */
/* This is the system call implementation of get_num_free_page */
int32_t
sys_get_num_free_page(void)
f0104216:	8b 0d c8 86 11 f0    	mov    0xf01186c8,%ecx
{
    int i = 0;
    num_free_pages = 0;
    for(i=0;i<npages;i++)
f010421c:	31 c0                	xor    %eax,%eax
    {
        if(pages[i].pp_ref==0)
f010421e:	8b 1d d4 86 11 f0    	mov    0xf01186d4,%ebx
int32_t
sys_get_num_free_page(void)
{
    int i = 0;
    num_free_pages = 0;
    for(i=0;i<npages;i++)
f0104224:	31 d2                	xor    %edx,%edx
f0104226:	eb 0a                	jmp    f0104232 <sys_get_num_free_page+0x1d>
    {
        if(pages[i].pp_ref==0)
            num_free_pages++;
f0104228:	66 83 7c d3 04 01    	cmpw   $0x1,0x4(%ebx,%edx,8)
f010422e:	83 d0 00             	adc    $0x0,%eax
int32_t
sys_get_num_free_page(void)
{
    int i = 0;
    num_free_pages = 0;
    for(i=0;i<npages;i++)
f0104231:	42                   	inc    %edx
f0104232:	39 ca                	cmp    %ecx,%edx
f0104234:	75 f2                	jne    f0104228 <sys_get_num_free_page+0x13>
f0104236:	a3 d0 86 11 f0       	mov    %eax,0xf01186d0
    {
        if(pages[i].pp_ref==0)
            num_free_pages++;
    }
    return num_free_pages;
}
f010423b:	5b                   	pop    %ebx
f010423c:	c3                   	ret    

f010423d <sys_get_num_used_page>:

/* This is the system call implementation of get_num_used_page */
int32_t
sys_get_num_used_page(void)
{
    num_free_pages = sys_get_num_free_page();
f010423d:	e8 d3 ff ff ff       	call   f0104215 <sys_get_num_free_page>
f0104242:	89 c2                	mov    %eax,%edx
f0104244:	a3 d0 86 11 f0       	mov    %eax,0xf01186d0
    return npages - num_free_pages; 
f0104249:	a1 c8 86 11 f0       	mov    0xf01186c8,%eax
f010424e:	29 d0                	sub    %edx,%eax
}
f0104250:	c3                   	ret    
f0104251:	00 00                	add    %al,(%eax)
	...

f0104254 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0104254:	56                   	push   %esi
f0104255:	53                   	push   %ebx
f0104256:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	if (panicstr)
f0104259:	83 3d d8 86 11 f0 00 	cmpl   $0x0,0xf01186d8
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0104260:	8b 5c 24 18          	mov    0x18(%esp),%ebx
	va_list ap;

	if (panicstr)
f0104264:	75 37                	jne    f010429d <_panic+0x49>
		goto dead;
	panicstr = fmt;
f0104266:	89 1d d8 86 11 f0    	mov    %ebx,0xf01186d8

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");
f010426c:	fa                   	cli    
f010426d:	fc                   	cld    

	va_start(ap, fmt);
f010426e:	8d 74 24 1c          	lea    0x1c(%esp),%esi
	printk("kernel panic at %s:%d: ", file, line);
f0104272:	51                   	push   %ecx
f0104273:	ff 74 24 18          	pushl  0x18(%esp)
f0104277:	ff 74 24 18          	pushl  0x18(%esp)
f010427b:	68 00 77 10 f0       	push   $0xf0107700
f0104280:	e8 a3 e0 ff ff       	call   f0102328 <printk>
	vprintk(fmt, ap);
f0104285:	58                   	pop    %eax
f0104286:	5a                   	pop    %edx
f0104287:	56                   	push   %esi
f0104288:	53                   	push   %ebx
f0104289:	e8 70 e0 ff ff       	call   f01022fe <vprintk>
	printk("\n");
f010428e:	c7 04 24 52 68 10 f0 	movl   $0xf0106852,(%esp)
f0104295:	e8 8e e0 ff ff       	call   f0102328 <printk>
	va_end(ap);
f010429a:	83 c4 10             	add    $0x10,%esp
f010429d:	eb fe                	jmp    f010429d <_panic+0x49>

f010429f <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f010429f:	53                   	push   %ebx
f01042a0:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f01042a3:	8d 5c 24 1c          	lea    0x1c(%esp),%ebx
	printk("kernel warning at %s:%d: ", file, line);
f01042a7:	51                   	push   %ecx
f01042a8:	ff 74 24 18          	pushl  0x18(%esp)
f01042ac:	ff 74 24 18          	pushl  0x18(%esp)
f01042b0:	68 18 77 10 f0       	push   $0xf0107718
f01042b5:	e8 6e e0 ff ff       	call   f0102328 <printk>
	vprintk(fmt, ap);
f01042ba:	58                   	pop    %eax
f01042bb:	5a                   	pop    %edx
f01042bc:	53                   	push   %ebx
f01042bd:	ff 74 24 24          	pushl  0x24(%esp)
f01042c1:	e8 38 e0 ff ff       	call   f01022fe <vprintk>
	printk("\n");
f01042c6:	c7 04 24 52 68 10 f0 	movl   $0xf0106852,(%esp)
f01042cd:	e8 56 e0 ff ff       	call   f0102328 <printk>
	va_end(ap);
}
f01042d2:	83 c4 18             	add    $0x18,%esp
f01042d5:	5b                   	pop    %ebx
f01042d6:	c3                   	ret    
	...

f01042d8 <mc146818_read>:
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01042d8:	8b 44 24 04          	mov    0x4(%esp),%eax
f01042dc:	ba 70 00 00 00       	mov    $0x70,%edx
f01042e1:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01042e2:	b2 71                	mov    $0x71,%dl
f01042e4:	ec                   	in     (%dx),%al

unsigned
mc146818_read(unsigned reg)
{
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f01042e5:	0f b6 c0             	movzbl %al,%eax
}
f01042e8:	c3                   	ret    

f01042e9 <mc146818_write>:
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01042e9:	ba 70 00 00 00       	mov    $0x70,%edx
f01042ee:	8b 44 24 04          	mov    0x4(%esp),%eax
f01042f2:	ee                   	out    %al,(%dx)
f01042f3:	b2 71                	mov    $0x71,%dl
f01042f5:	8b 44 24 08          	mov    0x8(%esp),%eax
f01042f9:	ee                   	out    %al,(%dx)
void
mc146818_write(unsigned reg, unsigned datum)
{
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f01042fa:	c3                   	ret    
	...

f01042fc <timer_handler>:
// TODO: Lab6
// Modify your timer_handler to support Multi processor
// Don't forget to acknowledge the interrupt using lapic_eoi()
//
void timer_handler(struct Trapframe *tf)
{
f01042fc:	53                   	push   %ebx
f01042fd:	83 ec 08             	sub    $0x8,%esp
  extern void sched_yield();
  extern struct CpuInfo cpus[NCPU];
//  extern int cpunum();
  int f ;
f0104300:	ff 05 28 5e 11 f0    	incl   0xf0115e28
  f=cpunum();
  int i;
  jiffies++;
  lapic_eoi();
//	cprintf("cpu %d tick %d\n",cpunum(),jiffies);
	//lapic_eoi();	
f0104306:	83 3d 2c 5e 11 f0 00 	cmpl   $0x0,0xf0115e2c
f010430d:	74 4d                	je     f010435c <timer_handler+0x60>
f010430f:	31 db                	xor    %ebx,%ebx
   * 
   * 2. Change the state of the task if needed
   *
   * 3. Maintain the time quantum of the current task
   *
   * 4. sched_yield() if the time is up for current task
f0104311:	83 bb 2c 87 11 f0 03 	cmpl   $0x3,-0xfee78d4(%ebx)
f0104318:	75 1b                	jne    f0104335 <timer_handler+0x39>
   *
   *
f010431a:	8b 83 28 87 11 f0    	mov    -0xfee78d8(%ebx),%eax
f0104320:	48                   	dec    %eax
	for(i = 0 ; i<NR_TASKS ; i++)
f0104321:	85 c0                	test   %eax,%eax
   *
   * 3. Maintain the time quantum of the current task
   *
   * 4. sched_yield() if the time is up for current task
   *
   *
f0104323:	89 83 28 87 11 f0    	mov    %eax,-0xfee78d8(%ebx)
	for(i = 0 ; i<NR_TASKS ; i++)
f0104329:	75 0a                	jne    f0104335 <timer_handler+0x39>
	{
f010432b:	c7 83 2c 87 11 f0 01 	movl   $0x1,-0xfee78d4(%ebx)
f0104332:	00 00 00 
		switch(tasks[i].state) {
		case TASK_SLEEP:
f0104335:	a1 2c 5e 11 f0       	mov    0xf0115e2c,%eax
f010433a:	8b 50 4c             	mov    0x4c(%eax),%edx
f010433d:	4a                   	dec    %edx
			tasks[i].remind_ticks --;
f010433e:	85 d2                	test   %edx,%edx
   *
   *
	for(i = 0 ; i<NR_TASKS ; i++)
	{
		switch(tasks[i].state) {
		case TASK_SLEEP:
f0104340:	89 50 4c             	mov    %edx,0x4c(%eax)
			tasks[i].remind_ticks --;
f0104343:	75 0c                	jne    f0104351 <timer_handler+0x55>
			if(tasks[i].remind_ticks <= 0)
			{
f0104345:	c7 40 50 01 00 00 00 	movl   $0x1,0x50(%eax)
				tasks[i].state = TASK_RUNNABLE;
f010434c:	e8 2f 06 00 00       	call   f0104980 <sched_yield>
f0104351:	83 c3 58             	add    $0x58,%ebx
  * TODO: Lab 5
   * 1. Maintain the status of slept tasks
   * 
   * 2. Change the state of the task if needed
   *
   * 3. Maintain the time quantum of the current task
f0104354:	81 fb 70 03 00 00    	cmp    $0x370,%ebx
f010435a:	75 b5                	jne    f0104311 <timer_handler+0x15>
				tasks[i].state = TASK_RUNNABLE;
				tasks[i].remind_ticks = TIME_QUANT;
			}
			break;
		case TASK_RUNNING:
			tasks[i].remind_ticks --;
f010435c:	83 c4 08             	add    $0x8,%esp
f010435f:	5b                   	pop    %ebx
f0104360:	c3                   	ret    

f0104361 <set_timer>:

static unsigned long jiffies = 0;

void set_timer(int hz)
{
  int divisor = 1193180 / hz;       /* Calculate our divisor */
f0104361:	b9 dc 34 12 00       	mov    $0x1234dc,%ecx
f0104366:	89 c8                	mov    %ecx,%eax
f0104368:	99                   	cltd   
f0104369:	f7 7c 24 04          	idivl  0x4(%esp)
f010436d:	ba 43 00 00 00       	mov    $0x43,%edx
f0104372:	89 c1                	mov    %eax,%ecx
f0104374:	b0 36                	mov    $0x36,%al
f0104376:	ee                   	out    %al,(%dx)
f0104377:	b2 40                	mov    $0x40,%dl
f0104379:	88 c8                	mov    %cl,%al
f010437b:	ee                   	out    %al,(%dx)
  outb(0x43, 0x36);             /* Set our command byte 0x36 */
  outb(0x40, divisor & 0xFF);   /* Set low byte of divisor */
  outb(0x40, divisor >> 8);     /* Set high byte of divisor */
f010437c:	89 c8                	mov    %ecx,%eax
f010437e:	c1 f8 08             	sar    $0x8,%eax
f0104381:	ee                   	out    %al,(%dx)
}
f0104382:	c3                   	ret    

f0104383 <sys_get_ticks>:
			break;
		}
	}
	if(cur_task->remind_ticks <=0)
	{
		sched_yield();
f0104383:	a1 28 5e 11 f0       	mov    0xf0115e28,%eax
f0104388:	c3                   	ret    

f0104389 <timer_init>:
	}
  }*/
f0104389:	83 ec 0c             	sub    $0xc,%esp
	for(i=0;i<NR_TASKS;i++)
f010438c:	6a 64                	push   $0x64
f010438e:	e8 ce ff ff ff       	call   f0104361 <set_timer>
	{
		if(cpus[f].cpu_rq.task_rq[i]!=NULL)
		{
f0104393:	50                   	push   %eax
f0104394:	50                   	push   %eax
f0104395:	0f b7 05 48 80 10 f0 	movzwl 0xf0108048,%eax
f010439c:	25 fe ff 00 00       	and    $0xfffe,%eax
f01043a1:	50                   	push   %eax
f01043a2:	e8 c9 d6 ff ff       	call   f0101a70 <irq_setmask_8259A>
		switch( cpus[f].cpu_rq.task_rq[i]->state)
			{
			case TASK_SLEEP:
				cpus[f].cpu_rq.task_rq[i]->remind_ticks--;
f01043a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01043ae:	6a 00                	push   $0x0
f01043b0:	68 94 22 10 f0       	push   $0xf0102294
f01043b5:	68 fc 42 10 f0       	push   $0xf01042fc
f01043ba:	6a 20                	push   $0x20
f01043bc:	e8 dc dc ff ff       	call   f010209d <register_handler>
				if(cpus[f].cpu_rq.task_rq[i]->remind_ticks<=0)
f01043c1:	83 c4 2c             	add    $0x2c,%esp
f01043c4:	c3                   	ret    
f01043c5:	00 00                	add    %al,(%eax)
	...

f01043c8 <task_create>:
 *
 * 6. Return the pid of the newly created task.
 
 */
int task_create()
{
f01043c8:	57                   	push   %edi
            break;
        }
    
    }
    if(i==NR_TASKS)
        return -1;
f01043c9:	b8 2c 87 11 f0       	mov    $0xf011872c,%eax
 *
 * 6. Return the pid of the newly created task.
 
 */
int task_create()
{
f01043ce:	56                   	push   %esi
f01043cf:	53                   	push   %ebx
	Task *ts = NULL;

	/* Find a free task structure */
    int i;
    for(i =0;i<NR_TASKS;i++)  
f01043d0:	31 db                	xor    %ebx,%ebx
    {
        if(tasks[i].state==TASK_FREE)
f01043d2:	83 38 00             	cmpl   $0x0,(%eax)
f01043d5:	75 13                	jne    f01043ea <task_create+0x22>
        {
            ts = &(tasks[i]);
f01043d7:	6b f3 58             	imul   $0x58,%ebx,%esi
            break;
        }
    
    }
    if(i==NR_TASKS)
f01043da:	83 fb 0a             	cmp    $0xa,%ebx
    int i;
    for(i =0;i<NR_TASKS;i++)  
    {
        if(tasks[i].state==TASK_FREE)
        {
            ts = &(tasks[i]);
f01043dd:	8d be dc 86 11 f0    	lea    -0xfee7924(%esi),%edi
            break;
        }
    
    }
    if(i==NR_TASKS)
f01043e3:	75 13                	jne    f01043f8 <task_create+0x30>
f01043e5:	e9 e4 00 00 00       	jmp    f01044ce <task_create+0x106>
{
	Task *ts = NULL;

	/* Find a free task structure */
    int i;
    for(i =0;i<NR_TASKS;i++)  
f01043ea:	43                   	inc    %ebx
f01043eb:	83 c0 58             	add    $0x58,%eax
f01043ee:	83 fb 0a             	cmp    $0xa,%ebx
f01043f1:	75 df                	jne    f01043d2 <task_create+0xa>
f01043f3:	e9 d6 00 00 00       	jmp    f01044ce <task_create+0x106>
    
    }
    if(i==NR_TASKS)
        return -1;
  /* Setup Page Directory and pages for kernel*/
  if (!(ts->pgdir = setupkvm()))
f01043f8:	e8 1c fd ff ff       	call   f0104119 <setupkvm>
f01043fd:	85 c0                	test   %eax,%eax
f01043ff:	89 86 30 87 11 f0    	mov    %eax,-0xfee78d0(%esi)
f0104405:	be 00 40 bf ee       	mov    $0xeebf4000,%esi
f010440a:	75 12                	jne    f010441e <task_create+0x56>
    panic("Not enough memory for per process page directory!\n");
f010440c:	52                   	push   %edx
f010440d:	68 32 77 10 f0       	push   $0xf0107732
f0104412:	6a 76                	push   $0x76
f0104414:	68 65 77 10 f0       	push   $0xf0107765
f0104419:	e8 36 fe ff ff       	call   f0104254 <_panic>
  /* Setup User Stack */
    int j;
    struct PageInfo *u_stack;
    for(j = 0;j<USR_STACK_SIZE/PGSIZE;j++)
    {
        u_stack = page_alloc(ALLOC_ZERO);
f010441e:	83 ec 0c             	sub    $0xc,%esp
f0104421:	6a 01                	push   $0x1
f0104423:	e8 21 e3 ff ff       	call   f0102749 <page_alloc>
        if(u_stack==NULL)
f0104428:	83 c4 10             	add    $0x10,%esp
f010442b:	85 c0                	test   %eax,%eax
f010442d:	0f 84 9b 00 00 00    	je     f01044ce <task_create+0x106>
            return -1;
        page_insert(ts->pgdir,u_stack,(void *)USTACKTOP-USR_STACK_SIZE+PGSIZE*j,PTE_W|PTE_U);
f0104433:	6a 06                	push   $0x6
f0104435:	56                   	push   %esi
f0104436:	81 c6 00 10 00 00    	add    $0x1000,%esi
f010443c:	50                   	push   %eax
f010443d:	ff 77 54             	pushl  0x54(%edi)
f0104440:	e8 d4 e4 ff ff       	call   f0102919 <page_insert>
    panic("Not enough memory for per process page directory!\n");

  /* Setup User Stack */
    int j;
    struct PageInfo *u_stack;
    for(j = 0;j<USR_STACK_SIZE/PGSIZE;j++)
f0104445:	83 c4 10             	add    $0x10,%esp
f0104448:	81 fe 00 e0 bf ee    	cmp    $0xeebfe000,%esi
f010444e:	75 ce                	jne    f010441e <task_create+0x56>
        if(u_stack==NULL)
            return -1;
        page_insert(ts->pgdir,u_stack,(void *)USTACKTOP-USR_STACK_SIZE+PGSIZE*j,PTE_W|PTE_U);
    }
	/* Setup Trapframe */
	memset( &(ts->tf), 0, sizeof(ts->tf));
f0104450:	6b f3 58             	imul   $0x58,%ebx,%esi
f0104453:	50                   	push   %eax
f0104454:	6a 44                	push   $0x44
f0104456:	6a 00                	push   $0x0
f0104458:	8d be dc 86 11 f0    	lea    -0xfee7924(%esi),%edi
f010445e:	8d 47 08             	lea    0x8(%edi),%eax
f0104461:	50                   	push   %eax
f0104462:	e8 68 bd ff ff       	call   f01001cf <memset>

	ts->tf.tf_cs = GD_UT | 0x03;
	ts->tf.tf_ds = GD_UD | 0x03;
f0104467:	8d 86 fc 86 11 f0    	lea    -0xfee7904(%esi),%eax

	/* Setup task structure (task_id and parent_id) */
    ts->task_id = i;
    ts->remind_ticks =TIME_QUANT;
    ts->state = TASK_RUNNABLE;
    if(cur_task==NULL)
f010446d:	83 c4 10             	add    $0x10,%esp
    }
	/* Setup Trapframe */
	memset( &(ts->tf), 0, sizeof(ts->tf));

	ts->tf.tf_cs = GD_UT | 0x03;
	ts->tf.tf_ds = GD_UD | 0x03;
f0104470:	66 c7 40 0c 23 00    	movw   $0x23,0xc(%eax)
	ts->tf.tf_es = GD_UD | 0x03;
f0104476:	66 c7 40 08 23 00    	movw   $0x23,0x8(%eax)

	/* Setup task structure (task_id and parent_id) */
    ts->task_id = i;
    ts->remind_ticks =TIME_QUANT;
    ts->state = TASK_RUNNABLE;
    if(cur_task==NULL)
f010447c:	a1 2c 5e 11 f0       	mov    0xf0115e2c,%eax
        page_insert(ts->pgdir,u_stack,(void *)USTACKTOP-USR_STACK_SIZE+PGSIZE*j,PTE_W|PTE_U);
    }
	/* Setup Trapframe */
	memset( &(ts->tf), 0, sizeof(ts->tf));

	ts->tf.tf_cs = GD_UT | 0x03;
f0104481:	66 c7 86 18 87 11 f0 	movw   $0x1b,-0xfee78e8(%esi)
f0104488:	1b 00 
	ts->tf.tf_ds = GD_UD | 0x03;
	ts->tf.tf_es = GD_UD | 0x03;
	ts->tf.tf_ss = GD_UD | 0x03;
f010448a:	66 c7 86 24 87 11 f0 	movw   $0x23,-0xfee78dc(%esi)
f0104491:	23 00 
	ts->tf.tf_esp = USTACKTOP-PGSIZE;
f0104493:	c7 86 20 87 11 f0 00 	movl   $0xeebfd000,-0xfee78e0(%esi)
f010449a:	d0 bf ee 

	/* Setup task structure (task_id and parent_id) */
    ts->task_id = i;
    ts->remind_ticks =TIME_QUANT;
    ts->state = TASK_RUNNABLE;
    if(cur_task==NULL)
f010449d:	85 c0                	test   %eax,%eax
	ts->tf.tf_es = GD_UD | 0x03;
	ts->tf.tf_ss = GD_UD | 0x03;
	ts->tf.tf_esp = USTACKTOP-PGSIZE;

	/* Setup task structure (task_id and parent_id) */
    ts->task_id = i;
f010449f:	89 9e dc 86 11 f0    	mov    %ebx,-0xfee7924(%esi)
    ts->remind_ticks =TIME_QUANT;
f01044a5:	c7 86 28 87 11 f0 64 	movl   $0x64,-0xfee78d8(%esi)
f01044ac:	00 00 00 
    ts->state = TASK_RUNNABLE;
f01044af:	c7 47 50 01 00 00 00 	movl   $0x1,0x50(%edi)
    if(cur_task==NULL)
f01044b6:	75 0c                	jne    f01044c4 <task_create+0xfc>
        ts->parent_id=0;
f01044b8:	c7 86 e0 86 11 f0 00 	movl   $0x0,-0xfee7920(%esi)
f01044bf:	00 00 00 
f01044c2:	eb 0d                	jmp    f01044d1 <task_create+0x109>
    else
       ts->parent_id = cur_task->task_id;
f01044c4:	8b 00                	mov    (%eax),%eax
f01044c6:	89 86 e0 86 11 f0    	mov    %eax,-0xfee7920(%esi)
f01044cc:	eb 03                	jmp    f01044d1 <task_create+0x109>
    struct PageInfo *u_stack;
    for(j = 0;j<USR_STACK_SIZE/PGSIZE;j++)
    {
        u_stack = page_alloc(ALLOC_ZERO);
        if(u_stack==NULL)
            return -1;
f01044ce:	83 cb ff             	or     $0xffffffff,%ebx
    if(cur_task==NULL)
        ts->parent_id=0;
    else
       ts->parent_id = cur_task->task_id;
    return i;
}
f01044d1:	89 d8                	mov    %ebx,%eax
f01044d3:	5b                   	pop    %ebx
f01044d4:	5e                   	pop    %esi
f01044d5:	5f                   	pop    %edi
f01044d6:	c3                   	ret    

f01044d7 <sys_kill>:
// Modify it so that the task will be removed form cpu runqueue
// ( we not implement signal yet so do not try to kill process
// running on other cpu )
//
void sys_kill(int pid)
{
f01044d7:	57                   	push   %edi
f01044d8:	56                   	push   %esi
f01044d9:	53                   	push   %ebx
	if (pid > 0 && pid < NR_TASKS)
f01044da:	8b 44 24 10          	mov    0x10(%esp),%eax
f01044de:	48                   	dec    %eax
f01044df:	83 f8 08             	cmp    $0x8,%eax
f01044e2:	0f 87 81 00 00 00    	ja     f0104569 <sys_kill+0x92>
	/* TODO: Lab 5
   * Remember to change the state of tasks
   * Free the memory
   * and invoke the scheduler for yield
   */
        cur_task->state = TASK_STOP;
f01044e8:	a1 2c 5e 11 f0       	mov    0xf0115e2c,%eax
f01044ed:	c7 40 50 04 00 00 00 	movl   $0x4,0x50(%eax)
        task_free(cur_task->task_id);
f01044f4:	8b 38                	mov    (%eax),%edi


static void task_free(int pid)
{
    
    lcr3(PADDR(kern_pgdir));
f01044f6:	a1 cc 86 11 f0       	mov    0xf01186cc,%eax
/* -------------- Inline Functions --------------  */

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01044fb:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104500:	77 15                	ja     f0104517 <sys_kill+0x40>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104502:	50                   	push   %eax
f0104503:	68 f6 64 10 f0       	push   $0xf01064f6
f0104508:	68 ad 00 00 00       	push   $0xad
f010450d:	68 65 77 10 f0       	push   $0xf0107765
f0104512:	e8 3d fd ff ff       	call   f0104254 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0104517:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f010451c:	0f 22 d8             	mov    %eax,%cr3
    int i;
    for(i = 0;i<USR_STACK_SIZE/PGSIZE;i++)
        page_remove(tasks[pid].pgdir,(void *)USTACKTOP-USR_STACK_SIZE+i*PGSIZE);
f010451f:	6b ff 58             	imul   $0x58,%edi,%edi
f0104522:	bb 00 40 bf ee       	mov    $0xeebf4000,%ebx
f0104527:	81 c7 e0 86 11 f0    	add    $0xf01186e0,%edi
f010452d:	56                   	push   %esi
f010452e:	56                   	push   %esi
f010452f:	53                   	push   %ebx
f0104530:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0104536:	ff 77 50             	pushl  0x50(%edi)
f0104539:	8d 77 50             	lea    0x50(%edi),%esi
f010453c:	e8 9c e3 ff ff       	call   f01028dd <page_remove>
static void task_free(int pid)
{
    
    lcr3(PADDR(kern_pgdir));
    int i;
    for(i = 0;i<USR_STACK_SIZE/PGSIZE;i++)
f0104541:	83 c4 10             	add    $0x10,%esp
f0104544:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
f010454a:	75 e1                	jne    f010452d <sys_kill+0x56>
        page_remove(tasks[pid].pgdir,(void *)USTACKTOP-USR_STACK_SIZE+i*PGSIZE);
    ptable_remove(tasks[pid].pgdir);
f010454c:	83 ec 0c             	sub    $0xc,%esp
f010454f:	ff 36                	pushl  (%esi)
f0104551:	e8 1e e4 ff ff       	call   f0102974 <ptable_remove>

    pgdir_remove(tasks[pid].pgdir);
f0104556:	59                   	pop    %ecx
f0104557:	ff 36                	pushl  (%esi)
f0104559:	e8 4d e4 ff ff       	call   f01029ab <pgdir_remove>
   * Free the memory
   * and invoke the scheduler for yield
   */
        cur_task->state = TASK_STOP;
        task_free(cur_task->task_id);
        sched_yield();
f010455e:	83 c4 10             	add    $0x10,%esp
	}
}
f0104561:	5b                   	pop    %ebx
f0104562:	5e                   	pop    %esi
f0104563:	5f                   	pop    %edi
   * Free the memory
   * and invoke the scheduler for yield
   */
        cur_task->state = TASK_STOP;
        task_free(cur_task->task_id);
        sched_yield();
f0104564:	e9 17 04 00 00       	jmp    f0104980 <sched_yield>
	}
}
f0104569:	5b                   	pop    %ebx
f010456a:	5e                   	pop    %esi
f010456b:	5f                   	pop    %edi
f010456c:	c3                   	ret    

f010456d <sys_fork>:
//
// Modify it so that the task will disptach to different cpu runqueue
// (please try to load balance, don't put all task into one cpu)
//
int sys_fork()
{
f010456d:	55                   	push   %ebp
f010456e:	57                   	push   %edi
f010456f:	56                   	push   %esi
f0104570:	53                   	push   %ebx
f0104571:	83 ec 1c             	sub    $0x1c,%esp
  /* pid for newly created process */
  int pid,i;
  pid = task_create();
f0104574:	e8 4f fe ff ff       	call   f01043c8 <task_create>
  uint32_t src_addr, dst_addr, *src, *dst;
  if(pid<0)
f0104579:	85 c0                	test   %eax,%eax
//
int sys_fork()
{
  /* pid for newly created process */
  int pid,i;
  pid = task_create();
f010457b:	89 44 24 08          	mov    %eax,0x8(%esp)
  uint32_t src_addr, dst_addr, *src, *dst;
  if(pid<0)
f010457f:	0f 88 36 01 00 00    	js     f01046bb <sys_fork+0x14e>
      return -1;
        if ((uint32_t)cur_task)
f0104585:	8b 35 2c 5e 11 f0    	mov    0xf0115e2c,%esi
f010458b:	85 f6                	test   %esi,%esi
f010458d:	0f 84 30 01 00 00    	je     f01046c3 <sys_fork+0x156>
        {
            tasks[pid].tf = cur_task->tf;
f0104593:	6b e8 58             	imul   $0x58,%eax,%ebp
f0104596:	83 c6 08             	add    $0x8,%esi
f0104599:	b9 11 00 00 00       	mov    $0x11,%ecx
            for(i = 0; i < USR_STACK_SIZE/PGSIZE; i++)
            {
                src = pgdir_walk(cur_task->pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
                src_addr = PTE_ADDR(*src);
                dst = pgdir_walk(tasks[pid].pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
f010459e:	8d 85 e0 86 11 f0    	lea    -0xfee7920(%ebp),%eax
  uint32_t src_addr, dst_addr, *src, *dst;
  if(pid<0)
      return -1;
        if ((uint32_t)cur_task)
        {
            tasks[pid].tf = cur_task->tf;
f01045a4:	8d bd e4 86 11 f0    	lea    -0xfee791c(%ebp),%edi
            for(i = 0; i < USR_STACK_SIZE/PGSIZE; i++)
            {
                src = pgdir_walk(cur_task->pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
                src_addr = PTE_ADDR(*src);
                dst = pgdir_walk(tasks[pid].pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
f01045aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  uint32_t src_addr, dst_addr, *src, *dst;
  if(pid<0)
      return -1;
        if ((uint32_t)cur_task)
        {
            tasks[pid].tf = cur_task->tf;
f01045ae:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f01045b0:	bf 00 40 bf ee       	mov    $0xeebf4000,%edi
            for(i = 0; i < USR_STACK_SIZE/PGSIZE; i++)
            {
                src = pgdir_walk(cur_task->pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
f01045b5:	a1 2c 5e 11 f0       	mov    0xf0115e2c,%eax
f01045ba:	51                   	push   %ecx
f01045bb:	6a 00                	push   $0x0
f01045bd:	57                   	push   %edi
f01045be:	ff 70 54             	pushl  0x54(%eax)
f01045c1:	e8 1d e2 ff ff       	call   f01027e3 <pgdir_walk>
                src_addr = PTE_ADDR(*src);
                dst = pgdir_walk(tasks[pid].pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
f01045c6:	83 c4 0c             	add    $0xc,%esp
        {
            tasks[pid].tf = cur_task->tf;
            for(i = 0; i < USR_STACK_SIZE/PGSIZE; i++)
            {
                src = pgdir_walk(cur_task->pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
                src_addr = PTE_ADDR(*src);
f01045c9:	8b 30                	mov    (%eax),%esi
                dst = pgdir_walk(tasks[pid].pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
f01045cb:	6a 00                	push   $0x0
f01045cd:	57                   	push   %edi
f01045ce:	8b 54 24 18          	mov    0x18(%esp),%edx
f01045d2:	8b 5c 24 18          	mov    0x18(%esp),%ebx
        {
            tasks[pid].tf = cur_task->tf;
            for(i = 0; i < USR_STACK_SIZE/PGSIZE; i++)
            {
                src = pgdir_walk(cur_task->pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
                src_addr = PTE_ADDR(*src);
f01045d6:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
                dst = pgdir_walk(tasks[pid].pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
f01045dc:	ff 72 50             	pushl  0x50(%edx)
f01045df:	83 c3 50             	add    $0x50,%ebx
f01045e2:	e8 fc e1 ff ff       	call   f01027e3 <pgdir_walk>
}

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01045e7:	8b 15 c8 86 11 f0    	mov    0xf01186c8,%edx
f01045ed:	89 f1                	mov    %esi,%ecx
f01045ef:	c1 e9 0c             	shr    $0xc,%ecx
f01045f2:	83 c4 10             	add    $0x10,%esp
f01045f5:	39 d1                	cmp    %edx,%ecx
                dst_addr = PTE_ADDR(*dst);
f01045f7:	8b 00                	mov    (%eax),%eax
f01045f9:	72 03                	jb     f01045fe <sys_fork+0x91>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01045fb:	56                   	push   %esi
f01045fc:	eb 0f                	jmp    f010460d <sys_fork+0xa0>
f01045fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0104603:	89 c1                	mov    %eax,%ecx
f0104605:	c1 e9 0c             	shr    $0xc,%ecx
f0104608:	39 d1                	cmp    %edx,%ecx
f010460a:	72 15                	jb     f0104621 <sys_fork+0xb4>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010460c:	50                   	push   %eax
f010460d:	68 e8 6a 10 f0       	push   $0xf0106ae8
f0104612:	68 fb 00 00 00       	push   $0xfb
f0104617:	68 65 77 10 f0       	push   $0xf0107765
f010461c:	e8 33 fc ff ff       	call   f0104254 <_panic>
                memcpy(KADDR(dst_addr), KADDR(src_addr), PGSIZE);
f0104621:	52                   	push   %edx
	return (void *)(pa + KERNBASE);
f0104622:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f0104628:	68 00 10 00 00       	push   $0x1000
f010462d:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0104632:	56                   	push   %esi
f0104633:	81 c7 00 10 00 00    	add    $0x1000,%edi
f0104639:	50                   	push   %eax
f010463a:	e8 6a bc ff ff       	call   f01002a9 <memcpy>
  if(pid<0)
      return -1;
        if ((uint32_t)cur_task)
        {
            tasks[pid].tf = cur_task->tf;
            for(i = 0; i < USR_STACK_SIZE/PGSIZE; i++)
f010463f:	83 c4 10             	add    $0x10,%esp
f0104642:	81 ff 00 e0 bf ee    	cmp    $0xeebfe000,%edi
f0104648:	0f 85 67 ff ff ff    	jne    f01045b5 <sys_fork+0x48>
                dst_addr = PTE_ADDR(*dst);
                memcpy(KADDR(dst_addr), KADDR(src_addr), PGSIZE);
            }
            
        /* Step 4: All user program use the same code for now */
        setupvm(tasks[pid].pgdir, (uint32_t)UTEXT_start, UTEXT_SZ);
f010464e:	57                   	push   %edi
f010464f:	ff 35 58 8a 11 f0    	pushl  0xf0118a58
f0104655:	68 00 00 10 f0       	push   $0xf0100000
f010465a:	ff 33                	pushl  (%ebx)
f010465c:	e8 44 fa ff ff       	call   f01040a5 <setupvm>
        setupvm(tasks[pid].pgdir, (uint32_t)UDATA_start, UDATA_SZ);
f0104661:	83 c4 0c             	add    $0xc,%esp
f0104664:	ff 35 54 8a 11 f0    	pushl  0xf0118a54
f010466a:	68 00 80 10 f0       	push   $0xf0108000
f010466f:	ff 33                	pushl  (%ebx)
f0104671:	e8 2f fa ff ff       	call   f01040a5 <setupvm>
        setupvm(tasks[pid].pgdir, (uint32_t)UBSS_start, UBSS_SZ);
f0104676:	83 c4 0c             	add    $0xc,%esp
f0104679:	ff 35 4c 8a 11 f0    	pushl  0xf0118a4c
f010467f:	68 00 c0 10 f0       	push   $0xf010c000
f0104684:	ff 33                	pushl  (%ebx)
f0104686:	e8 1a fa ff ff       	call   f01040a5 <setupvm>
        setupvm(tasks[pid].pgdir, (uint32_t)URODATA_start, URODATA_SZ);
f010468b:	83 c4 0c             	add    $0xc,%esp
f010468e:	ff 35 50 8a 11 f0    	pushl  0xf0118a50
f0104694:	68 00 60 10 f0       	push   $0xf0106000
f0104699:	ff 33                	pushl  (%ebx)
f010469b:	e8 05 fa ff ff       	call   f01040a5 <setupvm>
        

        cur_task->tf.tf_regs.reg_eax = pid;
f01046a0:	8b 54 24 18          	mov    0x18(%esp),%edx
        tasks[pid].tf.tf_regs.reg_eax = 0;
f01046a4:	83 c4 10             	add    $0x10,%esp
        setupvm(tasks[pid].pgdir, (uint32_t)UDATA_start, UDATA_SZ);
        setupvm(tasks[pid].pgdir, (uint32_t)UBSS_start, UBSS_SZ);
        setupvm(tasks[pid].pgdir, (uint32_t)URODATA_start, URODATA_SZ);
        

        cur_task->tf.tf_regs.reg_eax = pid;
f01046a7:	a1 2c 5e 11 f0       	mov    0xf0115e2c,%eax
f01046ac:	89 50 24             	mov    %edx,0x24(%eax)
        tasks[pid].tf.tf_regs.reg_eax = 0;
f01046af:	c7 85 00 87 11 f0 00 	movl   $0x0,-0xfee7900(%ebp)
f01046b6:	00 00 00 
f01046b9:	eb 08                	jmp    f01046c3 <sys_fork+0x156>
  /* pid for newly created process */
  int pid,i;
  pid = task_create();
  uint32_t src_addr, dst_addr, *src, *dst;
  if(pid<0)
      return -1;
f01046bb:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
f01046c2:	ff 

        cur_task->tf.tf_regs.reg_eax = pid;
        tasks[pid].tf.tf_regs.reg_eax = 0;
        }
    return pid;
}
f01046c3:	8b 44 24 08          	mov    0x8(%esp),%eax
f01046c7:	83 c4 1c             	add    $0x1c,%esp
f01046ca:	5b                   	pop    %ebx
f01046cb:	5e                   	pop    %esi
f01046cc:	5f                   	pop    %edi
f01046cd:	5d                   	pop    %ebp
f01046ce:	c3                   	ret    

f01046cf <task_init_percpu>:
// 3. init per-CPU system registers
//
// 4. init per-CPU TSS
//
void task_init_percpu()
{
f01046cf:	83 ec 10             	sub    $0x10,%esp
	extern int user_entry();
	extern int idle_entry();
	
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	memset(&(tss), 0, sizeof(tss));
f01046d2:	6a 68                	push   $0x68
f01046d4:	6a 00                	push   $0x0
f01046d6:	68 30 5e 11 f0       	push   $0xf0115e30
f01046db:	e8 ef ba ff ff       	call   f01001cf <memset>
	// fs and gs stay in user data segment
	tss.ts_fs = GD_UD | 0x03;
	tss.ts_gs = GD_UD | 0x03;

	/* Setup TSS in GDT */
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t)(&tss), sizeof(struct tss_struct), 0);
f01046e0:	b8 30 5e 11 f0       	mov    $0xf0115e30,%eax
f01046e5:	89 c2                	mov    %eax,%edx
f01046e7:	c1 ea 10             	shr    $0x10,%edx
f01046ea:	66 a3 2a b0 10 f0    	mov    %ax,0xf010b02a
f01046f0:	c1 e8 18             	shr    $0x18,%eax
f01046f3:	88 15 2c b0 10 f0    	mov    %dl,0xf010b02c
	extern int idle_entry();
	
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	memset(&(tss), 0, sizeof(tss));
	tss.ts_esp0 = (uint32_t)bootstack + KSTKSIZE;
f01046f9:	c7 05 34 5e 11 f0 00 	movl   $0xf0115000,0xf0115e34
f0104700:	50 11 f0 
	tss.ts_ss0 = GD_KD;
f0104703:	66 c7 05 38 5e 11 f0 	movw   $0x10,0xf0115e38
f010470a:	10 00 

	// fs and gs stay in user data segment
	tss.ts_fs = GD_UD | 0x03;
f010470c:	66 c7 05 88 5e 11 f0 	movw   $0x23,0xf0115e88
f0104713:	23 00 
	tss.ts_gs = GD_UD | 0x03;
f0104715:	66 c7 05 8c 5e 11 f0 	movw   $0x23,0xf0115e8c
f010471c:	23 00 

	/* Setup TSS in GDT */
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t)(&tss), sizeof(struct tss_struct), 0);
f010471e:	66 c7 05 28 b0 10 f0 	movw   $0x68,0xf010b028
f0104725:	68 00 
f0104727:	c6 05 2e b0 10 f0 40 	movb   $0x40,0xf010b02e
f010472e:	a2 2f b0 10 f0       	mov    %al,0xf010b02f
	gdt[GD_TSS0 >> 3].sd_s = 0;
f0104733:	c6 05 2d b0 10 f0 89 	movb   $0x89,0xf010b02d

	/* Setup first task */
	i = task_create();
f010473a:	e8 89 fc ff ff       	call   f01043c8 <task_create>
	cur_task = &(tasks[i]);

	/* For user program */
	setupvm(cur_task->pgdir, (uint32_t)UTEXT_start, UTEXT_SZ);
f010473f:	83 c4 0c             	add    $0xc,%esp
f0104742:	ff 35 58 8a 11 f0    	pushl  0xf0118a58
f0104748:	68 00 00 10 f0       	push   $0xf0100000
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t)(&tss), sizeof(struct tss_struct), 0);
	gdt[GD_TSS0 >> 3].sd_s = 0;

	/* Setup first task */
	i = task_create();
	cur_task = &(tasks[i]);
f010474d:	6b c0 58             	imul   $0x58,%eax,%eax

	/* For user program */
	setupvm(cur_task->pgdir, (uint32_t)UTEXT_start, UTEXT_SZ);
f0104750:	ff b0 30 87 11 f0    	pushl  -0xfee78d0(%eax)
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t)(&tss), sizeof(struct tss_struct), 0);
	gdt[GD_TSS0 >> 3].sd_s = 0;

	/* Setup first task */
	i = task_create();
	cur_task = &(tasks[i]);
f0104756:	8d 90 dc 86 11 f0    	lea    -0xfee7924(%eax),%edx
f010475c:	89 15 2c 5e 11 f0    	mov    %edx,0xf0115e2c

	/* For user program */
	setupvm(cur_task->pgdir, (uint32_t)UTEXT_start, UTEXT_SZ);
f0104762:	e8 3e f9 ff ff       	call   f01040a5 <setupvm>
	setupvm(cur_task->pgdir, (uint32_t)UDATA_start, UDATA_SZ);
f0104767:	83 c4 0c             	add    $0xc,%esp
f010476a:	a1 2c 5e 11 f0       	mov    0xf0115e2c,%eax
f010476f:	ff 35 54 8a 11 f0    	pushl  0xf0118a54
f0104775:	68 00 80 10 f0       	push   $0xf0108000
f010477a:	ff 70 54             	pushl  0x54(%eax)
f010477d:	e8 23 f9 ff ff       	call   f01040a5 <setupvm>
	setupvm(cur_task->pgdir, (uint32_t)UBSS_start, UBSS_SZ);
f0104782:	83 c4 0c             	add    $0xc,%esp
f0104785:	a1 2c 5e 11 f0       	mov    0xf0115e2c,%eax
f010478a:	ff 35 4c 8a 11 f0    	pushl  0xf0118a4c
f0104790:	68 00 c0 10 f0       	push   $0xf010c000
f0104795:	ff 70 54             	pushl  0x54(%eax)
f0104798:	e8 08 f9 ff ff       	call   f01040a5 <setupvm>
	setupvm(cur_task->pgdir, (uint32_t)URODATA_start, URODATA_SZ);
f010479d:	83 c4 0c             	add    $0xc,%esp
f01047a0:	a1 2c 5e 11 f0       	mov    0xf0115e2c,%eax
f01047a5:	ff 35 50 8a 11 f0    	pushl  0xf0118a50
f01047ab:	68 00 60 10 f0       	push   $0xf0106000
f01047b0:	ff 70 54             	pushl  0x54(%eax)
f01047b3:	e8 ed f8 ff ff       	call   f01040a5 <setupvm>
	cur_task->tf.tf_eip = (uint32_t)user_entry;
f01047b8:	a1 2c 5e 11 f0       	mov    0xf0115e2c,%eax
}

static __inline void
lgdt(void *p)
{
	__asm __volatile("lgdt (%0)" : : "r" (p));
f01047bd:	ba 68 b0 10 f0       	mov    $0xf010b068,%edx
f01047c2:	c7 40 38 54 15 10 f0 	movl   $0xf0101554,0x38(%eax)
f01047c9:	0f 01 12             	lgdtl  (%edx)
}

static __inline void
lldt(uint16_t sel)
{
	__asm __volatile("lldt %0" : : "r" (sel));
f01047cc:	31 d2                	xor    %edx,%edx
f01047ce:	0f 00 d2             	lldt   %dx
}

static __inline void
ltr(uint16_t sel)
{
	__asm __volatile("ltr %0" : : "r" (sel));
f01047d1:	b2 28                	mov    $0x28,%dl
f01047d3:	0f 00 da             	ltr    %dx
	lldt(0);

	// Load the TSS selector 
	ltr(GD_TSS0);

	cur_task->state = TASK_RUNNING;
f01047d6:	c7 40 50 02 00 00 00 	movl   $0x2,0x50(%eax)
}
f01047dd:	83 c4 1c             	add    $0x1c,%esp
f01047e0:	c3                   	ret    

f01047e1 <task_init>:
 */
void task_init()
{
  extern int user_entry();
	int i;
  UTEXT_SZ = (uint32_t)(UTEXT_end - UTEXT_start);
f01047e1:	b8 a8 18 10 f0       	mov    $0xf01018a8,%eax
/* TODO: Lab5
 * We've done the initialization for you,
 * please make sure you understand the code.
 */
void task_init()
{
f01047e6:	53                   	push   %ebx
  extern int user_entry();
	int i;
  UTEXT_SZ = (uint32_t)(UTEXT_end - UTEXT_start);
f01047e7:	2d 00 00 10 f0       	sub    $0xf0100000,%eax
/* TODO: Lab5
 * We've done the initialization for you,
 * please make sure you understand the code.
 */
void task_init()
{
f01047ec:	83 ec 08             	sub    $0x8,%esp
  extern int user_entry();
	int i;
  UTEXT_SZ = (uint32_t)(UTEXT_end - UTEXT_start);
  UDATA_SZ = (uint32_t)(UDATA_end - UDATA_start);
  UBSS_SZ = (uint32_t)(UBSS_end - UBSS_start);
  URODATA_SZ = (uint32_t)(URODATA_end - URODATA_start);
f01047ef:	bb dc 86 11 f0       	mov    $0xf01186dc,%ebx
 */
void task_init()
{
  extern int user_entry();
	int i;
  UTEXT_SZ = (uint32_t)(UTEXT_end - UTEXT_start);
f01047f4:	a3 58 8a 11 f0       	mov    %eax,0xf0118a58
  UDATA_SZ = (uint32_t)(UDATA_end - UDATA_start);
f01047f9:	b8 48 80 10 f0       	mov    $0xf0108048,%eax
f01047fe:	2d 00 80 10 f0       	sub    $0xf0108000,%eax
f0104803:	a3 54 8a 11 f0       	mov    %eax,0xf0118a54
  UBSS_SZ = (uint32_t)(UBSS_end - UBSS_start);
f0104808:	b8 00 a0 15 f0       	mov    $0xf015a000,%eax
f010480d:	2d 00 c0 10 f0       	sub    $0xf010c000,%eax
f0104812:	a3 4c 8a 11 f0       	mov    %eax,0xf0118a4c
  URODATA_SZ = (uint32_t)(URODATA_end - URODATA_start);
f0104817:	b8 88 61 10 f0       	mov    $0xf0106188,%eax
f010481c:	2d 00 60 10 f0       	sub    $0xf0106000,%eax
f0104821:	a3 50 8a 11 f0       	mov    %eax,0xf0118a50

	/* Initial task sturcture */
	for (i = 0; i < NR_TASKS; i++)
	{
		memset(&(tasks[i]), 0, sizeof(Task));
f0104826:	50                   	push   %eax
f0104827:	6a 58                	push   $0x58
f0104829:	6a 00                	push   $0x0
f010482b:	53                   	push   %ebx
f010482c:	e8 9e b9 ff ff       	call   f01001cf <memset>
  UDATA_SZ = (uint32_t)(UDATA_end - UDATA_start);
  UBSS_SZ = (uint32_t)(UBSS_end - UBSS_start);
  URODATA_SZ = (uint32_t)(URODATA_end - URODATA_start);

	/* Initial task sturcture */
	for (i = 0; i < NR_TASKS; i++)
f0104831:	83 c4 10             	add    $0x10,%esp
	{
		memset(&(tasks[i]), 0, sizeof(Task));
		tasks[i].state = TASK_FREE;
f0104834:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
f010483b:	83 c3 58             	add    $0x58,%ebx
  UDATA_SZ = (uint32_t)(UDATA_end - UDATA_start);
  UBSS_SZ = (uint32_t)(UBSS_end - UBSS_start);
  URODATA_SZ = (uint32_t)(URODATA_end - URODATA_start);

	/* Initial task sturcture */
	for (i = 0; i < NR_TASKS; i++)
f010483e:	81 fb 4c 8a 11 f0    	cmp    $0xf0118a4c,%ebx
f0104844:	75 e0                	jne    f0104826 <task_init+0x45>
		memset(&(tasks[i]), 0, sizeof(Task));
		tasks[i].state = TASK_FREE;

	}
	task_init_percpu();
}
f0104846:	83 c4 08             	add    $0x8,%esp
f0104849:	5b                   	pop    %ebx
	{
		memset(&(tasks[i]), 0, sizeof(Task));
		tasks[i].state = TASK_FREE;

	}
	task_init_percpu();
f010484a:	e9 80 fe ff ff       	jmp    f01046cf <task_init_percpu>
	...

f0104850 <do_puts>:
#include <kernel/syscall.h>
#include <kernel/trap.h>
#include <inc/stdio.h>

void do_puts(char *str, uint32_t len)
{
f0104850:	57                   	push   %edi
f0104851:	56                   	push   %esi
f0104852:	53                   	push   %ebx
	uint32_t i;
	for (i = 0; i < len; i++)
f0104853:	31 db                	xor    %ebx,%ebx
#include <kernel/syscall.h>
#include <kernel/trap.h>
#include <inc/stdio.h>

void do_puts(char *str, uint32_t len)
{
f0104855:	8b 7c 24 10          	mov    0x10(%esp),%edi
f0104859:	8b 74 24 14          	mov    0x14(%esp),%esi
	uint32_t i;
	for (i = 0; i < len; i++)
f010485d:	eb 11                	jmp    f0104870 <do_puts+0x20>
	{
		k_putch(str[i]);
f010485f:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
f0104863:	83 ec 0c             	sub    $0xc,%esp
#include <inc/stdio.h>

void do_puts(char *str, uint32_t len)
{
	uint32_t i;
	for (i = 0; i < len; i++)
f0104866:	43                   	inc    %ebx
	{
		k_putch(str[i]);
f0104867:	50                   	push   %eax
f0104868:	e8 0a d5 ff ff       	call   f0101d77 <k_putch>
#include <inc/stdio.h>

void do_puts(char *str, uint32_t len)
{
	uint32_t i;
	for (i = 0; i < len; i++)
f010486d:	83 c4 10             	add    $0x10,%esp
f0104870:	39 f3                	cmp    %esi,%ebx
f0104872:	72 eb                	jb     f010485f <do_puts+0xf>
	{
		k_putch(str[i]);
	}
}
f0104874:	5b                   	pop    %ebx
f0104875:	5e                   	pop    %esi
f0104876:	5f                   	pop    %edi
f0104877:	c3                   	ret    

f0104878 <do_getc>:

int32_t do_getc()
{
f0104878:	83 ec 0c             	sub    $0xc,%esp
	return k_getc();
}
f010487b:	83 c4 0c             	add    $0xc,%esp
	}
}

int32_t do_getc()
{
	return k_getc();
f010487e:	e9 f5 d3 ff ff       	jmp    f0101c78 <k_getc>

f0104883 <do_syscall>:
}

int32_t do_syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104883:	53                   	push   %ebx
	int32_t retVal = -1;
f0104884:	83 c8 ff             	or     $0xffffffff,%eax
{
	return k_getc();
}

int32_t do_syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104887:	83 ec 08             	sub    $0x8,%esp
f010488a:	8b 5c 24 10          	mov    0x10(%esp),%ebx
f010488e:	8b 54 24 14          	mov    0x14(%esp),%edx
f0104892:	8b 4c 24 18          	mov    0x18(%esp),%ecx
	int32_t retVal = -1;
	extern Task *cur_task;

	switch (syscallno)
f0104896:	83 fb 0b             	cmp    $0xb,%ebx
f0104899:	0f 87 98 00 00 00    	ja     f0104937 <do_syscall+0xb4>
f010489f:	ff 24 9d 74 77 10 f0 	jmp    *-0xfef888c(,%ebx,4)
    retVal = 0;
    break;

	}
	return retVal;
}
f01048a6:	83 c4 08             	add    $0x8,%esp
f01048a9:	5b                   	pop    %ebx
	{
	case SYS_fork:
		/* TODO: Lab 5
     * You can reference kernel/task.c, kernel/task.h
     */
        retVal =sys_fork();
f01048aa:	e9 be fc ff ff       	jmp    f010456d <sys_fork>
    retVal = 0;
    break;

	}
	return retVal;
}
f01048af:	83 c4 08             	add    $0x8,%esp
f01048b2:	5b                   	pop    %ebx
	}
}

int32_t do_getc()
{
	return k_getc();
f01048b3:	e9 c0 d3 ff ff       	jmp    f0101c78 <k_getc>
	case SYS_getc:
		retVal = do_getc();
		break;

	case SYS_puts:
		do_puts((char*)a1, a2);
f01048b8:	53                   	push   %ebx
f01048b9:	53                   	push   %ebx
f01048ba:	51                   	push   %ecx
f01048bb:	52                   	push   %edx
f01048bc:	e8 8f ff ff ff       	call   f0104850 <do_puts>
f01048c1:	eb 68                	jmp    f010492b <do_syscall+0xa8>

	case SYS_getpid:
		/* TODO: Lab 5
     * Get current task's pid
     */
        retVal = cur_task->task_id;
f01048c3:	a1 2c 5e 11 f0       	mov    0xf0115e2c,%eax
f01048c8:	8b 00                	mov    (%eax),%eax
		break;
f01048ca:	eb 6b                	jmp    f0104937 <do_syscall+0xb4>

	case SYS_getcid:
		/* Lab6: get current cpu's cid */
		retVal = thiscpu->cpu_id;
f01048cc:	e8 a6 02 00 00       	call   f0104b77 <cpunum>
f01048d1:	6b c0 74             	imul   $0x74,%eax,%eax
f01048d4:	0f b6 80 04 90 11 f0 	movzbl -0xfee6ffc(%eax),%eax
		break;
f01048db:	eb 5a                	jmp    f0104937 <do_syscall+0xb4>
	case SYS_sleep:
		/* TODO: Lab 5
     * Yield this task
     * You can reference kernel/sched.c for yielding the task
     */ 
        cur_task->remind_ticks = a1;
f01048dd:	a1 2c 5e 11 f0       	mov    0xf0115e2c,%eax
f01048e2:	89 50 4c             	mov    %edx,0x4c(%eax)
        cur_task->state = TASK_SLEEP;
f01048e5:	c7 40 50 03 00 00 00 	movl   $0x3,0x50(%eax)
        sched_yield();
f01048ec:	e8 8f 00 00 00       	call   f0104980 <sched_yield>
	return k_getc();
}

int32_t do_syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
	int32_t retVal = -1;
f01048f1:	83 c8 ff             	or     $0xffffffff,%eax
     * You can reference kernel/sched.c for yielding the task
     */ 
        cur_task->remind_ticks = a1;
        cur_task->state = TASK_SLEEP;
        sched_yield();
		break;
f01048f4:	eb 41                	jmp    f0104937 <do_syscall+0xb4>
	case SYS_kill:
		/* TODO: Lab 5
     * Kill specific task
     * You can reference kernel/task.c, kernel/task.h
     */
        sys_kill(a1);
f01048f6:	83 ec 0c             	sub    $0xc,%esp
f01048f9:	52                   	push   %edx
f01048fa:	e8 d8 fb ff ff       	call   f01044d7 <sys_kill>
f01048ff:	eb 2a                	jmp    f010492b <do_syscall+0xa8>
    retVal = 0;
    break;

	}
	return retVal;
}
f0104901:	83 c4 08             	add    $0x8,%esp
f0104904:	5b                   	pop    %ebx

  case SYS_get_num_free_page:
		/* TODO: Lab 5
     * You can reference kernel/mem.c
     */
    retVal = sys_get_num_free_page();
f0104905:	e9 0b f9 ff ff       	jmp    f0104215 <sys_get_num_free_page>
    retVal = 0;
    break;

	}
	return retVal;
}
f010490a:	83 c4 08             	add    $0x8,%esp
f010490d:	5b                   	pop    %ebx

  case SYS_get_num_used_page:
		/* TODO: Lab 5
     * You can reference kernel/mem.c
     */
    retVal = sys_get_num_used_page();
f010490e:	e9 2a f9 ff ff       	jmp    f010423d <sys_get_num_used_page>
    retVal = 0;
    break;

	}
	return retVal;
}
f0104913:	83 c4 08             	add    $0x8,%esp
f0104916:	5b                   	pop    %ebx

  case SYS_get_ticks:
		/* TODO: Lab 5
     * You can reference kernel/timer.c
     */
    retVal = sys_get_ticks();
f0104917:	e9 67 fa ff ff       	jmp    f0104383 <sys_get_ticks>

  case SYS_settextcolor:
		/* TODO: Lab 5
     * You can reference kernel/screen.c
     */
    sys_settextcolor((unsigned char) a1,(unsigned char) a2);
f010491c:	50                   	push   %eax
f010491d:	0f b6 c9             	movzbl %cl,%ecx
f0104920:	50                   	push   %eax
f0104921:	0f b6 d2             	movzbl %dl,%edx
f0104924:	51                   	push   %ecx
f0104925:	52                   	push   %edx
f0104926:	e8 42 d5 ff ff       	call   f0101e6d <sys_settextcolor>
    retVal = 0;
    break;
f010492b:	83 c4 10             	add    $0x10,%esp
f010492e:	eb 05                	jmp    f0104935 <do_syscall+0xb2>

  case SYS_cls:
		/* TODO: Lab 5
     * You can reference kernel/screen.c
     */
    sys_cls();
f0104930:	e8 ec d3 ff ff       	call   f0101d21 <sys_cls>
    retVal = 0;
f0104935:	31 c0                	xor    %eax,%eax
    break;

	}
	return retVal;
}
f0104937:	83 c4 08             	add    $0x8,%esp
f010493a:	5b                   	pop    %ebx
f010493b:	c3                   	ret    

f010493c <syscall_handler>:

static void syscall_handler(struct Trapframe *tf)
{
f010493c:	53                   	push   %ebx
f010493d:	83 ec 10             	sub    $0x10,%esp
f0104940:	8b 5c 24 18          	mov    0x18(%esp),%ebx
   * call do_syscall
   * Please remember to fill in the return value
   * HINT: You have to know where to put the return value
   */
    int32_t val;
    val = do_syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx, tf->tf_regs.reg_ebx, tf->tf_regs.reg_edi, tf->tf_regs.reg_esi); 
f0104944:	ff 73 04             	pushl  0x4(%ebx)
f0104947:	ff 33                	pushl  (%ebx)
f0104949:	ff 73 10             	pushl  0x10(%ebx)
f010494c:	ff 73 18             	pushl  0x18(%ebx)
f010494f:	ff 73 14             	pushl  0x14(%ebx)
f0104952:	ff 73 1c             	pushl  0x1c(%ebx)
f0104955:	e8 29 ff ff ff       	call   f0104883 <do_syscall>
    tf->tf_regs.reg_eax = val;
f010495a:	89 43 1c             	mov    %eax,0x1c(%ebx)


}
f010495d:	83 c4 28             	add    $0x28,%esp
f0104960:	5b                   	pop    %ebx
f0104961:	c3                   	ret    

f0104962 <syscall_init>:

void syscall_init()
{
f0104962:	83 ec 18             	sub    $0x18,%esp
  /* TODO: Lab5
   * Please set gate of system call into IDT
   * You can leverage the API register_handler in kernel/trap.c
   */
    extern void do_sys();
    register_handler( T_SYSCALL, &syscall_handler, &do_sys, 1, 3);
f0104965:	6a 03                	push   $0x3
f0104967:	6a 01                	push   $0x1
f0104969:	68 9a 22 10 f0       	push   $0xf010229a
f010496e:	68 3c 49 10 f0       	push   $0xf010493c
f0104973:	6a 30                	push   $0x30
f0104975:	e8 23 d7 ff ff       	call   f010209d <register_handler>

}
f010497a:	83 c4 2c             	add    $0x2c,%esp
f010497d:	c3                   	ret    
	...

f0104980 <sched_yield>:
//    
//    (cpu can only schedule tasks which in its runqueue!!) 
//    (do not schedule idle task if there are still another process can run)	
//
void sched_yield(void)
{   
f0104980:	55                   	push   %ebp
	extern Task *cur_task;
    volatile int next;
    while(1){
        next = (cur_task->task_id + i++)%NR_TASKS;
        if(i==NR_TASKS)
            i = 0;
f0104981:	31 ed                	xor    %ebp,%ebp
//    
//    (cpu can only schedule tasks which in its runqueue!!) 
//    (do not schedule idle task if there are still another process can run)	
//
void sched_yield(void)
{   
f0104983:	57                   	push   %edi
	extern Task tasks[];
	extern Task *cur_task;
    volatile int next;
    while(1){
        next = (cur_task->task_id + i++)%NR_TASKS;
f0104984:	bf 0a 00 00 00       	mov    $0xa,%edi
//    
//    (cpu can only schedule tasks which in its runqueue!!) 
//    (do not schedule idle task if there are still another process can run)	
//
void sched_yield(void)
{   
f0104989:	56                   	push   %esi
f010498a:	53                   	push   %ebx
f010498b:	83 ec 1c             	sub    $0x1c,%esp
	extern Task tasks[];
	extern Task *cur_task;
    volatile int next;
    while(1){
        next = (cur_task->task_id + i++)%NR_TASKS;
f010498e:	8b 35 2c 5e 11 f0    	mov    0xf0115e2c,%esi
f0104994:	8b 0d 70 b0 10 f0    	mov    0xf010b070,%ecx
f010499a:	8b 1e                	mov    (%esi),%ebx
f010499c:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
f010499f:	41                   	inc    %ecx
f01049a0:	99                   	cltd   
f01049a1:	f7 ff                	idiv   %edi
        if(i==NR_TASKS)
            i = 0;
f01049a3:	83 f9 0a             	cmp    $0xa,%ecx
f01049a6:	0f 44 cd             	cmove  %ebp,%ecx
{   
	extern Task tasks[];
	extern Task *cur_task;
    volatile int next;
    while(1){
        next = (cur_task->task_id + i++)%NR_TASKS;
f01049a9:	89 54 24 0c          	mov    %edx,0xc(%esp)
        if(i==NR_TASKS)
            i = 0;
        if(next == cur_task->task_id)
f01049ad:	8b 44 24 0c          	mov    0xc(%esp),%eax
f01049b1:	39 d8                	cmp    %ebx,%eax
f01049b3:	75 06                	jne    f01049bb <sched_yield+0x3b>
            if(cur_task->state==TASK_RUNNING)
f01049b5:	83 7e 50 02          	cmpl   $0x2,0x50(%esi)
f01049b9:	74 75                	je     f0104a30 <sched_yield+0xb0>
                break; 
        if(tasks[next].state==TASK_RUNNABLE)
f01049bb:	8b 44 24 0c          	mov    0xc(%esp),%eax
f01049bf:	6b c0 58             	imul   $0x58,%eax,%eax
f01049c2:	83 b8 2c 87 11 f0 01 	cmpl   $0x1,-0xfee78d4(%eax)
f01049c9:	75 d1                	jne    f010499c <sched_yield+0x1c>
        {
            cur_task =&(tasks[next]);
f01049cb:	8b 44 24 0c          	mov    0xc(%esp),%eax
        if(i==NR_TASKS)
            i = 0;
        if(next == cur_task->task_id)
            if(cur_task->state==TASK_RUNNING)
                break; 
        if(tasks[next].state==TASK_RUNNABLE)
f01049cf:	89 0d 70 b0 10 f0    	mov    %ecx,0xf010b070
        {
            cur_task =&(tasks[next]);
f01049d5:	6b c0 58             	imul   $0x58,%eax,%eax
f01049d8:	8d 90 dc 86 11 f0    	lea    -0xfee7924(%eax),%edx
            cur_task->state = TASK_RUNNING;
            cur_task->remind_ticks = TIME_QUANT;
f01049de:	c7 80 28 87 11 f0 64 	movl   $0x64,-0xfee78d8(%eax)
f01049e5:	00 00 00 
            lcr3(PADDR(cur_task->pgdir));
f01049e8:	8b 80 30 87 11 f0    	mov    -0xfee78d0(%eax),%eax
        if(next == cur_task->task_id)
            if(cur_task->state==TASK_RUNNING)
                break; 
        if(tasks[next].state==TASK_RUNNABLE)
        {
            cur_task =&(tasks[next]);
f01049ee:	89 15 2c 5e 11 f0    	mov    %edx,0xf0115e2c
            cur_task->state = TASK_RUNNING;
f01049f4:	c7 42 50 02 00 00 00 	movl   $0x2,0x50(%edx)
/* -------------- Inline Functions --------------  */

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01049fb:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104a00:	77 12                	ja     f0104a14 <sched_yield+0x94>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104a02:	50                   	push   %eax
f0104a03:	68 f6 64 10 f0       	push   $0xf01064f6
f0104a08:	6a 3e                	push   $0x3e
f0104a0a:	68 a4 77 10 f0       	push   $0xf01077a4
f0104a0f:	e8 40 f8 ff ff       	call   f0104254 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0104a14:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0104a19:	0f 22 d8             	mov    %eax,%cr3
            cur_task->remind_ticks = TIME_QUANT;
            lcr3(PADDR(cur_task->pgdir));
            env_pop_tf(&cur_task->tf);
f0104a1c:	83 ec 0c             	sub    $0xc,%esp
f0104a1f:	83 c2 08             	add    $0x8,%edx
f0104a22:	52                   	push   %edx
f0104a23:	e8 de d6 ff ff       	call   f0102106 <env_pop_tf>
f0104a28:	83 c4 10             	add    $0x10,%esp
f0104a2b:	e9 5e ff ff ff       	jmp    f010498e <sched_yield+0xe>
f0104a30:	89 0d 70 b0 10 f0    	mov    %ecx,0xf010b070

        

    }
            
}
f0104a36:	83 c4 1c             	add    $0x1c,%esp
f0104a39:	5b                   	pop    %ebx
f0104a3a:	5e                   	pop    %esi
f0104a3b:	5f                   	pop    %edi
f0104a3c:	5d                   	pop    %ebp
f0104a3d:	c3                   	ret    
	...

f0104a40 <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f0104a40:	8b 44 24 04          	mov    0x4(%esp),%eax
	lk->locked = 0;
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0104a44:	8b 54 24 08          	mov    0x8(%esp),%edx
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
	lk->locked = 0;
f0104a48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f0104a4e:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f0104a51:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0104a58:	c3                   	ret    

f0104a59 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0104a59:	55                   	push   %ebp
f0104a5a:	89 e5                	mov    %esp,%ebp
f0104a5c:	56                   	push   %esi
f0104a5d:	53                   	push   %ebx
f0104a5e:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this CPU is holding the lock.
static int
holding(struct spinlock *lock)
{
	return lock->locked && lock->cpu == thiscpu;
f0104a61:	83 3b 00             	cmpl   $0x0,(%ebx)
f0104a64:	74 36                	je     f0104a9c <spin_lock+0x43>
f0104a66:	8b 73 08             	mov    0x8(%ebx),%esi
f0104a69:	e8 09 01 00 00       	call   f0104b77 <cpunum>
f0104a6e:	6b c0 74             	imul   $0x74,%eax,%eax
f0104a71:	05 04 90 11 f0       	add    $0xf0119004,%eax
f0104a76:	39 c6                	cmp    %eax,%esi
f0104a78:	75 22                	jne    f0104a9c <spin_lock+0x43>
void
spin_lock(struct spinlock *lk)
{
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0104a7a:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0104a7d:	e8 f5 00 00 00       	call   f0104b77 <cpunum>
f0104a82:	83 ec 0c             	sub    $0xc,%esp
f0104a85:	53                   	push   %ebx
f0104a86:	50                   	push   %eax
f0104a87:	68 b3 77 10 f0       	push   $0xf01077b3
f0104a8c:	6a 39                	push   $0x39
f0104a8e:	68 dd 77 10 f0       	push   $0xf01077dd
f0104a93:	e8 bc f7 ff ff       	call   f0104254 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f0104a98:	f3 90                	pause  
f0104a9a:	eb 05                	jmp    f0104aa1 <spin_lock+0x48>
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1" :
f0104a9c:	ba 01 00 00 00       	mov    $0x1,%edx
f0104aa1:	89 d0                	mov    %edx,%eax
f0104aa3:	f0 87 03             	lock xchg %eax,(%ebx)
#endif

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
f0104aa6:	85 c0                	test   %eax,%eax
f0104aa8:	75 ee                	jne    f0104a98 <spin_lock+0x3f>
		asm volatile ("pause");

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0104aaa:	e8 c8 00 00 00       	call   f0104b77 <cpunum>
f0104aaf:	6b c0 74             	imul   $0x74,%eax,%eax
f0104ab2:	05 04 90 11 f0       	add    $0xf0119004,%eax
f0104ab7:	89 43 08             	mov    %eax,0x8(%ebx)
get_caller_pcs(uint32_t pcs[])
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
f0104aba:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f0104abc:	31 c0                	xor    %eax,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0104abe:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f0104ac4:	76 1a                	jbe    f0104ae0 <spin_lock+0x87>
			break;
		pcs[i] = ebp[1];          // saved %eip
f0104ac6:	8b 4a 04             	mov    0x4(%edx),%ecx
f0104ac9:	89 4c 83 0c          	mov    %ecx,0xc(%ebx,%eax,4)
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
	for (i = 0; i < 10; i++){
f0104acd:	40                   	inc    %eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
			break;
		pcs[i] = ebp[1];          // saved %eip
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0104ace:	8b 12                	mov    (%edx),%edx
{
	uint32_t *ebp;
	int i;

	ebp = (uint32_t *)read_ebp();
	for (i = 0; i < 10; i++){
f0104ad0:	83 f8 0a             	cmp    $0xa,%eax
f0104ad3:	75 e9                	jne    f0104abe <spin_lock+0x65>
f0104ad5:	eb 09                	jmp    f0104ae0 <spin_lock+0x87>
			break;
		pcs[i] = ebp[1];          // saved %eip
		ebp = (uint32_t *)ebp[0]; // saved %ebp
	}
	for (; i < 10; i++)
		pcs[i] = 0;
f0104ad7:	c7 44 83 0c 00 00 00 	movl   $0x0,0xc(%ebx,%eax,4)
f0104ade:	00 
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
			break;
		pcs[i] = ebp[1];          // saved %eip
		ebp = (uint32_t *)ebp[0]; // saved %ebp
	}
	for (; i < 10; i++)
f0104adf:	40                   	inc    %eax
f0104ae0:	83 f8 09             	cmp    $0x9,%eax
f0104ae3:	7e f2                	jle    f0104ad7 <spin_lock+0x7e>
	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
	get_caller_pcs(lk->pcs);
#endif
}
f0104ae5:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0104ae8:	5b                   	pop    %ebx
f0104ae9:	5e                   	pop    %esi
f0104aea:	5d                   	pop    %ebp
f0104aeb:	c3                   	ret    

f0104aec <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f0104aec:	56                   	push   %esi
f0104aed:	53                   	push   %ebx
f0104aee:	83 ec 34             	sub    $0x34,%esp
f0104af1:	8b 5c 24 40          	mov    0x40(%esp),%ebx

// Check whether this CPU is holding the lock.
static int
holding(struct spinlock *lock)
{
	return lock->locked && lock->cpu == thiscpu;
f0104af5:	83 3b 00             	cmpl   $0x0,(%ebx)
f0104af8:	74 2d                	je     f0104b27 <spin_unlock+0x3b>
f0104afa:	8b 73 08             	mov    0x8(%ebx),%esi
f0104afd:	e8 75 00 00 00       	call   f0104b77 <cpunum>
f0104b02:	6b c0 74             	imul   $0x74,%eax,%eax
f0104b05:	05 04 90 11 f0       	add    $0xf0119004,%eax
f0104b0a:	39 c6                	cmp    %eax,%esi
f0104b0c:	75 19                	jne    f0104b27 <spin_unlock+0x3b>
		memmove(pcs, lk->pcs, sizeof pcs);
		printk("CPU %d cannot release %s: held by CPU %d\nAcquired at:", cpunum(), lk->name, lk->cpu->cpu_id);
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f0104b0e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
f0104b15:	31 c0                	xor    %eax,%eax
	lk->cpu = 0;
f0104b17:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
f0104b1e:	f0 87 03             	lock xchg %eax,(%ebx)
	// Paper says that Intel 64 and IA-32 will not move a load
	// after a store. So lock->locked = 0 would work here.
	// The xchg being asm volatile ensures gcc emits it after
	// the above assignments (and after the critical section).
	xchg(&lk->locked, 0);
}
f0104b21:	83 c4 34             	add    $0x34,%esp
f0104b24:	5b                   	pop    %ebx
f0104b25:	5e                   	pop    %esi
f0104b26:	c3                   	ret    
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f0104b27:	50                   	push   %eax
f0104b28:	6a 28                	push   $0x28
f0104b2a:	8d 43 0c             	lea    0xc(%ebx),%eax
f0104b2d:	50                   	push   %eax
f0104b2e:	8d 44 24 14          	lea    0x14(%esp),%eax
f0104b32:	50                   	push   %eax
f0104b33:	e8 f6 b6 ff ff       	call   f010022e <memmove>
		printk("CPU %d cannot release %s: held by CPU %d\nAcquired at:", cpunum(), lk->name, lk->cpu->cpu_id);
f0104b38:	8b 43 08             	mov    0x8(%ebx),%eax
f0104b3b:	8b 5b 04             	mov    0x4(%ebx),%ebx
f0104b3e:	0f b6 30             	movzbl (%eax),%esi
f0104b41:	e8 31 00 00 00       	call   f0104b77 <cpunum>
f0104b46:	56                   	push   %esi
f0104b47:	53                   	push   %ebx
f0104b48:	50                   	push   %eax
f0104b49:	68 ef 77 10 f0       	push   $0xf01077ef
f0104b4e:	e8 d5 d7 ff ff       	call   f0102328 <printk>
		panic("spin_unlock");
f0104b53:	83 c4 1c             	add    $0x1c,%esp
f0104b56:	68 25 78 10 f0       	push   $0xf0107825
f0104b5b:	6a 54                	push   $0x54
f0104b5d:	68 dd 77 10 f0       	push   $0xf01077dd
f0104b62:	e8 ed f6 ff ff       	call   f0104254 <_panic>
	...

f0104b68 <lapicw>:
volatile uint32_t *lapic;

static void
lapicw(int index, int value)
{
	lapic[index] = value;
f0104b68:	8b 0d 60 8a 11 f0    	mov    0xf0118a60,%ecx
f0104b6e:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0104b71:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0104b73:	8b 41 20             	mov    0x20(%ecx),%eax
}
f0104b76:	c3                   	ret    

f0104b77 <cpunum>:
}

int
cpunum(void)
{
	if (lapic)
f0104b77:	8b 15 60 8a 11 f0    	mov    0xf0118a60,%edx
		return lapic[ID] >> 24;
	return 0;
f0104b7d:	31 c0                	xor    %eax,%eax
}

int
cpunum(void)
{
	if (lapic)
f0104b7f:	85 d2                	test   %edx,%edx
f0104b81:	74 06                	je     f0104b89 <cpunum+0x12>
		return lapic[ID] >> 24;
f0104b83:	8b 42 20             	mov    0x20(%edx),%eax
f0104b86:	c1 e8 18             	shr    $0x18,%eax
	return 0;
}
f0104b89:	c3                   	ret    

f0104b8a <lapic_init>:
	lapic[ID];  // wait for write to finish, by reading
}

void
lapic_init(void)
{
f0104b8a:	83 ec 0c             	sub    $0xc,%esp
	if (!lapicaddr)
f0104b8d:	a1 5c 8a 11 f0       	mov    0xf0118a5c,%eax
f0104b92:	85 c0                	test   %eax,%eax
f0104b94:	0f 84 19 01 00 00    	je     f0104cb3 <lapic_init+0x129>
		return;

	// lapicaddr is the physical address of the LAPIC's 4K MMIO
	// region.  Map it in to virtual memory so we can access it.
	if(!lapic)
f0104b9a:	83 3d 60 8a 11 f0 00 	cmpl   $0x0,0xf0118a60
f0104ba1:	75 15                	jne    f0104bb8 <lapic_init+0x2e>
		lapic = mmio_map_region(lapicaddr, 4096);
f0104ba3:	52                   	push   %edx
f0104ba4:	52                   	push   %edx
f0104ba5:	68 00 10 00 00       	push   $0x1000
f0104baa:	50                   	push   %eax
f0104bab:	e8 25 de ff ff       	call   f01029d5 <mmio_map_region>
f0104bb0:	83 c4 10             	add    $0x10,%esp
f0104bb3:	a3 60 8a 11 f0       	mov    %eax,0xf0118a60

	// Enable local APIC; set spurious interrupt vector.
	lapicw(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f0104bb8:	ba 27 01 00 00       	mov    $0x127,%edx
f0104bbd:	b8 3c 00 00 00       	mov    $0x3c,%eax
f0104bc2:	e8 a1 ff ff ff       	call   f0104b68 <lapicw>

	// The timer repeatedly counts down at bus frequency
	// from lapic[TICR] and then issues an interrupt.  
	// If we cared more about precise timekeeping,
	// TICR would be calibrated using an external time source.
	lapicw(TDCR, X1);
f0104bc7:	ba 0b 00 00 00       	mov    $0xb,%edx
f0104bcc:	b8 f8 00 00 00       	mov    $0xf8,%eax
f0104bd1:	e8 92 ff ff ff       	call   f0104b68 <lapicw>
	lapicw(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f0104bd6:	ba 20 00 02 00       	mov    $0x20020,%edx
f0104bdb:	b8 c8 00 00 00       	mov    $0xc8,%eax
f0104be0:	e8 83 ff ff ff       	call   f0104b68 <lapicw>
	lapicw(TICR, 10000000); 
f0104be5:	ba 80 96 98 00       	mov    $0x989680,%edx
f0104bea:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0104bef:	e8 74 ff ff ff       	call   f0104b68 <lapicw>
	//
	// According to Intel MP Specification, the BIOS should initialize
	// BSP's local APIC in Virtual Wire Mode, in which 8259A's
	// INTR is virtually connected to BSP's LINTIN0. In this mode,
	// we do not need to program the IOAPIC.
	if (thiscpu != bootcpu)//mask every cpu other than bootcpu
f0104bf4:	e8 7e ff ff ff       	call   f0104b77 <cpunum>
f0104bf9:	6b c0 74             	imul   $0x74,%eax,%eax
f0104bfc:	05 04 90 11 f0       	add    $0xf0119004,%eax
f0104c01:	39 05 a4 93 11 f0    	cmp    %eax,0xf01193a4
f0104c07:	74 0f                	je     f0104c18 <lapic_init+0x8e>
		lapicw(LINT0, MASKED);
f0104c09:	ba 00 00 01 00       	mov    $0x10000,%edx
f0104c0e:	b8 d4 00 00 00       	mov    $0xd4,%eax
f0104c13:	e8 50 ff ff ff       	call   f0104b68 <lapicw>

	// Disable NMI (LINT1) on all CPUs
	lapicw(LINT1, MASKED);//why?
f0104c18:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0104c1d:	ba 00 00 01 00       	mov    $0x10000,%edx
f0104c22:	e8 41 ff ff ff       	call   f0104b68 <lapicw>

	// Disable performance counter overflow interrupts
	// on machines that provide that interrupt entry.
	if (((lapic[VER]>>16) & 0xFF) >= 4)
f0104c27:	a1 60 8a 11 f0       	mov    0xf0118a60,%eax
f0104c2c:	8b 40 30             	mov    0x30(%eax),%eax
f0104c2f:	c1 e8 10             	shr    $0x10,%eax
f0104c32:	3c 03                	cmp    $0x3,%al
f0104c34:	76 0f                	jbe    f0104c45 <lapic_init+0xbb>
		lapicw(PCINT, MASKED);
f0104c36:	ba 00 00 01 00       	mov    $0x10000,%edx
f0104c3b:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0104c40:	e8 23 ff ff ff       	call   f0104b68 <lapicw>

	// Map error interrupt to IRQ_ERROR.
	lapicw(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0104c45:	ba 33 00 00 00       	mov    $0x33,%edx
f0104c4a:	b8 dc 00 00 00       	mov    $0xdc,%eax
f0104c4f:	e8 14 ff ff ff       	call   f0104b68 <lapicw>

	// Clear error status register (requires back-to-back writes).
	lapicw(ESR, 0);
f0104c54:	31 d2                	xor    %edx,%edx
f0104c56:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0104c5b:	e8 08 ff ff ff       	call   f0104b68 <lapicw>
	lapicw(ESR, 0);
f0104c60:	31 d2                	xor    %edx,%edx
f0104c62:	b8 a0 00 00 00       	mov    $0xa0,%eax
f0104c67:	e8 fc fe ff ff       	call   f0104b68 <lapicw>

	// Ack any outstanding interrupts.
	lapicw(EOI, 0);
f0104c6c:	31 d2                	xor    %edx,%edx
f0104c6e:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0104c73:	e8 f0 fe ff ff       	call   f0104b68 <lapicw>

	// Send an Init Level De-Assert to synchronize arbitration ID's.
	lapicw(ICRHI, 0);
f0104c78:	31 d2                	xor    %edx,%edx
f0104c7a:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0104c7f:	e8 e4 fe ff ff       	call   f0104b68 <lapicw>
	lapicw(ICRLO, BCAST | INIT | LEVEL);
f0104c84:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0104c89:	ba 00 85 08 00       	mov    $0x88500,%edx
f0104c8e:	e8 d5 fe ff ff       	call   f0104b68 <lapicw>
	while(lapic[ICRLO] & DELIVS)
f0104c93:	a1 60 8a 11 f0       	mov    0xf0118a60,%eax
f0104c98:	05 00 03 00 00       	add    $0x300,%eax
f0104c9d:	8b 10                	mov    (%eax),%edx
f0104c9f:	80 e6 10             	and    $0x10,%dh
f0104ca2:	75 f9                	jne    f0104c9d <lapic_init+0x113>
		;

	// Enable interrupts on the APIC (but not on the processor).
	lapicw(TPR, 0);
f0104ca4:	31 d2                	xor    %edx,%edx
f0104ca6:	b8 20 00 00 00       	mov    $0x20,%eax
}
f0104cab:	83 c4 0c             	add    $0xc,%esp
	lapicw(ICRLO, BCAST | INIT | LEVEL);
	while(lapic[ICRLO] & DELIVS)
		;

	// Enable interrupts on the APIC (but not on the processor).
	lapicw(TPR, 0);
f0104cae:	e9 b5 fe ff ff       	jmp    f0104b68 <lapicw>
}
f0104cb3:	83 c4 0c             	add    $0xc,%esp
f0104cb6:	c3                   	ret    

f0104cb7 <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f0104cb7:	83 3d 60 8a 11 f0 00 	cmpl   $0x0,0xf0118a60
f0104cbe:	74 0c                	je     f0104ccc <lapic_eoi+0x15>
		lapicw(EOI, 0);
f0104cc0:	31 d2                	xor    %edx,%edx
f0104cc2:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0104cc7:	e9 9c fe ff ff       	jmp    f0104b68 <lapicw>
f0104ccc:	c3                   	ret    

f0104ccd <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0104ccd:	56                   	push   %esi
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0104cce:	ba 70 00 00 00       	mov    $0x70,%edx
f0104cd3:	53                   	push   %ebx
f0104cd4:	b0 0f                	mov    $0xf,%al
f0104cd6:	83 ec 04             	sub    $0x4,%esp
f0104cd9:	8b 5c 24 14          	mov    0x14(%esp),%ebx
f0104cdd:	8a 4c 24 10          	mov    0x10(%esp),%cl
f0104ce1:	ee                   	out    %al,(%dx)
f0104ce2:	b0 0a                	mov    $0xa,%al
f0104ce4:	b2 71                	mov    $0x71,%dl
f0104ce6:	ee                   	out    %al,(%dx)
}

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0104ce7:	83 3d c8 86 11 f0 00 	cmpl   $0x0,0xf01186c8
f0104cee:	75 19                	jne    f0104d09 <lapic_startap+0x3c>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0104cf0:	68 67 04 00 00       	push   $0x467
f0104cf5:	68 e8 6a 10 f0       	push   $0xf0106ae8
f0104cfa:	68 99 00 00 00       	push   $0x99
f0104cff:	68 31 78 10 f0       	push   $0xf0107831
f0104d04:	e8 4b f5 ff ff       	call   f0104254 <_panic>
	wrv[0] = 0;
	wrv[1] = addr >> 4;

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0104d09:	89 ce                	mov    %ecx,%esi
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
	wrv[1] = addr >> 4;
f0104d0b:	89 d8                	mov    %ebx,%eax

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0104d0d:	c1 e6 18             	shl    $0x18,%esi
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
	wrv[1] = addr >> 4;
f0104d10:	c1 e8 04             	shr    $0x4,%eax

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0104d13:	89 f2                	mov    %esi,%edx
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
	wrv[1] = addr >> 4;
f0104d15:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0104d1b:	b8 c4 00 00 00       	mov    $0xc4,%eax
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f0104d20:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0104d27:	00 00 
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0104d29:	c1 eb 0c             	shr    $0xc,%ebx
	wrv[0] = 0;
	wrv[1] = addr >> 4;

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapicw(ICRHI, apicid << 24);
f0104d2c:	e8 37 fe ff ff       	call   f0104b68 <lapicw>
	lapicw(ICRLO, INIT | LEVEL | ASSERT);
f0104d31:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0104d36:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0104d3b:	e8 28 fe ff ff       	call   f0104b68 <lapicw>
	microdelay(200);
	lapicw(ICRLO, INIT | LEVEL);
f0104d40:	ba 00 85 00 00       	mov    $0x8500,%edx
f0104d45:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0104d4a:	e8 19 fe ff ff       	call   f0104b68 <lapicw>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0104d4f:	80 cf 06             	or     $0x6,%bh
	// Regular hardware is supposed to only accept a STARTUP
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
f0104d52:	89 f2                	mov    %esi,%edx
f0104d54:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0104d59:	e8 0a fe ff ff       	call   f0104b68 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0104d5e:	89 da                	mov    %ebx,%edx
f0104d60:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0104d65:	e8 fe fd ff ff       	call   f0104b68 <lapicw>
	// Regular hardware is supposed to only accept a STARTUP
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
f0104d6a:	89 f2                	mov    %esi,%edx
f0104d6c:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0104d71:	e8 f2 fd ff ff       	call   f0104b68 <lapicw>
		lapicw(ICRLO, STARTUP | (addr >> 12));
		microdelay(200);
	}
}
f0104d76:	83 c4 04             	add    $0x4,%esp
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0104d79:	89 da                	mov    %ebx,%edx
		microdelay(200);
	}
}
f0104d7b:	5b                   	pop    %ebx
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0104d7c:	b8 c0 00 00 00       	mov    $0xc0,%eax
		microdelay(200);
	}
}
f0104d81:	5e                   	pop    %esi
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapicw(ICRHI, apicid << 24);
		lapicw(ICRLO, STARTUP | (addr >> 12));
f0104d82:	e9 e1 fd ff ff       	jmp    f0104b68 <lapicw>

f0104d87 <lapic_ipi>:
	}
}

void
lapic_ipi(int vector)
{
f0104d87:	8b 54 24 04          	mov    0x4(%esp),%edx
	lapicw(ICRLO, OTHERS | FIXED | vector);
f0104d8b:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0104d90:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f0104d96:	e8 cd fd ff ff       	call   f0104b68 <lapicw>
	while (lapic[ICRLO] & DELIVS)
f0104d9b:	a1 60 8a 11 f0       	mov    0xf0118a60,%eax
f0104da0:	05 00 03 00 00       	add    $0x300,%eax
f0104da5:	8b 10                	mov    (%eax),%edx
f0104da7:	80 e6 10             	and    $0x10,%dh
f0104daa:	75 f9                	jne    f0104da5 <lapic_ipi+0x1e>
		;
}
f0104dac:	c3                   	ret    
f0104dad:	00 00                	add    %al,(%eax)
	...

f0104db0 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10	# kernel data segment selector

.code16           
.globl mpentry_start
mpentry_start:
	cli            
f0104db0:	fa                   	cli    

	xorw    %ax, %ax
f0104db1:	31 c0                	xor    %eax,%eax
	movw    %ax, %ds
f0104db3:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0104db5:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0104db7:	8e d0                	mov    %eax,%ss

	lgdt    MPBOOTPHYS(gdtdesc)
f0104db9:	0f 01 16             	lgdtl  (%esi)
f0104dbc:	74 70                	je     f0104e2e <_kaddr.clone.0+0x2>
	movl    %cr0, %eax
f0104dbe:	0f 20 c0             	mov    %cr0,%eax
	orl     $CR0_PE, %eax
f0104dc1:	66 83 c8 01          	or     $0x1,%ax
	movl    %eax, %cr0
f0104dc5:	0f 22 c0             	mov    %eax,%cr0

	ljmpl   $(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0104dc8:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f0104dce:	08 00                	or     %al,(%eax)

f0104dd0 <start32>:

.code32
start32:
	movw    $(PROT_MODE_DSEG), %ax
f0104dd0:	66 b8 10 00          	mov    $0x10,%ax
	movw    %ax, %ds
f0104dd4:	8e d8                	mov    %eax,%ds
	movw    %ax, %es
f0104dd6:	8e c0                	mov    %eax,%es
	movw    %ax, %ss
f0104dd8:	8e d0                	mov    %eax,%ss
	movw    $0, %ax
f0104dda:	66 b8 00 00          	mov    $0x0,%ax
	movw    %ax, %fs
f0104dde:	8e e0                	mov    %eax,%fs
	movw    %ax, %gs
f0104de0:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl    $(RELOC(entry_pgdir)), %eax
f0104de2:	b8 00 90 10 00       	mov    $0x109000,%eax
	movl    %eax, %cr3
f0104de7:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl    %cr0, %eax
f0104dea:	0f 20 c0             	mov    %cr0,%eax
	orl     $(CR0_PE|CR0_PG|CR0_WP), %eax
f0104ded:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl    %eax, %cr0
f0104df2:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl    mpentry_kstack, %esp
f0104df5:	8b 25 c0 86 11 f0    	mov    0xf01186c0,%esp
	movl    $0x0, %ebp       # nuke frame pointer
f0104dfb:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl    $mp_main, %eax
f0104e00:	b8 cf 19 10 f0       	mov    $0xf01019cf,%eax
	call    *%eax
f0104e05:	ff d0                	call   *%eax

f0104e07 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp     spin
f0104e07:	eb fe                	jmp    f0104e07 <spin>
f0104e09:	8d 76 00             	lea    0x0(%esi),%esi

f0104e0c <gdt>:
	...
f0104e14:	ff                   	(bad)  
f0104e15:	ff 00                	incl   (%eax)
f0104e17:	00 00                	add    %al,(%eax)
f0104e19:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0104e20:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

f0104e24 <gdtdesc>:
f0104e24:	17                   	pop    %ss
f0104e25:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f0104e2a <mpentry_end>:
	.word   0x17				# sizeof(gdt) - 1
	.long   MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0104e2a:	90                   	nop
	...

f0104e2c <_kaddr.clone.0>:
}

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0104e2c:	89 d1                	mov    %edx,%ecx
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
	return (physaddr_t)kva - KERNBASE;
}

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
f0104e2e:	83 ec 0c             	sub    $0xc,%esp
{
	if (PGNUM(pa) >= npages)
f0104e31:	c1 e9 0c             	shr    $0xc,%ecx
f0104e34:	3b 0d c8 86 11 f0    	cmp    0xf01186c8,%ecx
f0104e3a:	72 11                	jb     f0104e4d <_kaddr.clone.0+0x21>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0104e3c:	52                   	push   %edx
f0104e3d:	68 e8 6a 10 f0       	push   $0xf0106ae8
f0104e42:	50                   	push   %eax
f0104e43:	68 40 78 10 f0       	push   $0xf0107840
f0104e48:	e8 07 f4 ff ff       	call   f0104254 <_panic>
	return (void *)(pa + KERNBASE);
f0104e4d:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
}
f0104e53:	83 c4 0c             	add    $0xc,%esp
f0104e56:	c3                   	ret    

f0104e57 <mpsearch1>:
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0104e57:	57                   	push   %edi
f0104e58:	89 d7                	mov    %edx,%edi
f0104e5a:	56                   	push   %esi
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0104e5b:	89 c2                	mov    %eax,%edx
}

// Look for an MP structure in the len bytes at physical address addr.
static struct mp *
mpsearch1(physaddr_t a, int len)
{
f0104e5d:	53                   	push   %ebx
f0104e5e:	89 c6                	mov    %eax,%esi
	struct mp *mp = KADDR(a), *end = KADDR(a + len);
f0104e60:	b8 57 00 00 00       	mov    $0x57,%eax
f0104e65:	e8 c2 ff ff ff       	call   f0104e2c <_kaddr.clone.0>
f0104e6a:	8d 14 37             	lea    (%edi,%esi,1),%edx
f0104e6d:	89 c3                	mov    %eax,%ebx
f0104e6f:	b8 57 00 00 00       	mov    $0x57,%eax
f0104e74:	e8 b3 ff ff ff       	call   f0104e2c <_kaddr.clone.0>
f0104e79:	89 c6                	mov    %eax,%esi

	for (; mp < end; mp++)
f0104e7b:	eb 2a                	jmp    f0104ea7 <mpsearch1+0x50>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0104e7d:	50                   	push   %eax
f0104e7e:	6a 04                	push   $0x4
f0104e80:	68 52 78 10 f0       	push   $0xf0107852
f0104e85:	53                   	push   %ebx
f0104e86:	e8 41 b4 ff ff       	call   f01002cc <memcmp>
f0104e8b:	83 c4 10             	add    $0x10,%esp
f0104e8e:	85 c0                	test   %eax,%eax
f0104e90:	75 12                	jne    f0104ea4 <mpsearch1+0x4d>
f0104e92:	31 d2                	xor    %edx,%edx
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
		sum += ((uint8_t *)addr)[i];
f0104e94:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0104e98:	40                   	inc    %eax
		sum += ((uint8_t *)addr)[i];
f0104e99:	01 ca                	add    %ecx,%edx
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0104e9b:	83 f8 10             	cmp    $0x10,%eax
f0104e9e:	75 f4                	jne    f0104e94 <mpsearch1+0x3d>
mpsearch1(physaddr_t a, int len)
{
	struct mp *mp = KADDR(a), *end = KADDR(a + len);

	for (; mp < end; mp++)
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
f0104ea0:	84 d2                	test   %dl,%dl
f0104ea2:	74 09                	je     f0104ead <mpsearch1+0x56>
static struct mp *
mpsearch1(physaddr_t a, int len)
{
	struct mp *mp = KADDR(a), *end = KADDR(a + len);

	for (; mp < end; mp++)
f0104ea4:	83 c3 10             	add    $0x10,%ebx
f0104ea7:	39 f3                	cmp    %esi,%ebx
f0104ea9:	72 d2                	jb     f0104e7d <mpsearch1+0x26>
		if (memcmp(mp->signature, "_MP_", 4) == 0 &&
		    sum(mp, sizeof(*mp)) == 0)
			return mp;
	return NULL;
f0104eab:	31 db                	xor    %ebx,%ebx
}
f0104ead:	89 d8                	mov    %ebx,%eax
f0104eaf:	5b                   	pop    %ebx
f0104eb0:	5e                   	pop    %esi
f0104eb1:	5f                   	pop    %edi
f0104eb2:	c3                   	ret    

f0104eb3 <mp_init>:
	return conf;
}

void
mp_init(void)
{
f0104eb3:	55                   	push   %ebp
	struct mp *mp;

	static_assert(sizeof(*mp) == 16);

	// The BIOS data area lives in 16-bit segment 0x40.
	bda = (uint8_t *) KADDR(0x40 << 4);
f0104eb4:	ba 00 04 00 00       	mov    $0x400,%edx
	return conf;
}

void
mp_init(void)
{
f0104eb9:	57                   	push   %edi
	struct mp *mp;

	static_assert(sizeof(*mp) == 16);

	// The BIOS data area lives in 16-bit segment 0x40.
	bda = (uint8_t *) KADDR(0x40 << 4);
f0104eba:	b8 6f 00 00 00       	mov    $0x6f,%eax
	return conf;
}

void
mp_init(void)
{
f0104ebf:	56                   	push   %esi
f0104ec0:	53                   	push   %ebx
f0104ec1:	83 ec 0c             	sub    $0xc,%esp
	struct mpconf *conf;
	struct mpproc *proc;
	uint8_t *p;
	unsigned int i;

	bootcpu = &cpus[0];
f0104ec4:	c7 05 a4 93 11 f0 04 	movl   $0xf0119004,0xf01193a4
f0104ecb:	90 11 f0 
	struct mp *mp;

	static_assert(sizeof(*mp) == 16);

	// The BIOS data area lives in 16-bit segment 0x40.
	bda = (uint8_t *) KADDR(0x40 << 4);
f0104ece:	e8 59 ff ff ff       	call   f0104e2c <_kaddr.clone.0>

	// [MP 4] The 16-bit segment of the EBDA is in the two bytes
	// starting at byte 0x0E of the BDA.  0 if not present.
	if ((p = *(uint16_t *) (bda + 0x0E))) {
f0104ed3:	0f b7 50 0e          	movzwl 0xe(%eax),%edx
f0104ed7:	85 d2                	test   %edx,%edx
f0104ed9:	74 07                	je     f0104ee2 <mp_init+0x2f>
		p <<= 4;	// Translate from segment to PA
f0104edb:	89 d0                	mov    %edx,%eax
f0104edd:	c1 e0 04             	shl    $0x4,%eax
f0104ee0:	eb 0c                	jmp    f0104eee <mp_init+0x3b>
		if ((mp = mpsearch1(p, 1024)))
			return mp;
	} else {
		// The size of base memory, in KB is in the two bytes
		// starting at 0x13 of the BDA.
		p = *(uint16_t *) (bda + 0x13) * 1024;
f0104ee2:	0f b7 40 13          	movzwl 0x13(%eax),%eax
f0104ee6:	c1 e0 0a             	shl    $0xa,%eax
		if ((mp = mpsearch1(p - 1024, 1024)))
f0104ee9:	2d 00 04 00 00       	sub    $0x400,%eax
f0104eee:	ba 00 04 00 00       	mov    $0x400,%edx
f0104ef3:	e8 5f ff ff ff       	call   f0104e57 <mpsearch1>
f0104ef8:	85 c0                	test   %eax,%eax
f0104efa:	89 c3                	mov    %eax,%ebx
f0104efc:	75 19                	jne    f0104f17 <mp_init+0x64>
			return mp;
	}
	return mpsearch1(0xF0000, 0x10000);
f0104efe:	ba 00 00 01 00       	mov    $0x10000,%edx
f0104f03:	b8 00 00 0f 00       	mov    $0xf0000,%eax
f0104f08:	e8 4a ff ff ff       	call   f0104e57 <mpsearch1>
mpconfig(struct mp **pmp)
{
	struct mpconf *conf;
	struct mp *mp;

	if ((mp = mpsearch()) == 0)
f0104f0d:	85 c0                	test   %eax,%eax
		// starting at 0x13 of the BDA.
		p = *(uint16_t *) (bda + 0x13) * 1024;
		if ((mp = mpsearch1(p - 1024, 1024)))
			return mp;
	}
	return mpsearch1(0xF0000, 0x10000);
f0104f0f:	89 c3                	mov    %eax,%ebx
mpconfig(struct mp **pmp)
{
	struct mpconf *conf;
	struct mp *mp;

	if ((mp = mpsearch()) == 0)
f0104f11:	0f 84 d1 01 00 00    	je     f01050e8 <mp_init+0x235>
		return NULL;
	if (mp->physaddr == 0 || mp->type != 0) {
f0104f17:	8b 53 04             	mov    0x4(%ebx),%edx
f0104f1a:	85 d2                	test   %edx,%edx
f0104f1c:	74 06                	je     f0104f24 <mp_init+0x71>
f0104f1e:	80 7b 0b 00          	cmpb   $0x0,0xb(%ebx)
f0104f22:	74 0d                	je     f0104f31 <mp_init+0x7e>
		printk("SMP: Default configurations not implemented\n");
f0104f24:	83 ec 0c             	sub    $0xc,%esp
f0104f27:	68 57 78 10 f0       	push   $0xf0107857
f0104f2c:	e9 73 01 00 00       	jmp    f01050a4 <mp_init+0x1f1>
		return NULL;
	}
	conf = (struct mpconf *) KADDR(mp->physaddr);
f0104f31:	b8 90 00 00 00       	mov    $0x90,%eax
f0104f36:	e8 f1 fe ff ff       	call   f0104e2c <_kaddr.clone.0>
	if (memcmp(conf, "PCMP", 4) != 0) {
f0104f3b:	51                   	push   %ecx
		return NULL;
	if (mp->physaddr == 0 || mp->type != 0) {
		printk("SMP: Default configurations not implemented\n");
		return NULL;
	}
	conf = (struct mpconf *) KADDR(mp->physaddr);
f0104f3c:	89 c6                	mov    %eax,%esi
	if (memcmp(conf, "PCMP", 4) != 0) {
f0104f3e:	6a 04                	push   $0x4
f0104f40:	68 84 78 10 f0       	push   $0xf0107884
f0104f45:	50                   	push   %eax
f0104f46:	e8 81 b3 ff ff       	call   f01002cc <memcmp>
f0104f4b:	83 c4 10             	add    $0x10,%esp
f0104f4e:	85 c0                	test   %eax,%eax
f0104f50:	74 0d                	je     f0104f5f <mp_init+0xac>
		printk("SMP: Incorrect MP configuration table signature\n");
f0104f52:	83 ec 0c             	sub    $0xc,%esp
f0104f55:	68 89 78 10 f0       	push   $0xf0107889
f0104f5a:	e9 45 01 00 00       	jmp    f01050a4 <mp_init+0x1f1>
		return NULL;
	}
	if (sum(conf, conf->length) != 0) {
f0104f5f:	66 8b 4e 04          	mov    0x4(%esi),%cx
static uint8_t
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
f0104f63:	31 d2                	xor    %edx,%edx
	for (i = 0; i < len; i++)
f0104f65:	31 c0                	xor    %eax,%eax
	conf = (struct mpconf *) KADDR(mp->physaddr);
	if (memcmp(conf, "PCMP", 4) != 0) {
		printk("SMP: Incorrect MP configuration table signature\n");
		return NULL;
	}
	if (sum(conf, conf->length) != 0) {
f0104f67:	0f b7 f9             	movzwl %cx,%edi
f0104f6a:	eb 07                	jmp    f0104f73 <mp_init+0xc0>
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
		sum += ((uint8_t *)addr)[i];
f0104f6c:	0f b6 2c 06          	movzbl (%esi,%eax,1),%ebp
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0104f70:	40                   	inc    %eax
		sum += ((uint8_t *)addr)[i];
f0104f71:	01 ea                	add    %ebp,%edx
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0104f73:	39 f8                	cmp    %edi,%eax
f0104f75:	7c f5                	jl     f0104f6c <mp_init+0xb9>
	conf = (struct mpconf *) KADDR(mp->physaddr);
	if (memcmp(conf, "PCMP", 4) != 0) {
		printk("SMP: Incorrect MP configuration table signature\n");
		return NULL;
	}
	if (sum(conf, conf->length) != 0) {
f0104f77:	84 d2                	test   %dl,%dl
f0104f79:	74 0d                	je     f0104f88 <mp_init+0xd5>
		printk("SMP: Bad MP configuration checksum\n");
f0104f7b:	83 ec 0c             	sub    $0xc,%esp
f0104f7e:	68 ba 78 10 f0       	push   $0xf01078ba
f0104f83:	e9 1c 01 00 00       	jmp    f01050a4 <mp_init+0x1f1>
		return NULL;
	}
	if (conf->version != 1 && conf->version != 4) {
f0104f88:	8a 46 06             	mov    0x6(%esi),%al
f0104f8b:	3c 04                	cmp    $0x4,%al
f0104f8d:	74 14                	je     f0104fa3 <mp_init+0xf0>
f0104f8f:	3c 01                	cmp    $0x1,%al
f0104f91:	74 10                	je     f0104fa3 <mp_init+0xf0>
		printk("SMP: Unsupported MP version %d\n", conf->version);
f0104f93:	52                   	push   %edx
f0104f94:	0f b6 c0             	movzbl %al,%eax
f0104f97:	52                   	push   %edx
f0104f98:	50                   	push   %eax
f0104f99:	68 de 78 10 f0       	push   $0xf01078de
f0104f9e:	e9 01 01 00 00       	jmp    f01050a4 <mp_init+0x1f1>
		return NULL;
	}
	if (sum((uint8_t *)conf + conf->length, conf->xlength) != conf->xchecksum) {
f0104fa3:	0f b7 c9             	movzwl %cx,%ecx
f0104fa6:	0f b7 7e 28          	movzwl 0x28(%esi),%edi
static uint8_t
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
f0104faa:	31 d2                	xor    %edx,%edx
	}
	if (conf->version != 1 && conf->version != 4) {
		printk("SMP: Unsupported MP version %d\n", conf->version);
		return NULL;
	}
	if (sum((uint8_t *)conf + conf->length, conf->xlength) != conf->xchecksum) {
f0104fac:	8d 0c 0e             	lea    (%esi,%ecx,1),%ecx
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0104faf:	31 c0                	xor    %eax,%eax
f0104fb1:	eb 07                	jmp    f0104fba <mp_init+0x107>
		sum += ((uint8_t *)addr)[i];
f0104fb3:	0f b6 2c 01          	movzbl (%ecx,%eax,1),%ebp
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0104fb7:	40                   	inc    %eax
		sum += ((uint8_t *)addr)[i];
f0104fb8:	01 ea                	add    %ebp,%edx
sum(void *addr, int len)
{
	int i, sum;

	sum = 0;
	for (i = 0; i < len; i++)
f0104fba:	39 f8                	cmp    %edi,%eax
f0104fbc:	7c f5                	jl     f0104fb3 <mp_init+0x100>
	}
	if (conf->version != 1 && conf->version != 4) {
		printk("SMP: Unsupported MP version %d\n", conf->version);
		return NULL;
	}
	if (sum((uint8_t *)conf + conf->length, conf->xlength) != conf->xchecksum) {
f0104fbe:	38 56 2a             	cmp    %dl,0x2a(%esi)
f0104fc1:	74 0d                	je     f0104fd0 <mp_init+0x11d>
		printk("SMP: Bad MP configuration extended checksum\n");
f0104fc3:	83 ec 0c             	sub    $0xc,%esp
f0104fc6:	68 fe 78 10 f0       	push   $0xf01078fe
f0104fcb:	e9 d4 00 00 00       	jmp    f01050a4 <mp_init+0x1f1>

	bootcpu = &cpus[0];
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
	lapicaddr = conf->lapicaddr;
f0104fd0:	8b 46 24             	mov    0x24(%esi),%eax

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0104fd3:	8d 7e 2c             	lea    0x2c(%esi),%edi
f0104fd6:	31 ed                	xor    %ebp,%ebp
	unsigned int i;

	bootcpu = &cpus[0];
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
f0104fd8:	c7 05 00 90 11 f0 01 	movl   $0x1,0xf0119000
f0104fdf:	00 00 00 
	lapicaddr = conf->lapicaddr;
f0104fe2:	a3 5c 8a 11 f0       	mov    %eax,0xf0118a5c

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0104fe7:	eb 7e                	jmp    f0105067 <mp_init+0x1b4>
		switch (*p) {
f0104fe9:	8a 07                	mov    (%edi),%al
f0104feb:	84 c0                	test   %al,%al
f0104fed:	74 06                	je     f0104ff5 <mp_init+0x142>
f0104fef:	3c 04                	cmp    $0x4,%al
f0104ff1:	77 52                	ja     f0105045 <mp_init+0x192>
f0104ff3:	eb 4b                	jmp    f0105040 <mp_init+0x18d>
		case MPPROC:
			proc = (struct mpproc *)p;
			if (proc->flags & MPPROC_BOOT)
f0104ff5:	f6 47 03 02          	testb  $0x2,0x3(%edi)
f0104ff9:	74 11                	je     f010500c <mp_init+0x159>
				bootcpu = &cpus[ncpu];
f0104ffb:	6b 05 a8 93 11 f0 74 	imul   $0x74,0xf01193a8,%eax
f0105002:	05 04 90 11 f0       	add    $0xf0119004,%eax
f0105007:	a3 a4 93 11 f0       	mov    %eax,0xf01193a4
			if (ncpu < NCPU) {
f010500c:	a1 a8 93 11 f0       	mov    0xf01193a8,%eax
f0105011:	83 f8 07             	cmp    $0x7,%eax
f0105014:	7f 11                	jg     f0105027 <mp_init+0x174>
				cpus[ncpu].cpu_id = ncpu;
f0105016:	6b d0 74             	imul   $0x74,%eax,%edx
f0105019:	88 82 04 90 11 f0    	mov    %al,-0xfee6ffc(%edx)
				ncpu++;
f010501f:	40                   	inc    %eax
f0105020:	a3 a8 93 11 f0       	mov    %eax,0xf01193a8
f0105025:	eb 14                	jmp    f010503b <mp_init+0x188>
			} else {
				printk("SMP: too many CPUs, CPU %d disabled\n",
f0105027:	50                   	push   %eax
f0105028:	50                   	push   %eax
f0105029:	0f b6 47 01          	movzbl 0x1(%edi),%eax
f010502d:	50                   	push   %eax
f010502e:	68 2b 79 10 f0       	push   $0xf010792b
f0105033:	e8 f0 d2 ff ff       	call   f0102328 <printk>
f0105038:	83 c4 10             	add    $0x10,%esp
					proc->apicid);
			}
			p += sizeof(struct mpproc);
f010503b:	83 c7 14             	add    $0x14,%edi
			continue;
f010503e:	eb 26                	jmp    f0105066 <mp_init+0x1b3>
		case MPBUS:
		case MPIOAPIC:
		case MPIOINTR:
		case MPLINTR:
			p += 8;
f0105040:	83 c7 08             	add    $0x8,%edi
			continue;
f0105043:	eb 21                	jmp    f0105066 <mp_init+0x1b3>
		default:
			printk("mpinit: unknown config type %x\n", *p);
f0105045:	51                   	push   %ecx
f0105046:	0f b6 c0             	movzbl %al,%eax
f0105049:	51                   	push   %ecx
f010504a:	50                   	push   %eax
f010504b:	68 50 79 10 f0       	push   $0xf0107950
f0105050:	e8 d3 d2 ff ff       	call   f0102328 <printk>
			ismp = 0;
			i = conf->entry;
f0105055:	0f b7 6e 22          	movzwl 0x22(%esi),%ebp
f0105059:	83 c4 10             	add    $0x10,%esp
		case MPLINTR:
			p += 8;
			continue;
		default:
			printk("mpinit: unknown config type %x\n", *p);
			ismp = 0;
f010505c:	c7 05 00 90 11 f0 00 	movl   $0x0,0xf0119000
f0105063:	00 00 00 
	if ((conf = mpconfig(&mp)) == 0)
		return;
	ismp = 1;
	lapicaddr = conf->lapicaddr;

	for (p = conf->entries, i = 0; i < conf->entry; i++) {
f0105066:	45                   	inc    %ebp
f0105067:	0f b7 46 22          	movzwl 0x22(%esi),%eax
f010506b:	39 c5                	cmp    %eax,%ebp
f010506d:	0f 82 76 ff ff ff    	jb     f0104fe9 <mp_init+0x136>
			ismp = 0;
			i = conf->entry;
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f0105073:	a1 a4 93 11 f0       	mov    0xf01193a4,%eax
	if (!ismp) {
f0105078:	83 3d 00 90 11 f0 00 	cmpl   $0x0,0xf0119000
			ismp = 0;
			i = conf->entry;
		}
	}

	bootcpu->cpu_status = CPU_STARTED;
f010507f:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
	if (!ismp) {
f0105086:	75 23                	jne    f01050ab <mp_init+0x1f8>
		// Didn't like what we found; fall back to no MP.
		ncpu = 1;
		lapicaddr = 0;
		printk("SMP: configuration not found, SMP disabled\n");
f0105088:	83 ec 0c             	sub    $0xc,%esp
	}

	bootcpu->cpu_status = CPU_STARTED;
	if (!ismp) {
		// Didn't like what we found; fall back to no MP.
		ncpu = 1;
f010508b:	c7 05 a8 93 11 f0 01 	movl   $0x1,0xf01193a8
f0105092:	00 00 00 
		lapicaddr = 0;
f0105095:	c7 05 5c 8a 11 f0 00 	movl   $0x0,0xf0118a5c
f010509c:	00 00 00 
		printk("SMP: configuration not found, SMP disabled\n");
f010509f:	68 70 79 10 f0       	push   $0xf0107970
f01050a4:	e8 7f d2 ff ff       	call   f0102328 <printk>
f01050a9:	eb 3a                	jmp    f01050e5 <mp_init+0x232>
		return;
	}
	printk("SMP: CPU %d found %d CPU(s)\n", bootcpu->cpu_id,  ncpu);
f01050ab:	52                   	push   %edx
f01050ac:	ff 35 a8 93 11 f0    	pushl  0xf01193a8
f01050b2:	0f b6 00             	movzbl (%eax),%eax
f01050b5:	50                   	push   %eax
f01050b6:	68 9c 79 10 f0       	push   $0xf010799c
f01050bb:	e8 68 d2 ff ff       	call   f0102328 <printk>

	if (mp->imcrp) {
f01050c0:	83 c4 10             	add    $0x10,%esp
f01050c3:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
f01050c7:	74 1f                	je     f01050e8 <mp_init+0x235>
		// [MP 3.2.6.1] If the hardware implements PIC mode,
		// switch to getting interrupts from the LAPIC.
		printk("SMP: Setting IMCR to switch from PIC mode to symmetric I/O mode\n");
f01050c9:	83 ec 0c             	sub    $0xc,%esp
f01050cc:	68 b9 79 10 f0       	push   $0xf01079b9
f01050d1:	e8 52 d2 ff ff       	call   f0102328 <printk>
f01050d6:	ba 22 00 00 00       	mov    $0x22,%edx
f01050db:	b0 70                	mov    $0x70,%al
f01050dd:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01050de:	b2 23                	mov    $0x23,%dl
f01050e0:	ec                   	in     (%dx),%al
		outb(0x22, 0x70);   // Select IMCR
		outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
f01050e1:	83 c8 01             	or     $0x1,%eax
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01050e4:	ee                   	out    %al,(%dx)
f01050e5:	83 c4 10             	add    $0x10,%esp
	}
}
f01050e8:	83 c4 0c             	add    $0xc,%esp
f01050eb:	5b                   	pop    %ebx
f01050ec:	5e                   	pop    %esi
f01050ed:	5f                   	pop    %edi
f01050ee:	5d                   	pop    %ebp
f01050ef:	c3                   	ret    
