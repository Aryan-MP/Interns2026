/* JavaScript Document

Tooplate 2153 Fireworks Composer

https://www.tooplate.com/view/2153-fireworks-composer

*/

const canvas = document.getElementById('canvas');
const ctx = canvas.getContext('2d');

canvas.width = window.innerWidth;
canvas.height = window.innerHeight;

let particles = [];
let rockets = [];
let currentColor = '#FF5A6E';
let currentType = 'burst';
let autoShowInterval = null;

window.addEventListener('resize', () => {
   canvas.width = window.innerWidth;
   canvas.height = window.innerHeight;
});

// Color selection
document.querySelectorAll('.color-option').forEach(option => {
   option.addEventListener('click', () => {
      document.querySelectorAll('.color-option').forEach(o => o.classList.remove('active'));
      option.classList.add('active');
      currentColor = option.dataset.color;
   });
});

// Type selection
document.querySelectorAll('.type-btn').forEach(btn => {
   btn.addEventListener('click', () => {
      document.querySelectorAll('.type-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      currentType = btn.dataset.type;
   });
});

// Particle class
class Particle {
   constructor(x, y, color, type) {
      this.x = x;
      this.y = y;
      this.color = color;
      this.type = type;
      this.life = 1;
      this.decay = Math.random() * 0.011 + 0.0037;

      const angle = Math.random() * Math.PI * 2;
      const speed = Math.random() * 4 + 2;

      switch (type) {
         case 'burst':
            this.vx = Math.cos(angle) * speed;
            this.vy = Math.sin(angle) * speed;
            break;
         case 'ring':
            const ringSpeed = 3;
            this.vx = Math.cos(angle) * ringSpeed;
            this.vy = Math.sin(angle) * ringSpeed;
            this.decay = 0.005;
            break;
         case 'willow':
            this.vx = Math.cos(angle) * speed * 0.5;
            this.vy = Math.sin(angle) * speed * 0.3;
            this.gravity = 0.15;
            break;
         case 'spiral':
            this.angle = angle;
            this.radius = 0;
            this.radiusSpeed = 3;
            this.angleSpeed = 0.1;
            break;
      }

      this.size = Math.random() * 1.5 + 1;
      this.sparkle = Math.random() * Math.PI * 2;
      this.sparkleSpeed = Math.random() * 0.1 + 0.05;
      this.rotation = Math.random() * Math.PI * 2;
      this.rotationSpeed = (Math.random() - 0.5) * 0.2;
      this.brightness = Math.random() * 0.3 + 0.7;
      this.lastX = x;
      this.lastY = y;
   }

   update() {
      this.lastX = this.x;
      this.lastY = this.y;

      if (this.type === 'spiral') {
         this.angle += this.angleSpeed;
         this.radius += this.radiusSpeed;
         this.x += Math.cos(this.angle) * this.radiusSpeed;
         this.y += Math.sin(this.angle) * this.radiusSpeed;
      } else {
         this.x += this.vx;
         this.y += this.vy;

         if (this.type === 'willow') {
            this.vy += this.gravity;
         } else {
            this.vy += 0.05;
         }
      }

      this.life -= this.decay;
      this.size *= 0.985;
      this.sparkle += this.sparkleSpeed;
      this.rotation += this.rotationSpeed;
   }

   draw() {
      const twinkle = Math.sin(this.sparkle) * 0.5 + 0.5;
      const currentSize = this.size * (0.8 + twinkle * 0.4);

      // Brighten for first 75%, then fade out in last 25%
      let alpha;
      if (this.life > 0.25) {
         // First 75% of lifetime - gradually brighten
         alpha = Math.min(1, (1 - this.life) / 0.25 + 0.3) * this.brightness;
      } else {
         // Last 25% - fade out
         alpha = (this.life / 0.25) * this.brightness;
      }

      // Outer glow (smaller and subtler)
      ctx.globalAlpha = alpha * 0.3;
      ctx.fillStyle = this.color;
      ctx.shadowBlur = 12;
      ctx.shadowColor = this.color;
      ctx.beginPath();
      ctx.arc(this.x, this.y, currentSize * 2, 0, Math.PI * 2);
      ctx.fill();
      ctx.shadowBlur = 0;

      // Star shape
      ctx.translate(this.x, this.y);
      ctx.rotate(this.rotation);
      ctx.globalAlpha = alpha;

      // Bright core (small)
      ctx.fillStyle = '#FFFFFF';
      ctx.beginPath();
      ctx.arc(0, 0, currentSize * 0.3, 0, Math.PI * 2);
      ctx.fill();

      // Star cross (simple, smaller)
      ctx.fillStyle = this.color;
      ctx.fillRect(-currentSize, -currentSize * 0.2, currentSize * 2, currentSize * 0.4);
      ctx.fillRect(-currentSize * 0.2, -currentSize, currentSize * 0.4, currentSize * 2);

      // Sparkle flare (subtle)
      if (twinkle > 0.7) {
         ctx.globalAlpha = alpha * (twinkle - 0.7) * 1.5;
         ctx.fillStyle = '#FFFFFF';
         ctx.fillRect(-currentSize * 1.5, -currentSize * 0.1, currentSize * 3, currentSize * 0.2);
         ctx.fillRect(-currentSize * 0.1, -currentSize * 1.5, currentSize * 0.2, currentSize * 3);
      }

      ctx.setTransform(1, 0, 0, 1, 0, 0);
   }
}

// Rocket class - launches from bottom to target point
class Rocket {
   constructor(targetX, targetY, color, type) {
      this.x = targetX;
      this.y = canvas.height;
      this.targetX = targetX;
      this.targetY = targetY;
      this.color = color;
      this.type = type;

      // Calculate velocity to reach target (faster launch)
      const distance = Math.sqrt(Math.pow(targetX - this.x, 2) + Math.pow(targetY - this.y, 2));
      const duration = 40; // frames to reach target (was 60)
      this.vx = (targetX - this.x) / duration;
      this.vy = (targetY - this.y) / duration;

      this.life = 1;
      this.trail = [];
   }

   update() {
      this.trail.push({
         x: this.x,
         y: this.y
      });
      if (this.trail.length > 25) {
         this.trail.shift();
      }

      this.x += this.vx;
      this.y += this.vy;

      // Check if reached target
      const distanceToTarget = Math.sqrt(Math.pow(this.targetX - this.x, 2) + Math.pow(this.targetY - this.y, 2));
      if (distanceToTarget < 5) {
         this.life = 0;
         // Create firework explosion at this position
         createFireworkExplosion(this.x, this.y, this.type);
      }
   }

   draw() {
      // Draw trail with fading effect (newer parts brighter, older parts fade out)
      if (this.trail.length > 1) {
         for (let i = 0; i < this.trail.length - 1; i++) {
            const fadeAlpha = (i / this.trail.length) * 0.22;
            ctx.globalAlpha = fadeAlpha;
            ctx.strokeStyle = currentColor;
            ctx.lineWidth = 1;
            ctx.shadowBlur = 3;
            ctx.shadowColor = currentColor;
            ctx.beginPath();
            ctx.moveTo(this.trail[i].x, this.trail[i].y);
            ctx.lineTo(this.trail[i + 1].x, this.trail[i + 1].y);
            ctx.stroke();
         }
         ctx.shadowBlur = 0;
      }

      // Draw rocket head (smaller)
      ctx.globalAlpha = 1;
      ctx.fillStyle = '#FFFFFF';
      ctx.shadowBlur = 10;
      ctx.shadowColor = currentColor;
      ctx.beginPath();
      ctx.arc(this.x, this.y, 1.5, 0, Math.PI * 2);
      ctx.fill();
      ctx.shadowBlur = 0;
   }
}

// Spark class for extra realism
class Spark {
   constructor(x, y, color) {
      this.x = x;
      this.y = y;
      this.color = color;
      this.life = 1;
      this.decay = Math.random() * 0.014 + 0.007;

      const angle = Math.random() * Math.PI * 2;
      const speed = Math.random() * 2 + 0.5;
      this.vx = Math.cos(angle) * speed;
      this.vy = Math.sin(angle) * speed;
      this.size = Math.random() * 0.7 + 0.3;
   }

   update() {
      this.x += this.vx;
      this.y += this.vy;
      this.vy += 0.08;
      this.life -= this.decay;
   }

   draw() {
      ctx.globalAlpha = this.life;
      ctx.fillStyle = '#FFFFFF';
      ctx.shadowBlur = 6;
      ctx.shadowColor = this.color;
      ctx.beginPath();
      ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
      ctx.fill();
      ctx.shadowBlur = 0;
   }
}

function createFireworkExplosion(x, y, type) {
   const particleCount = type === 'ring' ? 16 : type === 'spiral' ? 12 : 32;
   // Brighter, more vibrant colors
   const colors = ['#FF5A6E', '#FFD700', '#3FE0A0', '#B377FF', '#FFFEF7'];

   for (let i = 0; i < particleCount; i++) {
      // 50% selected color, 50% random other colors
      const useSelectedColor = Math.random() < 0.5;
      const particleColor = useSelectedColor ? currentColor : colors[Math.floor(Math.random() * colors.length)];
      particles.push(new Particle(x, y, particleColor, type));
   }

   // Add sparks for extra realism
   const sparkCount = Math.floor(Math.random() * 4) + 2;
   for (let i = 0; i < sparkCount; i++) {
      const useSelectedColor = Math.random() < 0.5;
      const sparkColor = useSelectedColor ? currentColor : colors[Math.floor(Math.random() * colors.length)];
      particles.push(new Spark(x, y, sparkColor));
   }
}

function createFirework(x, y) {
   // Launch rocket from bottom that will create explosion on arrival
   rockets.push(new Rocket(x, y, currentColor, currentType));
}

canvas.addEventListener('click', (e) => {
   createFirework(e.clientX, e.clientY);
});

canvas.addEventListener('touchstart', (e) => {
   e.preventDefault();
   const touch = e.touches[0];
   createFirework(touch.clientX, touch.clientY);
});

// Auto show
let fireworkCount = 0;

const launchFirework = () => {
   fireworkCount++;

   const x = Math.random() * canvas.width;
   const y = Math.random() * canvas.height * 0.6 + 50;
   const colors = ['#FF5A6E', '#FFD700', '#3FE0A0', '#B377FF', '#FFFEF7'];
   const types = ['burst', 'ring', 'willow', 'spiral'];
   const randomColor = colors[Math.floor(Math.random() * colors.length)];
   const randomType = types[Math.floor(Math.random() * types.length)];

   // Store current selections
   const prevColor = currentColor;
   const prevType = currentType;

   // Set random for this firework
   currentColor = randomColor;
   currentType = randomType;

   // Launch rocket
   rockets.push(new Rocket(x, y, currentColor, currentType));

   // Restore selections
   currentColor = prevColor;
   currentType = prevType;

   // After 15 fireworks, add a 2-second pause
   if (fireworkCount % 15 === 0) {
      clearInterval(autoShowInterval);
      setTimeout(() => {
         if (document.getElementById('autoShow').classList.contains('playing')) {
            autoShowInterval = setInterval(launchFirework, 600);
         }
      }, 2000);
   }
};

document.getElementById('autoShow').addEventListener('click', function () {
   if (autoShowInterval) {
      clearInterval(autoShowInterval);
      autoShowInterval = null;
      fireworkCount = 0;
      this.classList.remove('playing');
      this.querySelector('.button-text').textContent = 'Play';
   } else {
      this.classList.add('playing');
      this.querySelector('.button-text').textContent = 'Stop';
      autoShowInterval = setInterval(launchFirework, 600);
   }
});

// Toggle UI visibility
document.getElementById('toggleUI').addEventListener('click', () => {
   document.body.classList.toggle('hide-ui');
});

// Fullscreen toggle
document.getElementById('fullscreenBtn').addEventListener('click', () => {
   if (!document.fullscreenElement) {
      document.documentElement.requestFullscreen();
   } else {
      if (document.exitFullscreen) {
         document.exitFullscreen();
      }
   }
});

function animate() {
   // Clear with stronger fade for crisp particles
   ctx.fillStyle = 'rgba(10, 10, 15, 0.5)';
   ctx.fillRect(0, 0, canvas.width, canvas.height);

   // Reset global alpha
   ctx.globalAlpha = 1;

   // Update and draw rockets
   for (let i = rockets.length - 1; i >= 0; i--) {
      rockets[i].update();
      if (rockets[i].life <= 0) {
         rockets.splice(i, 1);
      } else {
         rockets[i].draw();
      }
   }

   // Update all particles first
   for (let i = particles.length - 1; i >= 0; i--) {
      particles[i].update();
      if (particles[i].life <= 0) {
         particles.splice(i, 1);
      }
   }

   // Draw all particles
   for (let i = 0; i < particles.length; i++) {
      particles[i].draw();
   }

   // Cap total particles for performance
   if (particles.length > 3000) {
      particles = particles.slice(-2000);
   }

   requestAnimationFrame(animate);
}

animate();

// Initial instruction fade
setTimeout(() => {
   document.querySelector('.instructions').style.display = 'none';
}, 4000);

// Prevent auto-play fireworks from queuing when tab is hidden
document.addEventListener('visibilitychange', () => {
   if (document.hidden) {
      // Tab is hidden - stop auto play to prevent queue buildup
      if (autoShowInterval) {
         clearInterval(autoShowInterval);
      }
   } else {
      // Tab is visible again - restart auto play if it was running
      const autoShowBtn = document.getElementById('autoShow');
      if (autoShowBtn.classList.contains('playing')) {
         fireworkCount = 0; // Reset counter
         autoShowInterval = setInterval(launchFirework, 600);
      }
   }
});