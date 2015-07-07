module.exports = function(grunt) {
	grunt.loadNpmTasks("grunt-contrib-uglify");
	grunt.loadNpmTasks("grunt-contrib-watch");
	grunt.loadNpmTasks("grunt-contrib-jshint");
	grunt.loadNpmTasks("grunt-sitemap");
	grunt.initConfig({

//bleh, minification breaks angular 
//		uglify: {
//			target: {
//				files: [{
//					expand: true,
//					src: "src/dev/**/*.js",
//					dest: "src/js"
//				}]
//			}
//		},
		jshint: {
			target: { src: "src/dev/*.js" },
			options: { force: true }
		},
		//this fucking shit doesn't fucking work right either
		sitemap: {
			target: {
				pattern: ["**/*.html", "!node_modules/**", "!*old*/**"],
				siteRoot: "src/",
				homepage: "http://www.alicemaz.com/"//,
			//	extension: { required: false }
			}
		},
		watch: {
			js: {
				files: ["src/dev/*.js"],
				tasks: ["jshint"/*, "uglify" */]
			},
			html: {
				files: ["**/*.html"],
				tasks: ["sitemap"]
			}
		}
	});

	grunt.registerTask("default", ["watch"]);
};
