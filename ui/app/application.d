/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 3.0
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is the ArmageddonEngine library.
 *
 * The Initial Developer of the Original Code is
 * Vladimir Panteleev <vladimir@thecybershadow.net>
 * Portions created by the Initial Developer are Copyright (C) 2011
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of the
 * GNU General Public License Version 3 (the "GPL") or later, in which case
 * the provisions of the GPL are applicable instead of those above. If you
 * wish to allow use of your version of this file only under the terms of the
 * GPL, and not to allow others to use your version of this file under the
 * terms of the MPL, indicate your decision by deleting the provisions above
 * and replace them with the notice and other provisions required by the GPL.
 * If you do not delete the provisions above, a recipient may use your version
 * of this file under the terms of either the MPL or the GPL.
 *
 * ***** END LICENSE BLOCK ***** */

module ae.ui.app.application;

import ae.sys.desktop;
import ae.sys.config;
import ae.ui.shell.events;
import ae.ui.video.surface;

/// The purpose of this class is to allow the application to provide app-specific information to the framework.
// This class could theoretically be split up into more layers (ShellApplication, etc.)
class Application
{
	Config config;

	this()
	{
		config = new Config(getName(), getCompanyName());
	}

	// ************************** Application information **************************

	/// Returns a string containing the application name, as visible in the window caption and taskbar, and used in filesystem/registry paths.
	abstract string getName();

	/// Returns the company name (used for Windows registry paths).
	abstract string getCompanyName();

	// TODO: getIcon

	// ******************************** Entry point ********************************

	/// The application "main" function. The application can create a shell here.
	abstract int run(string[] args);

	// ************************** Default screen settings **************************

	void getDefaultFullScreenResolution(out uint x, out uint y)
	{
		static if (is(typeof(getDesktopResolution)))
			getDesktopResolution(x, y);
		else
			x = 1024, y = 768;
	}
	void getDefaultWindowSize(out uint x, out uint y) { x = 800; y = 600; }
	bool isFullScreenByDefault() { return false; }

	void getFullScreenResolution(out uint x, out uint y)
	{
		getDefaultFullScreenResolution(x, y);
		x = config.read("FullScreenX", x);
		y = config.read("FullScreenY", y);
	}

	void getWindowSize(out uint x, out uint y)
	{
		getDefaultWindowSize(x, y);
		x = config.read("WindowX", x);
		y = config.read("WindowY", y);
	}

	bool isFullScreen()
	{
		return config.read("FullScreen", isFullScreenByDefault());
	}

	// ****************************** Event handlers *******************************

	//void handleMouseEnter() {}
	//void handleMouseLeave() {}
	//void handleKeyboardFocus() {}
	//void handleKeyboardBlur() {}
	//void handleMinimize() {}
	//void handleRestore() {}

	//void handleKeyDown(Key key/*, modifiers? */, dchar character) {}
	//void handleKeyUp(Key key/*, modifiers? */) {}

	void handleMouseDown(uint x, uint y, MouseButton button) {}
	void handleMouseUp(uint x, uint y, MouseButton button) {}
	void handleMouseMove(uint x, uint y, MouseButtons buttons) {}
	//void handleMouseRelMove(int dx, int dy) {} /// when cursor is clipped

	//void handleResize(uint w, uint h) {}
	void handleQuit() {}

	// ********************************* Rendering *********************************

	void render(Surface s) {}
}

/// The application must initialise this with an instance of an Application implementation in a static constructor.
__gshared Application application;